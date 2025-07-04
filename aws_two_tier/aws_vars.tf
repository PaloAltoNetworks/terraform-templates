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
  description = "panos byol 8.1.9.x version dated 08-14-2019"
  default =
    {
      "us-west-2"      =   "ami-01d3cf1cef1a0ad21",
      "ap-northeast-1" =   "ami-09bd7cdf45d0d71cd",
      "us-west-1"      =   "ami-04729560f2c6ec8b4",
      "ap-northeast-2" =   "ami-0adcb0cda3a791f03",
      "ap-southeast-1" =   "ami-0bdecbb021a4d989e",
      "ap-southeast-2" =   "ami-0ab6e099e1d1883a6",
      "eu-central-1"   =   "ami-023f9c215463e0822",
      "eu-west-1"      =   "ami-02cb9d170823ba747",
      "eu-west-2"      =   "ami-0466c0476b48f39dd",
      "sa-east-1"      =   "ami-0ecc83c824ea77377",
      "us-east-1"      =   "ami-058c36656fb0ee806",
      "us-east-2"      =   "ami-081445037ad293033",
      "ca-central-1"   =   "ami-09d8202b9a1ccdd5d",
      "ap-south-1"     =   "ami-07c3a22f080d7c830"
    }
}
variable "WebServerRegionMap" {
  type = "map"
  description = "amazon linux ami amzn-ami-hvm-2018.03.0.20190826-x86_64-gp2 released on 08-26-2019"
  default = {
    "us-east-1"        = "ami-00eb20669e0990cb4",
    "us-east-2"        = "ami-0c64dd618a49aeee8",
    "us-west-2"        = "ami-08d489468314a58df",
    "us-west-1"        = "ami-0bce08e823ed38bdd",
    "eu-west-1"        = "ami-028188d9b49b32a80",
    "eu-west-2"        = "ami-04de2b60dd25fbb2e",
    "eu-central-1"     = "ami-010fae13a16763bb4",
    "ap-northeast-1"   = "ami-0ab3e16f9c414dee7",
    "ap-southeast-1"   = "ami-05c859630889c79c8",
    "ap-southeast-2"   = "ami-07cc15c3ba6f8e287",
    "sa-east-1"        = "ami-0e2c2c29d8017dd99",
    "ca-central-1"     = "ami-04070f04f450607dc",
    "ap-south-1"       = "ami-02913db388613c3e1"
  }
}

variable "UbuntuRegionMap" {
  type = "map"
  description = "ubuntu xenial image version 16.04 dated 11-14-2019"
  default = {
      "us-west-2"      =  "ami-0bbe9b07c5fe8e86e",
      "ap-northeast-1" =  "ami-014cc8d7cb6d26dc8",
      "us-west-1"      =  "ami-0c0e5a396959508b0",
      "ap-northeast-2" =  "ami-004b3430b806f3b1a",
      "ap-southeast-1" =  "ami-08b3278ea6e379084",
      "ap-southeast-2" =  "ami-00d7116c396e73b04",
      "eu-central-1"   =  "ami-0062c497b55437b01",
      "eu-west-1"      =  "ami-0987ee37af7792903",
      "eu-west-2"      =  "ami-05945867d79b7d926",
      "sa-east-1"      =  "ami-0fb487b6f6ab53ff4",
      "us-east-1"      =  "ami-09f9d773751b9d606",
      "us-east-2"      =  "ami-0891395d749676c2e",
      "ca-central-1"   =  "ami-0086bcfbab4b22f60",
      "ap-south-1"     =  "ami-0f59afa4a22fad2f0"
  }
}
