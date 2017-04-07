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
        volume_size = "40"
        delete_on_termination = true
    }

    connection {
        user = "admin"
        key_file = "${var.pavm_key_path}"
    }
    # bootstrap
    user_data = "${var.pavm_user_data}"
    iam_instance_profile = "${var.pavm_iam_instance_profile}"
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