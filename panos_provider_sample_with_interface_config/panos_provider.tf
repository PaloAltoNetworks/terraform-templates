provider "panos" {
  hostname = "${var.fw_ip}"
  username = "${var.username}"
  password = "${var.password}"
}
