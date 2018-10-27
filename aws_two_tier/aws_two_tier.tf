
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

resource "aws_iam_role" "FirewallBootstrapRole2Tier" {
  name = "FirewallBootstrapRole2Tier"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "FirewallBootstrapRolePolicy2Tier" {
  name = "FirewallBootstrapRolePolicy2Tier"
  role = "${aws_iam_role.FirewallBootstrapRole2Tier.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.MasterS3Bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.MasterS3Bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "FirewallBootstrapInstanceProfile2Tier" {
  name  = "FirewallBootstrapInstanceProfile2Tier"
  role = "${aws_iam_role.FirewallBootstrapRole2Tier.name}"
  path = "/"
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

resource "aws_subnet" "NewWebSubnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.WebCIDR_Block}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  #map_public_ip_on_launch = true
  tags {
        "Application" = "${var.StackName}"
        "Name" = "${join("", list(var.StackName, "NewWebSubnet"))}"
  }
}

resource "aws_vpc_dhcp_options" "dopt21c7d043" {
  domain_name          = "us-west-2.compute.internal"
  domain_name_servers  = ["AmazonProvidedDNS"]
}

resource "aws_network_acl" "aclb765d6d2" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = [
                "${aws_subnet.NewPublicSubnet.id}",
                "${aws_subnet.NewWebSubnet.id}",
              ]
}

resource "aws_network_acl_rule" "acl1" {
  network_acl_id = "${aws_network_acl.aclb765d6d2.id}"
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "acl2" {
  network_acl_id = "${aws_network_acl.aclb765d6d2.id}"
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_route_table" "rtb059a2460" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "rtb049a2461" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_network_interface" "FWManagementNetworkInterface" {
  subnet_id       = "${aws_subnet.NewPublicSubnet.id}"
  security_groups = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips_count = 1
  private_ips = ["10.0.0.99"]
}

resource "aws_network_interface" "FWPublicNetworkInterface" {
  subnet_id       = "${aws_subnet.NewPublicSubnet.id}"
  security_groups = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips_count = 1
  private_ips = ["10.0.0.100"]

}

resource "aws_network_interface" "FWPrivate12NetworkInterface" {
  subnet_id       = "${aws_subnet.NewWebSubnet.id}"
  security_groups = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips_count = 1
  private_ips = ["10.0.1.11"]
}

resource "aws_network_interface" "WPNetworkInterface" {
  subnet_id       = "${aws_subnet.NewWebSubnet.id}"
  security_groups = ["${aws_security_group.sgWideOpen.id}"]
  source_dest_check = false
  private_ips_count = 1
  private_ips = ["10.0.1.101"]
}

resource "aws_eip" "PublicElasticIP" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "ManagementElasticIP" {
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    Network =  "MGMT"
    Name = "${join("-", list(var.StackName, "InternetGateway"))}"
  }
}

resource "aws_eip_association" "FWEIPManagementAssociation" {
  network_interface_id   = "${aws_network_interface.FWManagementNetworkInterface.id}"
  allocation_id = "${aws_eip.ManagementElasticIP.id}"
}

resource "aws_eip_association" "FWEIPPublicAssociation" {
  network_interface_id   = "${aws_network_interface.FWPublicNetworkInterface.id}"
  allocation_id = "${aws_eip.PublicElasticIP.id}"
}

resource "aws_route_table_association" "subnetroute2" {
  subnet_id      = "${aws_subnet.NewPublicSubnet.id}"
  route_table_id = "${aws_route_table.rtb049a2461.id}"
}

resource "aws_route" "route1" {
  route_table_id               = "${aws_route_table.rtb059a2460.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "route2" {
  route_table_id               = "${aws_route_table.rtb049a2461.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_vpc_dhcp_options_association" "dchpassoc1" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dopt21c7d043.id}"
}


resource "aws_security_group" "sgWideOpen" {
  name        = "sgWideOpen"
  description = "Wide open security group"
  vpc_id = "${aws_vpc.main.id}"

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
}

resource "aws_instance" "FWInstance" {
  disable_api_termination = false
  iam_instance_profile = "${aws_iam_instance_profile.FirewallBootstrapInstanceProfile2Tier.name}"
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized = true
  ami = "${var.PANFWRegionMap[var.aws_region]}"
  instance_type = "${var.fw_instance_size}"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    delete_on_termination = true
    volume_size = 60
  }

  key_name = "${var.ServerKeyName}"
  monitoring = false

  network_interface {
    device_index = 0
    network_interface_id = "${aws_network_interface.FWManagementNetworkInterface.id}"
  }

  network_interface {
    device_index = 1
    network_interface_id = "${aws_network_interface.FWPublicNetworkInterface.id}"
  }

  network_interface {
    device_index = 2
    network_interface_id = "${aws_network_interface.FWPrivate12NetworkInterface.id}"
  }


  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", var.MasterS3Bucket)))}"
}

resource "aws_instance" "WPWebInstance" {
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "stop"
  ami = "${var.UbuntuRegionMap[var.aws_region]}"
  instance_type = "t2.micro"

  key_name = "${var.ServerKeyName}"
  monitoring = false

  network_interface {
    #delete_on_termination = true
    device_index = 0
    network_interface_id = "${aws_network_interface.WPNetworkInterface.id}"
  }

  user_data = "${base64encode(join("", list(
  "#! /bin/bash\n",

          "exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1\n",
          "echo \"export new_routers='${aws_network_interface.FWPrivate12NetworkInterface.private_ips[0]}'\" >> /etc/dhcp/dhclient-enter-hooks.d/aws-default-route\n",
          "ifdown eth0\n",
          "ifup eth0\n",

          "while true\n",
          "  do\n",
          "   resp=$(curl -s -S -g --insecure \"https://${aws_eip.ManagementElasticIP.public_ip}/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=LUFRPT10VGJKTEV6a0R4L1JXd0ZmbmNvdUEwa25wMlU9d0N5d292d2FXNXBBeEFBUW5pV2xoZz09\")\n",
          "   echo $resp >> /tmp/pan.log\n",
          "   if [[ $resp == *\"[CDATA[yes\"* ]] ; then\n",
          "     break\n",
          "   fi\n",
          "  sleep 10s\n",
          "done\n",
          "apt-get update\n",
          "apt-get install -y apache2 wordpress\n"
  )))
  }"
}

resource "null_resource" "check_fw_ready" {
  triggers {
    key = "${aws_instance.FWInstance.id}"
  }

  provisioner "local-exec" {
    command = "./check_fw.sh ${aws_eip.ManagementElasticIP.public_ip}"
  }
}

output "FirewallManagementURL" {
  value = "${join("", list("https://", "${aws_eip.ManagementElasticIP.public_ip}"))}"
}

output "WebURL" {
  value = "${join("", list("http://", "${aws_eip.PublicElasticIP.public_ip}"))}"
}
