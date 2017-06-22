data "aws_availability_zones" "available" {}

variable "aws_region" {}

variable "StackName" {}

variable "InstanceType" {
  default = "t2.medium"
}

variable "KeyPANWFirewall" {
  default = "LUFRPT1Zd2pYUGpkMUNrVEZlb3hROEQyUm95dXNGRkU9N0d4RGpTN2VZaVZYMVVoS253U0p6dlk3MkM0SDFySEh2UUR4Y3hzK2g3ST0="
}

variable "MinInstancesASG" {
  default = "1"
}

variable "MaximumInstancesASG" {
  default = "3"
}

variable "ScalingPeriod" {
  default = "900"
}

variable "ScaleUpThreshold" {
  default = "80"
}

variable "ScaleDownThreshold" {
  default = "20"
}

variable "ScalingParameter" {
  default = "ActiveSessions"
}

variable "KeyPANWPanorama" {}


variable "KeyDeLicense" {}

variable "MasterS3Bucket" {}

variable "FWInstanceType" {
  default = "c4.xlarge"
}

variable "PanFwAmiId" {}

variable "ELBName" {
  default = "public-elb"
}

variable "ILBName" {
  default = "private-ilb"
}

variable "KeyName" {
}

variable "SSHLocation" {
  default = "0.0.0.0/0"
}

variable "NumberOfAzs" {
  default = 2
}

variable "VpcAzs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "VPCName" {
  default = "panwVPC"
}

variable "VPCCIDR" {
  default = "192.168.0.0/16"
}

variable "MgmtSubnetIpBlocks" {
  type = "list"
  default = ["192.168.0.0/24", "192.168.10.0/24",
              "192.168.20.0/24", "192.168.30.0/24"]
}

variable "UntrustSubnetIpBlocks" {
  default = ["192.168.1.0/24", "192.168.11.0/24",
              "192.168.21.0/24", "192.168.31.0/24"]
  type = "list"
}

variable "TrustSubnetIpBlocks" {
  default = ["192.168.2.0/24", "192.168.12.0/24",
              "192.168.22.0/24", "192.168.32.0/24"]
}

variable "NATGWSubnetIpBlocks" {
  default = ["192.168.100.0/24", "192.168.101.0/24",
              "192.168.102.0/24", "192.168.103.0/24"]
}

variable "LambdaSubnetIpBlocks" {
  type = "list"
  default = ["192.168.200.0/24", "192.168.201.0/24",
              "192.168.202.0/24", "192.168.203.0/24"]
}

variable "NATGateway" {
  description = "1 = create AWS NAT Gateway in each AZ, 0 = Use EIPs (skip subnet CIDR for NAT/Lambda)"
}

variable "AWSInstanceType2Arch" {
  type = "map"
  default = {
    "t1.micro"    = "PV64"
    "t2.micro"    = "HVM64"
    "t2.small"    = "HVM64"
    "t2.medium"   = "HVM64"
    "m1.small"    = "PV64"
    "m1.medium"   = "PV64"
    "m1.large"    = "PV64"
    "m1.xlarge"   = "PV64"
    "m2.xlarge"   = "PV64"
    "m2.2xlarge"  = "PV64"
    "m2.4xlarge"  = "PV64"
    "m3.medium"   = "HVM64"
    "m3.large"    = "HVM64"
    "m3.xlarge"   = "HVM64"
    "m3.2xlarge"  = "HVM64"
    "c1.medium"   = "PV64"
    "c1.xlarge"   = "PV64"
    "c3.large"    = "HVM64"
    "c3.xlarge"   = "HVM64"
    "c3.2xlarge"  = "HVM64"
    "c3.4xlarge"  = "HVM64"
    "c3.8xlarge"  = "HVM64"
    "c4.large"    = "HVM64"
    "c4.xlarge"   = "HVM64"
    "c4.2xlarge"  = "HVM64"
    "c4.4xlarge"  = "HVM64"
    "c4.8xlarge"  = "HVM64"
    "g2.2xlarge"  = "HVMG2"
    "r3.large"    = "HVM64"
    "r3.xlarge"   = "HVM64"
    "r3.2xlarge"  = "HVM64"
    "r3.4xlarge"  = "HVM64"
    "r3.8xlarge"  = "HVM64"
    "i2.xlarge"   = "HVM64"
    "i2.2xlarge"  = "HVM64"
    "i2.4xlarge"  = "HVM64"
    "i2.8xlarge"  = "HVM64"
    "d2.xlarge"   = "HVM64"
    "d2.2xlarge"  = "HVM64"
    "d2.4xlarge"  = "HVM64"
    "d2.8xlarge"  = "HVM64"
    "hi1.4xlarge" = "HVM64"
    "hs1.8xlarge" = "HVM64"
    "cr1.8xlarge" = "HVM64"
    "cc2.8xlarge" = "HVM64"
  }
}

variable "BucketRegionMap" {
  type = "map"
  default =
    {
      "us-west-2" = "panw-aws-us-west-2"
      "us-west-1" = "panw-aws-us-west-1"
      "us-east-1" = "panw-aws-us-east-1"
      "us-east-2" = "panw-aws-us-east-2"
      "eu-west-1" = "panw-aws-eu-west-1"
      "eu-central-1"  = "panw-aws-eu-central-1"
      "ap-northeast-1" = "panw-aws-ap-northeast-1"
      "ap-northeast-2" = "panw-aws-ap-northeast-2"
      "ap-southeast-1" = "panw-aws-ap-southeast-1"
      "ap-southeast-2" = "panw-aws-ap-southeast-2"
      "sa-east-1" = "panw-aws-sa-east-1"
    }
}

variable "WebServerImageId" {}
