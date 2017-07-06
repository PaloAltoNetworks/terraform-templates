resource "aws_security_group" "VPCSecurityGroup" {
  name        = "VPCSecurityGroup"
  description = "Security Group for within the VPC"
  vpc_id = "${var.VPCID}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${join("", list(var.StackName, "VPCSecurityGroup" ))}"
  }
}

resource "aws_security_group" "MgmtSecurityGroup" {
  name        = "MgmtSecurityGroup"
  description = "Enable SSH into MGMT interface"
  vpc_id = "${var.VPCID}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.SSHLocation}"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["${var.SSHLocation}"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.VPCCIDR}"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.VPCCIDR}"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${join("", list(var.StackName, "MgmtSecurityGroup" ))}"

  }
}

resource "aws_security_group" "UntrustSecurityGroup" {
  name        = "UntrustSecurityGroup"
  description = "Security Group for untrust interface"
  vpc_id = "${var.VPCID}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${join("", list(var.StackName, "UntrustSecurityGroup" ))}"
  }
}

resource "aws_security_group" "TrustSecurityGroup" {
  name        = "TrustSecurityGroup"
  description = "Security Group for trust interface"
  vpc_id = "${var.VPCID}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${join("", list(var.StackName, "TrustSecurityGroup" ))}"
  }
}

output "vpc_security_group_id" {
  value = "${aws_security_group.VPCSecurityGroup.id}"
}

output "mgmt_security_group_id" {
  value = "${aws_security_group.MgmtSecurityGroup.id}"
}

output "untrust_security_group_id" {
  value = "${aws_security_group.UntrustSecurityGroup.id}"
}

output "trust_security_group_id" {
  value = "${aws_security_group.TrustSecurityGroup.id}"
}
