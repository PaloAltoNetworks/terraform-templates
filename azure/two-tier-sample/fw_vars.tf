variable "resource_group_name" {}
variable "location" {}

variable "StorageAccountName" {}
variable "FirewallDnsName" {}
variable "WebServerDnsName" {}
variable "FirewallVmName" {}
variable "FirewallVmSize" {}
variable "FromGatewayLogin" {}

variable "storageAccountType" {
  default = "Standard_LRS"
}

variable "fwpublicIPName" {
  default = "fwPublicIP"
}

variable "publicIPAddressType" {
  default = "Dynamic"
}

variable "WebPublicIPName" {
  default = "WebPublicIP"
}

variable "IPAddressPrefix" {
  default = "10.5"
}

variable "routeTableWeb" {
  default = "Web-to-FW"
}

variable "routeTableDB" {
  default = "DB-to-FW"
}

variable "routeTableTrust" {
  default = "Trust-to-intranetwork"
}

variable "vnetName" {
  default = "fwVNET"
}

variable "subnet0Name" {
  default = "Mgmt"
}

variable "subnet1Name" {
  default = "Untrust"
}

variable "subnet2Name" {
  default = "Trust"
}

variable "subnet3Name" {
  default = "Web"
}

variable "subnet4Name" {
  default = "DB"
}

# Note internally there is an assumption
# for the two NSG to have the same name!
variable "nsgname-mgmt" {
  default = "DefaultNSG"
}

variable "nsgname-untrust" {
  default = "DefaultNSG"
}

variable "nicName" {
  default = "eth"
}

variable "fwSku" {
  default = "bundle2"
}

variable "fwOffer" {
  default = "vmseries1"
}

variable "fwPublisher" {
  default = "paloaltonetworks"
}

variable "adminUsername" {
  default = "paloalto"
}

variable "adminPassword" {
  default = "Pal0Alt0@123"
}

variable "web-vm-name" {
  default = "webserver-vm"
}

variable "db-vm-name" {
  default = "database-vm"
}

variable "gvmSize" {
  default = "Standard_A1"
}

variable "imagePublisher" {
  default = "Canonical"
}

variable "imageOffer" {
  default = "UbuntuServer"
}

variable "ubuntuOSVersion" {
  default = "16.04-LTS"
}
