variable "service_name" {}
variable "vpc_endpoint_type" {}
variable "subscribing_vpc_id" {}
variable "aws_region" {}

variable "subnet_ids" {
  type = "list"
}
