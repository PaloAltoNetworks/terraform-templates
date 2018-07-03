
/*
  Create the VPC
*/
resource "aws_vpc" "main" {
  cidr_block = "${var.VPCCIDR}"
  tags = {
    "Application" = "${var.StackName}"
    "Network" = "MGMT"
    "Name" = "${var.VPCName}"
  }
}

resource "aws_subnet" "NewPublicSubnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.PublicCIDR_Block}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  #map_public_ip_on_launch = true
  tags {
        "Application" = "${var.StackName}"
        "Name" = "${join("", list(var.StackName, "NewPublicSubnet"))}"
  }
}
