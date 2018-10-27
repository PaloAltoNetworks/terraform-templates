data "aws_availability_zones" "available" {}
variable "aws_region" {}
variable "WebCIDR_Block" {}
variable "PublicCIDR_Block" {}
variable "MasterS3Bucket" {}
variable "VPCName" {}
variable "VPCCIDR" {}
variable "ServerKeyName" {}
variable "StackName" {}
variable "fw_instance_size" {}
variable "PANFWRegionMap" {
  type = "map"
  default =
    {
      "us-west-2" = "ami-d424b5ac",
      "ap-northeast-1" =   "ami-57662d31",
      "us-west-1"      =   "ami-a95b4fc9",
      "ap-northeast-2" =   "ami-49bd1127",
      "ap-southeast-1" =   "ami-27baeb5b",
      "ap-southeast-2" =   "ami-00d61562",
      "eu-central-1"   =   "ami-55bfd73a",
      "eu-west-1"      =   "ami-a95b4fc9",
      "eu-west-2"      =   "ami-876a8de0",
      "sa-east-1"      =   "ami-9c0154f0",
      "us-east-1"      =   "ami-a2fa3bdf",
      "us-east-2"      =   "ami-11e1d774",
      "ca-central-1"   =   "ami-64038400",
      "ap-south-1"     =   "ami-e780d988"
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
