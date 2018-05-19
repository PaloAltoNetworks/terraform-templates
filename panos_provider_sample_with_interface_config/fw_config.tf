/* Note: This configuration of the firewall is expected to be 
 *       used along with a bootstrap configuration which configures
 *       the network interfaces by associating them with the correct zones,
 *       once the zones have been created. The bootstrap process also 
 *       configures the username and password which will be used to 
 *       configure the firewall.
 */

resource "panos_ethernet_interface" "ethernet_1_1" {
  name                      = "ethernet1/1"
  mode                      = "layer3"
  vsys                      = "vsys1"
  enable_dhcp               = true
  create_dhcp_default_route = true
}

resource "panos_ethernet_interface" "ethernet_1_2" {
  name                      = "ethernet1/2"
  mode                      = "layer3"
  vsys                      = "vsys1"
  enable_dhcp               = true
  create_dhcp_default_route = false
}

resource "panos_virtual_router" "default_vr" {
  name       = "default"
  interfaces = ["ethernet1/1", "ethernet1/2"]
  depends_on = ["panos_ethernet_interface.ethernet_1_1", "panos_ethernet_interface.ethernet_1_2"]
}

resource "panos_zone" "external" {
  name       = "external"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.ethernet_1_1.name}"]
}

resource "panos_zone" "web" {
  name       = "web"
  mode       = "layer3"
  interfaces = ["${panos_ethernet_interface.ethernet_1_2.name}"]
}

resource "panos_service_object" "service_tcp_221" {
  name             = "service-tcp-221"
  vsys             = "vsys1"
  protocol         = "tcp"
  description      = "Service object to map port 22 to 221"
  destination_port = "221"
}

resource "panos_nat_policy" "nat_rule_for_web_ssh" {
  name                  = "web_ssh"
  source_zones          = ["external"]
  destination_zone      = "external"
  source_addresses      = ["any"]
  destination_addresses = ["10.0.0.100"]
  service               = "service-tcp-221"
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "ethernet1/2"
  dat_address           = "10.0.1.101"
  dat_port              = "22"

  depends_on = ["panos_service_object.service_tcp_221", "panos_zone.external",
    "panos_zone.web",
    "panos_ethernet_interface.ethernet_1_2",
  ]
}

resource "panos_nat_policy" "nat_rule_for_web_http" {
  name                  = "web_http"
  source_zones          = ["external"]
  destination_zone      = "external"
  source_addresses      = ["any"]
  destination_addresses = ["10.0.0.100"]
  service               = "service-http"
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "ethernet1/2"
  dat_address           = "10.0.1.101"
  dat_port              = "80"
  depends_on            = ["panos_zone.external", "panos_zone.web", "panos_ethernet_interface.ethernet_1_2"]
}

resource "panos_nat_policy" "outbound_nat" {
  name                  = "NATAllOut"
  source_zones          = ["web"]
  destination_zone      = "external"
  source_addresses      = ["any"]
  destination_addresses = ["any"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "ethernet1/1"
  depends_on            = ["panos_zone.external", "panos_zone.web", "panos_ethernet_interface.ethernet_1_1"]
}

resource "panos_security_policies" "security_rules" {
  rule {
    name                  = "web traffic"
    source_zones          = ["external"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["web"]
    destination_addresses = ["any"]
    applications          = ["web-browsing"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "ssh traffic"
    source_zones          = ["external"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["web"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["service-tcp-221"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "allow all out"
    source_zones          = ["web"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["external"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "web traffic 2"
    source_zones          = ["external"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["web"]
    destination_addresses = ["any"]
    applications          = ["web-browsing"]
    services              = ["http-81"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "ssh traffic2"
    source_zones          = ["external"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["web"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["service-tcp-222"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "log default deny"
    source_zones          = ["external"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["web"]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    log_start             = true
    log_end               = true
    action                = "deny"
  }

  depends_on = ["panos_zone.external", "panos_zone.web", "panos_nat_policy.outbound_nat",
    "panos_nat_policy.nat_rule_for_web_http",
    "panos_nat_policy.nat_rule_for_web_ssh",
    "panos_virtual_router.default_vr",
  ]
}

resource "null_resource" "commit_fw" {
  triggers {
    version = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "./commit.sh ${var.fw_ip}"
  }
}

/*    ======================================================================================= */

resource "panos_service_object" "service_tcp_222" {
  name             = "service-tcp-222"
  vsys             = "vsys1"
  protocol         = "tcp"
  description      = "Service object to map port 22 to 222"
  destination_port = "222"
}

resource "panos_service_object" "http-81" {
  name             = "http-81"
  vsys             = "vsys1"
  protocol         = "tcp"
  description      = "Service object to map port 22 to 222"
  destination_port = "81"
}

resource "panos_nat_policy" "nat_rule_for_web_ssh2" {
  name                  = "web_ssh2"
  source_zones          = ["external"]
  destination_zone      = "external"
  source_addresses      = ["any"]
  destination_addresses = ["10.0.0.100"]
  service               = "service-tcp-222"
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "ethernet1/2"
  dat_address           = "10.0.1.102"
  dat_port              = "22"

  depends_on = ["panos_service_object.service_tcp_222"]
}

resource "panos_nat_policy" "nat_rule_for_web_http2" {
  name                  = "web_http2"
  source_zones          = ["external"]
  destination_zone      = "external"
  source_addresses      = ["any"]
  destination_addresses = ["10.0.0.100"]
  service               = "http-81"
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = "ethernet1/2"
  dat_address           = "10.0.1.102"
  dat_port              = "80"

  depends_on = ["panos_service_object.http-81"]
}
