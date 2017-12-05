# This file defines the various resources that will be deployed against Azure.

resource "azurerm_resource_group" "PAN_FW_RG" {
  name = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "PAN_FW_STG_AC" {
  name = "${join("", list(var.StorageAccountName, substr(md5(azurerm_resource_group.PAN_FW_RG.id), 0, 4)))}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  location = "${var.location}"
  account_type = "${var.storageAccountType}"
  account_replication_type = "LRS"
  account_tier = "Standard" 
}

resource "azurerm_public_ip" "PublicIP_0" {
  name = "${var.fwpublicIPName}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  public_ip_address_allocation = "${var.publicIPAddressType}"
  domain_name_label = "${join("", list(var.FirewallDnsName, substr(md5(azurerm_resource_group.PAN_FW_RG.id), 0, 4)))}"
}

resource "azurerm_public_ip" "PublicIP_1" {
  name = "${var.WebPublicIPName}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  public_ip_address_allocation = "${var.publicIPAddressType}"
  domain_name_label = "${join("", list(var.WebServerDnsName, substr(md5(azurerm_resource_group.PAN_FW_RG.id), 0, 4)))}"
}

resource "azurerm_network_security_group" "PAN_FW_NSG" {
  name                = "DefaultNSG"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  security_rule {
    name                       = "Allow-Outside-From-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.FromGatewayLogin}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Intra"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${join("", list(var.IPAddressPrefix, ".0.0/16"))}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deafult-Deny"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVnetOutbound"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.5.0.0/16"
    destination_address_prefix = "10.5.0.0/16"
  }

  security_rule {
    name                       = "AllowInternetOutbound"
    priority                   = 4001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "0.0.0.0/0"
  }

  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4095
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Production"
  }
}

resource "azurerm_route_table" "PAN_FW_RT_Trust" {
  name                = "${var.routeTableTrust}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  route {
    name           = "Trust-to-intranetwork"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  tags {
    environment = "Production"
  }
}

resource "azurerm_route_table" "PAN_FW_RT_Web" {
  name                = "${var.routeTableWeb}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  route {
    name           = "Web-to-Firewall-DB"
    address_prefix = "${join("", list(var.IPAddressPrefix, ".4.0/24"))}"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  route {
    name           = "Web-default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  tags {
    environment = "Production"
  }
}

resource "azurerm_route_table" "PAN_FW_RT_DB" {
  name                = "${var.routeTableDB}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  route {
    name           = "DB-to-Firewall-Web"
    address_prefix = "${join("", list(var.IPAddressPrefix, ".3.0/24"))}"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  route {
    name           = "DB-default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  tags {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "PAN_FW_VNET" {
  name                = "${join("", list(var.vnetName, substr(md5(azurerm_resource_group.PAN_FW_RG.id), 0, 4)))}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_space       = ["${join("", list(var.IPAddressPrefix, ".0.0/16"))}"]
  location            = "${var.location}"

  tags {
    environment = "Production"
  }
}

resource "azurerm_subnet" "PAN_FW_Subnet0" {
  name           = "${var.subnet0Name}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_prefix = "${join("", list(var.IPAddressPrefix, ".0.0/24"))}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
  virtual_network_name = "${azurerm_virtual_network.PAN_FW_VNET.name}"
}

resource "azurerm_subnet" "PAN_FW_Subnet1" {
  name           = "${var.subnet1Name}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_prefix = "${join("", list(var.IPAddressPrefix, ".1.0/24"))}"
  network_security_group_id = "${azurerm_network_security_group.PAN_FW_NSG.id}"
  virtual_network_name = "${azurerm_virtual_network.PAN_FW_VNET.name}"
}

resource "azurerm_subnet" "PAN_FW_Subnet3" {
  name           = "${var.subnet3Name}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_prefix = "${join("", list(var.IPAddressPrefix, ".3.0/24"))}"
  virtual_network_name = "${azurerm_virtual_network.PAN_FW_VNET.name}"
}

resource "azurerm_subnet" "PAN_FW_Subnet4" {
  name           = "${var.subnet4Name}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_prefix = "${join("", list(var.IPAddressPrefix, ".4.0/24"))}"
  virtual_network_name = "${azurerm_virtual_network.PAN_FW_VNET.name}"
}

resource "azurerm_subnet" "PAN_FW_Subnet2" {
  name           = "${var.subnet2Name}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  address_prefix = "${join("", list(var.IPAddressPrefix, ".2.0/24"))}"
  route_table_id = "${azurerm_route_table.PAN_FW_RT_Trust.id}"
  virtual_network_name = "${azurerm_virtual_network.PAN_FW_VNET.name}"
}

resource "azurerm_network_interface" "VNIC0" {
  name                = "${join("", list("FW", var.nicName, "0"))}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  depends_on          = ["azurerm_virtual_network.PAN_FW_VNET",
                          "azurerm_public_ip.PublicIP_0"]

  ip_configuration {
    name                          = "${join("", list("ipconfig", "0"))}"
    subnet_id                     = "${azurerm_subnet.PAN_FW_Subnet0.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${join("", list(var.IPAddressPrefix, ".0.4"))}"
    public_ip_address_id = "${azurerm_public_ip.PublicIP_0.id}"
  }

  tags {
    displayName = "${join("", list("NetworkInterfaces", "0"))}"
  }
}

resource "azurerm_network_interface" "VNIC1" {
  name                = "${join("", list("FW", var.nicName, "1"))}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  depends_on          = ["azurerm_virtual_network.PAN_FW_VNET"]

  enable_ip_forwarding = true
  ip_configuration {
    name                          = "${join("", list("ipconfig", "1"))}"
    subnet_id                     = "${azurerm_subnet.PAN_FW_Subnet1.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${join("", list(var.IPAddressPrefix, ".1.4"))}"
    public_ip_address_id = "${azurerm_public_ip.PublicIP_1.id}"
  }

  tags {
    displayName = "${join("", list("NetworkInterfaces", "1"))}"
  }
}

resource "azurerm_network_interface" "VNIC2" {
  name                = "${join("", list("FW", var.nicName, "2"))}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  depends_on          = ["azurerm_virtual_network.PAN_FW_VNET"]

  enable_ip_forwarding = true
  ip_configuration {
    name                          = "${join("", list("ipconfig", "2"))}"
    subnet_id                     = "${azurerm_subnet.PAN_FW_Subnet2.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${join("", list(var.IPAddressPrefix, ".2.4"))}"
  }

  tags {
    displayName = "${join("", list("NetworkInterfaces", "2"))}"
  }
}

resource "azurerm_network_interface" "VNIC0_Web" {
  name                = "${join("", list("Web", var.nicName, "0"))}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  depends_on          = ["azurerm_virtual_network.PAN_FW_VNET"]

  ip_configuration {
    name                          = "${join("", list("ipconfig", "3"))}"
    subnet_id                     = "${azurerm_subnet.PAN_FW_Subnet3.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${join("", list(var.IPAddressPrefix, ".3.5"))}"
  }

  tags {
    displayName = "${join("", list("NetworkInterfaces", "3"))}"
  }
}

resource "azurerm_network_interface" "VNIC0_DB" {
  name                = "${join("", list("DB", var.nicName, "0"))}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"
  depends_on          = ["azurerm_virtual_network.PAN_FW_VNET"]

  ip_configuration {
    name                          = "${join("", list("ipconfig", "4"))}"
    subnet_id                     = "${azurerm_subnet.PAN_FW_Subnet4.id}"
    private_ip_address_allocation = "static"
    private_ip_address = "${join("", list(var.IPAddressPrefix, ".4.5"))}"
  }

  tags {
    displayName = "${join("", list("NetworkInterfaces", "4"))}"
  }
}


resource "azurerm_virtual_machine" "PAN_FW_FW" {
  name                  = "${var.FirewallVmName}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.PAN_FW_RG.name}"
  vm_size               = "${var.FirewallVmSize}"

  depends_on = ["azurerm_network_interface.VNIC0",
                "azurerm_network_interface.VNIC1",
                "azurerm_network_interface.VNIC2"
                ]
  plan {
    name = "${var.fwSku}"
    publisher = "${var.fwPublisher}"
    product = "${var.fwOffer}"
  }

  storage_image_reference {
    publisher = "${var.fwPublisher}"
    offer     = "${var.fwOffer}"
    sku       = "${var.fwSku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${join("", list(var.FirewallVmName, "-osDisk"))}"
    vhd_uri       = "${azurerm_storage_account.PAN_FW_STG_AC.primary_blob_endpoint}vhds/${var.FirewallVmName}-${var.fwOffer}-${var.fwSku}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.FirewallVmName}"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  primary_network_interface_id = "${azurerm_network_interface.VNIC0.id}"
  network_interface_ids = ["${azurerm_network_interface.VNIC0.id}",
                           "${azurerm_network_interface.VNIC1.id}",
                           "${azurerm_network_interface.VNIC2.id}",
                          ]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "PAN_FW_Web" {
  name                  = "${var.web-vm-name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.PAN_FW_RG.name}"
  vm_size               = "${var.gvmSize}"

  depends_on = ["azurerm_network_interface.VNIC0", "azurerm_network_interface.VNIC1",
                  "azurerm_network_interface.VNIC2"]

  storage_image_reference {
    publisher = "${var.imagePublisher}"
    offer     = "${var.imageOffer}"
    sku       = "${var.ubuntuOSVersion}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "web-osdisk"
    vhd_uri       = "${azurerm_storage_account.PAN_FW_STG_AC.primary_blob_endpoint}vhds/osdisk-Web.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "web-server-vm"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  network_interface_ids = ["${azurerm_network_interface.VNIC0_Web.id}"]

  tags {
    environment = "staging"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "PAN_FW_DB" {
  name                  = "${var.db-vm-name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.PAN_FW_RG.name}"
  vm_size               = "${var.gvmSize}"

  depends_on = ["azurerm_network_interface.VNIC0", "azurerm_network_interface.VNIC1",
                  "azurerm_network_interface.VNIC2", "azurerm_network_interface.VNIC0_DB"]

  storage_image_reference {
    publisher = "${var.imagePublisher}"
    offer     = "${var.imageOffer}"
    sku       = "${var.ubuntuOSVersion}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "web-osdisk"
    vhd_uri       = "${azurerm_storage_account.PAN_FW_STG_AC.primary_blob_endpoint}vhds/osdisk-DB.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "database-vm"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  network_interface_ids = ["${azurerm_network_interface.VNIC0_DB.id}"]

  tags {
    environment = "staging"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine_extension" "PAN_FW_DB_EXT" {
  name                 = "db-vm-customscript"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.PAN_FW_RG.name}"
  virtual_machine_name = "${azurerm_virtual_machine.PAN_FW_DB.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
{
  "fileUris": ["https://raw.githubusercontent.com/PaloAltoNetworks/azure/master/two-tier-sample/config_mysql.py"],
  "commandToExecute": "python config_mysql.py"
}
SETTINGS
}

/*
resource "azurerm_virtual_machine_extension" "PAN_FW_WEB_EXT" {
  count = 0
  name                 = "web-vm-customscript"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.PAN_FW_RG.name}"
  virtual_machine_name = "${azurerm_virtual_machine.PAN_FW_Web.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/PaloAltoNetworks/azure/master/two-tier-sample/config-fw.py"],
      "commandToExecute": "python config-fw.py ${azurerm_public_ip.PublicIP_1.fqdn}"
    }
SETTINGS
} */

resource "azurerm_virtual_machine_extension" "PAN_FW_WEB_EXT_MIN" {
  name                 = "web-vm-customscript"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.PAN_FW_RG.name}"
  virtual_machine_name = "${azurerm_virtual_machine.PAN_FW_Web.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "fileUris": ["https://gist.githubusercontent.com/vinayvenkat/43e7f613a23152e22f5b3b1c960fd17c/raw/ce2f82e211377e8924f0777ba06d83558ece9441/config-fw.py"],
      "commandToExecute": "python config-fw.py ${azurerm_public_ip.PublicIP_1.fqdn}"
    }
SETTINGS
}

resource "azurerm_template_deployment" "DBlinkedTemplate" {
  name                = "DBlinkedTemplate"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  depends_on = [
    "azurerm_virtual_machine_extension.PAN_FW_DB_EXT",
    "azurerm_virtual_machine_extension.PAN_FW_WEB_EXT_MIN",
    "azurerm_virtual_network.PAN_FW_VNET",
    "azurerm_network_interface.VNIC0_DB",
    "azurerm_network_interface.VNIC0_Web",
    "azurerm_route_table.PAN_FW_RT_Web",
    "azurerm_route_table.PAN_FW_RT_DB"
  ]
  parameters {
    name = "${azurerm_virtual_network.PAN_FW_VNET.name}/${azurerm_subnet.PAN_FW_Subnet4.name}"
    location = "${var.location}"
    subnet4Prefix = "${join("", list(var.IPAddressPrefix, ".4.0/24"))}"
    route_table_id = "${azurerm_route_table.PAN_FW_RT_DB.id}"
  }

  template_body = <<DEPLOY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "name": {
          "type": "string"
        },
        "location": {
          "type": "string"
        },
        "subnet4Prefix": {
          "type": "string"
        },
        "route_table_id": {
          "type": "string"
        }
      },
      "resources": [
           {
              "apiVersion": "2015-05-01-preview",
              "type": "Microsoft.Network/virtualNetworks/subnets",
              "name": "[parameters('name')]",
              "location": "[parameters('location')]",
              "properties": {
                "mode": "Incremental",
                "addressPrefix": "[parameters('subnet4Prefix')]",
              "routeTable": {
                 "id": "[parameters('route_table_id')]"
                  }
              }
          }]
  }
DEPLOY

  deployment_mode = "Incremental"
}

resource "azurerm_template_deployment" "WeblinkedTemplate" {
  name                = "WeblinkedTemplate"
  resource_group_name = "${azurerm_resource_group.PAN_FW_RG.name}"

  depends_on = [
    "azurerm_template_deployment.DBlinkedTemplate"
  ]
  parameters {
    name = "${azurerm_virtual_network.PAN_FW_VNET.name}/${azurerm_subnet.PAN_FW_Subnet3.name}"
    location = "${var.location}"
    subnet3Prefix = "${join("", list(var.IPAddressPrefix, ".3.0/24"))}"
    route_table_id = "${azurerm_route_table.PAN_FW_RT_Web.id}"
  }

  template_body = <<DEPLOY
  {
      "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "name": {
          "type": "string"
        },
        "location": {
          "type": "string"
        },
        "subnet3Prefix": {
          "type": "string"
        },
        "route_table_id": {
          "type": "string"
        }
      },
      "resources": [
           {
              "apiVersion": "2015-05-01-preview",
              "type": "Microsoft.Network/virtualNetworks/subnets",
              "name": "[parameters('name')]",
              "location": "[parameters('location')]",
              "properties": {
                "mode": "Incremental",
                "addressPrefix": "[parameters('subnet3Prefix')]",
              "routeTable": {
                 "id": "[parameters('route_table_id')]"
                  }
              }
          }]
  }
DEPLOY

  deployment_mode = "Incremental"
}

output "FirewallIP" {
  value = "${join("", list("https://", "${azurerm_public_ip.PublicIP_0.ip_address}"))}"
}

output "FirewallFQDN" {
  value = "${join("", list("https://", "${azurerm_public_ip.PublicIP_0.fqdn}"))}"
}

output "WebIP" {
  value = "${join("", list("http://", "${azurerm_public_ip.PublicIP_1.ip_address}"))}"
}

output "WebFQDN" {
  value = "${join("", list("http://", "${azurerm_public_ip.PublicIP_1.fqdn}"))}"
}
