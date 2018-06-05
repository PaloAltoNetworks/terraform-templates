variable "acceptance_required" {
  default = "false"
}

variable "nlb_arns" {
  type = "list"
}

variable "allowed_principals" {
  type    = "list"
  default = ["*"]
}

variable "aws_region" {}
