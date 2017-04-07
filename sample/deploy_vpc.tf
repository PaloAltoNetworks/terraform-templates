# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

# Create VPC
resource "aws_vpc" "pavm-vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = true # needed to enable bootstrap and to resolve EIPs
    enable_dns_hostnames = false
    instance_tenancy = "${var.vpc_instance_tenancy}"
    tags {
        Name = "${var.vpc_name}"
    }
}

# Create Management subnet
resource "aws_subnet" "mgmt-subnet" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    cidr_block = "${var.mgmt_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = false
    tags {
        Name = "mgmt-subnet"
    }
}

# Create Untrust subnet
resource "aws_subnet" "untrust-subnet" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    cidr_block = "${var.untrust_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = true
    tags {
        Name = "untrust-subnet"
    }
}

# Create Trust subnet
resource "aws_subnet" "trust-subnet" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    cidr_block = "${var.trust_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = false
    tags {
        Name = "trust-subnet"
    }
}

/* */
# Create VPC Internet Gateway
resource "aws_internet_gateway" "pavm-igw" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "pavm-igw"
    }
}

# Create Management route table
resource "aws_route_table" "mgmt-routetable" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "mgmt-routetable"
    }
}

/* */
# Create default route for Management route table
resource "aws_route" "mgmt-default-route" {
    route_table_id = "${aws_route_table.mgmt-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pavm-igw.id}"
    depends_on = [
        "aws_route_table.mgmt-routetable",
        "aws_internet_gateway.pavm-igw"
    ]
}

# Associate Management route table to Management subnet
resource "aws_route_table_association" "mgmt-routetable-association" {
    subnet_id = "${aws_subnet.mgmt-subnet.id}"
    route_table_id = "${aws_route_table.mgmt-routetable.id}"
}

# Create Untrust route table
resource "aws_route_table" "untrust-routetable" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "untrust-routetable"
    }
}

/* */
# Create default route for Untrust route table
resource "aws_route" "untrust-default-route" {
    route_table_id = "${aws_route_table.untrust-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pavm-igw.id}"
    depends_on = [
        "aws_route_table.untrust-routetable",
        "aws_internet_gateway.pavm-igw"
    ]
}

# Associate Untrust route table to Untrust subnet
resource "aws_route_table_association" "untrust-routetable-association" {
    subnet_id = "${aws_subnet.untrust-subnet.id}"
    route_table_id = "${aws_route_table.untrust-routetable.id}"
}

# Create Trust route table
resource "aws_route_table" "trust-routetable" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "trust-routetable"
    }
}

# Associate Trust route table to Trust subnet
resource "aws_route_table_association" "trust-routetable-association" {
    subnet_id = "${aws_subnet.trust-subnet.id}"
    route_table_id = "${aws_route_table.trust-routetable.id}"
}

# Create default VPC Network ACL
resource "aws_network_acl" "default-network-acl" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    egress {
        protocol = "-1"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    subnet_ids = [
        "${aws_subnet.mgmt-subnet.id}",
        "${aws_subnet.untrust-subnet.id}",
        "${aws_subnet.trust-subnet.id}"
    ]
    tags {
        Name = "default ACL"
    }
}

# Create default VPC security group
resource "aws_security_group" "default-security-gp" {
    name = "pavm-allow-all"
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    description = "Allow all inbound traffic"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "pavm-allow-all"
    }
}

# Create an endpoint for S3 bucket
/*  Uncomment to enable */
resource "aws_vpc_endpoint" "private-s3" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    service_name = "com.amazonaws.us-east-1.s3"
    
    /*  Uncomment to enable policy
    policy = <<POLICY
    {
        "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::ha1-dev-paloalto/*"
        }
    ]
    }
    POLICY
    */

    route_table_ids = [
        "${aws_route_table.mgmt-routetable.id}"
        #"${aws_route_table.trust-routetable.id}"
    ]
}

# Create a VPC NAT Gateway
# We need to create a public subnet for the NAT gateway to reside in
# We need to create an Internet Gateway for the NAT gateway to send internet traffic out
# The NAT gateway also requres an EIP
# We are adding a default route to the Nat route table to route traffic through Internet Gateway
# We are adding a default route to the Management route table to route internet traffic through NAT GW
/* Uncomment to enable
# Begin VPC NAT Gateway config
resource "aws_internet_gateway" "nat-igw" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "NAT Internet Gateway"
    }
}

resource "aws_subnet" "nat-subnet" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    cidr_block = "10.88.10.0/24"
    availability_zone = "${var.availability_zone}"
    tags {
        Name = "nat-subnet"
    }
}

resource "aws_route_table" "nat-routetable" {
    vpc_id = "${aws_vpc.pavm-vpc.id}"
    tags {
        Name = "nat-routetable"
    }
}

resource "aws_route" "nat-route" {
    route_table_id = "${aws_route_table.nat-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.nat-igw.id}"
    depends_on = [
        "aws_route_table.nat-routetable"
    ]
}

resource "aws_route_table_association" "nat-routetable-association" {
    subnet_id = "${aws_subnet.nat-subnet.id}"
    route_table_id = "${aws_route_table.nat-routetable.id}"
}

resource "aws_eip" "nat-eip" {
    vpc = true
}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat-eip.id}"
    subnet_id = "${aws_subnet.nat-subnet.id}"
    depends_on = [
        "aws_internet_gateway.nat-igw"
    ]
}

resource "aws_route" "gw-route" {
    route_table_id = "${aws_route_table.mgmt-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
}
# End VPC NAT Gateway config
*/

# Output data
output "vpc-VPC-ID" {
    value = "${aws_vpc.pavm-vpc.id}"
}

output "subnet-Management-Subnet-ID" {
    value = "${aws_subnet.mgmt-subnet.id}"
}

output "vpc-Default-Security-Group-ID" {
    value = "${aws_security_group.default-security-gp.id}"
}