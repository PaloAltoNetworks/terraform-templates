data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "WebCIDR_Block" {}
variable "PublicCIDR_Block" {}
variable "VPCName" {}
variable "VPCCIDR" {}
variable "ServerKeyName" {}
variable "StackName" {}
variable "admin_username" {
  description = "The username to interact with the firewall"
}
variable "admin_password" {
  description = "The password to interact with the firewall"
}
variable "aws_key_pair_id" {}
variable "PANFWRegionMap" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-7e8a9107",
      "ap-northeast-1" =   "ami-8705e6e1",
      "us-west-1"      =   "ami-be88a1de",
      "ap-northeast-2" =   "ami-48bc6526",
      "ap-southeast-1" =   "ami-0994066a",
      "ap-southeast-2" =   "ami-2ed3cc4d",
      "eu-central-1"   =   "ami-44f25e2b",
      "eu-west-1"      =   "ami-1c28c065",
      "eu-west-2"      =   "ami-c76d7ca3",
      "sa-east-1"      =   "ami-38641354",
      "us-east-1"      =   "ami-34ca984f",
      "us-east-2"      =   "ami-765e7e13",
      "ca-central-1"   =   "ami-0504bb61",
      "ap-south-1"     =   "ami-38fd8557"
    }
}
variable "WebServerRegionMap" {
  type = "map"
  default = {
    "us-east-1"        = "ami-1ecae776",
    "us-east-2"        = "ami-c55673a0",
    "us-west-2"        = "ami-e7527ed7",
    "us-west-1"        = "ami-d114f295",
    "eu-west-1"        = "ami-a10897d6",
    "eu-central-1"     = "ami-a8221fb5",
    "ap-northeast-1"   = "ami-cbf90ecb",
    "ap-southeast-1"   = "ami-68d8e93a",
    "ap-southeast-2"   = "ami-fd9cecc7",
    "sa-east-1"        = "ami-b52890a8",
    "cn-north-1"       = "ami-f239abcb"
  }
}

variable "UbuntuRegionMap" {
  type = "map"
  default = {
  "us-west-2"      =  "ami-efd0428f",
      "ap-northeast-1" =  "ami-afb09dc8",
      "us-west-1"      =  "ami-2afbde4a",
      "ap-northeast-2" =  "ami-66e33108",
      "ap-southeast-1" =  "ami-8fcc75ec",
      "ap-southeast-2" =  "ami-96666ff5",
      "eu-central-1"   =  "ami-060cde69",
      "eu-west-1"      =  "ami-a8d2d7ce",
      "eu-west-2"      =  "ami-f1d7c395",
      "sa-east-1"      =  "ami-4090f22c",
      "us-east-1"      =  "ami-80861296",
      "us-east-2"      =  "ami-618fab04",
      "ca-central-1"   =  "ami-b3d965d7",
      "ap-south-1"     =  "ami-c2ee9dad"
  }
}

variable "playbook_path" {
  default = "../../ansible-pan/ansible-playbooks/terraform_integration/aws_vm_series_config.yml"
}
