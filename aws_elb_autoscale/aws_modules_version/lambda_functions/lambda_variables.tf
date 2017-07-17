variable "LambdaENISNSTopic" {}
variable "VPCSecurityGroup" {}
variable "LambdaENIQueue" {}
variable "MgmtSecurityGroup" {}
variable "TrustSecurityGroup" {}
variable "UntrustSecurityGroup" {}
variable "ASGNotifierRolePolicy" {}
variable "ASGNotifierRole" {}

variable "aws_region" {}

variable "NATGateway" {}

variable "SSHLocation" {}

variable "VPCID" {}

variable "AZSubnetIDLambda" {}

variable "AZSubnetIDNATGW" {}

variable "AZSubnetIDMgmt" {}

variable "AZSubnetIDUntrust" {}

variable "AZSubnetIDTrust" {}

variable "KeyName" {}

variable "FWInstanceType" {}

variable "PanFwAmiId" {}

variable "KeyDeLicense" {}

variable "MinInstancesASG" {}

variable "MaximumInstancesASG" {}

variable "ScaleUpThreshold" {}

variable "ScaleDownThreshold" {}

variable "ScalingParameter" {}

variable "ScalingPeriod" {}

variable "PanS3BucketTpl" {}

variable "BucketRegionMap" {
  type = "map"
}

variable "VersionMap" {
  type = "map"
}

variable "KeyMap" {
  type = "map"
}

variable "StackName" {}

variable "VPCCIDR" {}

variable "ELBName" {}

variable "ILBName" {}

variable "KeyPANWFirewall" {}

variable "KeyPANWPanorama" {}

variable "MasterS3Bucket" {}

variable "EmptySubnetID" {
  default = ""
}

variable "AddENILambda" {}
