# Palo Alto VM-Series Firewall
resource "aws_instance" "pavm" {
    ami = "${lookup(var.pavm_byol_ami_id, var.region)}"
    #ami = "${lookup(var.pavm_payg_bun2_ami_id, var.region)}"
    availability_zone = "${var.availability_zone}"
    tenancy = "default"
    ebs_optimized = false
    disable_api_termination = false
    instance_initiated_shutdown_behavior = "stop"
    instance_type = "${var.pavm_instance_type}"
    key_name = "${var.pavm_key_name}"
    monitoring = false
    vpc_security_group_ids = [ "${aws_security_group.default-security-gp.id}" ]
    subnet_id = "${aws_subnet.mgmt-subnet.id}"
    associate_public_ip_address = "${var.pavm_public_ip}"
    private_ip = "${var.pavm_mgmt_private_ip}"
    source_dest_check = false
    tags = {
        Name = "PAVM"
    }
    root_block_device = {
        volume_type = "gp2"
        volume_size = "65"
        delete_on_termination = true
    }

    connection {
        user = "admin"
        private_key = "${var.pavm_key_path}"
    }
    # bootstrap
    user_data = "vmseries-bootstrap-aws-s3bucket=${var.pavm_bootstrap_s3}"
    iam_instance_profile = "bootstrap_s3_profile"
}

# Untrust Interface
resource "aws_network_interface" "untrust_eni" {
    subnet_id = " ${aws_subnet.untrust-subnet.id}"
    private_ips = [ "${var.pavm_untrust_private_ip}" ]
    security_groups = [ "${aws_security_group.default-security-gp.id}" ]
    description = "PAVM untrust interface"
    source_dest_check = false
    tags = {
        Name = "PAVM_untrust_eni"
    }
    attachment = {
        instance = "${aws_instance.pavm.id}"
        device_index = 1
    }
}

# EIP for Untrust Interface
resource "aws_eip" "untrust_eip" {
    vpc = true
    network_interface = "${aws_network_interface.untrust_eni.id}"
    associate_with_private_ip = "${var.pavm_untrust_private_ip}"
    depends_on = [
        "aws_internet_gateway.pavm-igw"
    ]
}

# Trust Interface
resource "aws_network_interface" "trust_eni" {
    subnet_id = " ${aws_subnet.trust-subnet.id}"
    private_ips = [ "${var.pavm_trust_private_ip}" ]
    security_groups = [ "${aws_security_group.default-security-gp.id}" ]
    description = "PAVM trust interface"
    source_dest_check = false
    tags = {
        Name = "PAVM_trust_eni"
    }
    attachment = {
        instance = "${aws_instance.pavm.id}"
        device_index = 2
    }
}
resource "aws_iam_instance_profile" "bootstrap_s3_profile" {
  name = "bootstrap_s3_profile"
  role = "${aws_iam_role.bootstrap_s3_role.name}"
}

resource "aws_iam_role" "bootstrap_s3_role" {
  name = "bootstrap_s3_role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource aws_iam_role_policy "bootstrap_s3_role_policy" {
  name = "test_policy"
  role = "${aws_iam_role.bootstrap_s3_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.pavm_bootstrap_s3}",
                "arn:aws:s3:::${var.pavm_bootstrap_s3}/*"
            ]
        }
    ]
}
EOF
}

# Output data
output "general-Instance-ID" {
    value = "${aws_instance.pavm.id}"
}

output "ip-Management-Public-IP" {
    value = "${aws_instance.pavm.public_ip}"
}

output "ip-Management-Private-IP" {
    value = "${aws_instance.pavm.private_ip}"
}

output "ip-Untrust-Public-IP" {
    value = "${aws_eip.untrust_eip.public_ip}"
}

output "ip-Untrust-Private-IP" {
    value = "${aws_eip.untrust_eip.private_ip}"
}

output "ip-Trust-Private-IP" {
    value = "${aws_network_interface.trust_eni.private_ips}"
}