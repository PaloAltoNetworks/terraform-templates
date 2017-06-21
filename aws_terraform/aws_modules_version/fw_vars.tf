variable "aws_region" {}

variable "StackName" {}

variable "VPCCIDR" {
  type = "string"
  description = "Enter the VPC CIDR that you want to use"
}

variable "ELBName" {
  type = "string"
  description = "Enter the name of the Elastic Load Balancer"
  default = "public-elb"
}

variable "ILBName" {
  type = "string"
  description = "Enter the name of the Internal Load Balancer"
  default = "private-ilb"
}

variable "KeyPANWFirewall" {
  type = "string"
  description = "API Key associated to username/password of the VM-Series Firewall. By default it is admin/admin"
  default = "LUFRPT1Zd2pYUGpkMUNrVEZlb3hROEQyUm95dXNGRkU9N0d4RGpTN2VZaVZYMVVoS253U0p6dlk3MkM0SDFySEh2UUR4Y3hzK2g3ST0="
}

variable "KeyPANWPanorama" {
  type = "string"
  description = "API Key associated to username/password of the VM-Series Panorama. By default it is admin/admin"
}

variable "NATGateway" {
}

variable "MasterS3Bucket" {
  type = "string"
  description = "Enter the name of the Bootstrap S3 bucket having bootstrap config"
}

variable "SSHLocation" {
  type = "string"
}

variable "VPCID" {
  type = "string"
  description = "VPC ID to deploy the artifacts into."
}

variable "AZSubnetIDLambda" {
  description = "Subnet IDs of Lambda Function interface"
}

variable "AZSubnetIDNATGW" {
  description = "Subnet IDs of AWS NAT Gateway"
}

variable "AZSubnetIDMgmt" {
  description = "Enter Subnet ID for the mgmt interface for all the AZs"

}

variable "AZSubnetIDUntrust" {
  description = "Enter Subnet ID for the untrust interface for all the AZs"
}

variable "AZSubnetIDTrust" {
  description = "Enter Subnet ID for the trust interface for all the AZs"
}

variable "KeyName" {
  type = "string"
  description = "Amazone EC2 Key Pair"
}

variable "FWInstanceType" {
  type = "string"
  description = "Enter the instance type and size that you want for the AutoScaled VM-Series firewall"
  default = "m4.xlarge"
}

variable "PanFwAmiId" {
  type = "string"
  description = "Link to Ami Id lookup table: https://www.paloaltonetworks.com/documentation/global/compatibility-matrix/vm-series-firewalls/aws-cft-amazon-machine-images-ami-list"
}

variable "KeyDeLicense" {
  type = "string"
  description = "Key used to de-license the PAN FW"
}

variable "MinInstancesASG" {
  type = "string"
  default = "1"
  description = "Minimum number of VM-Series firewall the ASG"
}

variable "MaximumInstancesASG" {
  type = "string"
  default = "3"
  description = "Maximum number of VM-Series firewal in the ASG"
}

variable "ScaleUpThreshold" {
  type = "string"
  default = "80"
  description = "Value at which ScaleUp event would take place"
}

variable "ScaleDownThreshold" {
  description = "Value at which ScaleDown event would take place"
  type = "string"
  default = "40"
}

variable "ScalingParameter" {
  type = "string"
  default = "DataPlaneCPUUtilization"
  description = "Refer to guide for recommended values for ScaleUp and ScaleDown"
}

variable "ScalingPeriod" {
  type = "string"
  description = "The period in seconds over which the average statistic is applied. Must be multiple of 60"
  default = "900"
}

variable "PanS3BucketTpl" {
  type = "string"
  description = "VM-Series firewall Lambda/Scripts/CFT template S3 Bucket or your own in the same region"
}

variable "BucketRegionMap" {
  default = {
    "us-west-2"     = "panw-aws-us-west-2",
    "us-west-1"     = "panw-aws-us-west-1",
    "us-east-1"     = "panw-aws-us-east-1",
    "us-east-2"     = "panw-aws-us-east-2",
    "eu-west-1"     = "panw-aws-eu-west-1",
    "eu-central-1"   = "panw-aws-eu-central-1",
    "ap-northeast-1" = "panw-aws-ap-northeast-1",
    "ap-northeast-2" = "panw-aws-ap-northeast-2",
    "ap-southeast-1" = "panw-aws-ap-southeast-1",
    "ap-southeast-2" = "panw-aws-ap-southeast-2",
    "sa-east-1"      = "panw-aws-sa-east-1",
    "ap-south-1"     = "panw-aws-ap-south-1"
  }
}

variable "VersionMap" {
  default = {
    "Key" = "v1.2/panw-aws.zip"
  }
}

variable "KeyMap" {
  default = {
    "Key" = "panw-aws.zip"
  }
}
