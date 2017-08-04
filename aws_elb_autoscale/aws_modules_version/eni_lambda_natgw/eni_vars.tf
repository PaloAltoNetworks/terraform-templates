variable "StackName" {}
variable "NATGateway" {}
variable "LambdaExecutionRole" {}
variable "AZSubnetIDLambda" {}
variable "VPCSecurityGroup" {}
variable "PanS3BucketTpl" {}
variable "KeyMap" {
  type = "map"
}
variable "MasterS3Bucket" {}
variable "aws_region" {}
