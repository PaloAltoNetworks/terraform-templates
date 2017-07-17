variable "StackName" {}
variable "LambdaExecutionRole" {}
variable "NATGateway" {}
variable "PanS3BucketTpl" {}
variable "KeyMap" {
  type = "map"
}
variable "MasterS3Bucket" {}
variable "aws_region" {}
