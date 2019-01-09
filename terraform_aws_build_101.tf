provider "aws" {
  access_key = "AKIAIL7LVBFLG37UY6AA"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "terraform-vm02" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
#  description   = "new build EC2 terraform-vm02"
tags {
  Name	        = "terrfaform-vm02"
}}

resource "aws_instance" "terraform-vm01" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
tags {
  Name          = "terrfaform-vm01"
}}

resource "aws_eip" "ip-vm02" {
  instance = "${aws_instance.terraform-vm02.id}"
}

# New resource for the S3 bucket our application will use.
resource "aws_s3_bucket" "terraform-s301" {

# NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
# this name must be changed before applying this example to avoid naming
# conflicts.

  bucket = "terraform-getting-started-101"
  acl    = "private"
}

# Change the aws_instance we declared earlier to now include "depends_on"

resource "aws_eip" "ip-vm01" {
  instance = "${aws_instance.terraform-vm01.id}"

# Tells Terraform that this EC2 instance must be created only after the
# S3 bucket has been created.

  depends_on = ["aws_s3_bucket.terraform-s301"]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.terraform-web01.id}"
  allocation_id = "${aws_eip.terraform-web01.id}"
}

resource "aws_instance" "terraform-web01" {
  ami               = "ami-b374d5a5"
#availability_zone = "us-east-1"
  instance_type     = "t2.micro"

  tags {
    Name = "terraform-web01"
  }
}

resource "aws_eip" "terraform-web01" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc-web02" {
  instance_id   = "${aws_instance.terraform-web02.id}"
  allocation_id = "${aws_eip.terraform-web.id}"
}

resource "aws_instance" "terraform-web02" {
  ami               = "ami-b374d5a5"
#  availability_zone = "us-east-1"
  instance_type     = "t1.micro"

  tags {
    Name = "terraform-web02"
  }
}

resource "aws_eip" "terraform-web" {
  vpc = true
}

