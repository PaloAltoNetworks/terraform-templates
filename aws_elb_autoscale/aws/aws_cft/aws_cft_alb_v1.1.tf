
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

/*
  Create the Lambda subnet for the first AZ
*/
resource "aws_subnet" "LambdaSubnetAz1" {
  count = "${var.NATGateway}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("", list(var.StackName, "LambdaSubnetAz1"))}"
  }
}

/*
  Create the lambda subnet for the second AZ
*/
resource "aws_subnet" "LambdaSubnetAz2" {
  count = "${var.NATGateway}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz2"))}"
  }
}

/*
  Create the lambda subnet for the third AZ
*/
resource "aws_subnet" "LambdaSubnetAz3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz3"))}"
  }
}

resource "aws_subnet" "LambdaSubnetAz4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.LambdaSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  map_public_ip_on_launch = true
  tags {
        "Application" = "AWS::StackId"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "LambdaSubnetAz4"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz1" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz2"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz2" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz2"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "LambdaRouteTableAz3"))}"
  }
}

resource "aws_route_table" "LambdaRouteTableAz4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", var.StackName, "LambdaRouteTableAz4")}"
  }
}

resource "aws_subnet" "NATGWSubnetAz1" {
  count = "${var.NATGateway}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[0]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz1"))}"
  }
}

resource "aws_subnet" "NATGWSubnetAz2" {
  count = "${var.NATGateway}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[1]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz2"))}"
  }
}

resource "aws_subnet" "NATGWSubnetAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[2]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz3"))}"
  }
}


resource "aws_subnet" "NATGWSubnetAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  cidr_block = "${var.NATGWSubnetIpBlocks[3]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"

  tags {
        "Application" = "${var.StackName}"
        "Network"= "LambdaFunction"
        "Name" = "${join("-", list(var.StackName, "NATGWSubnetAz4"))}"
  }
}

resource "aws_eip" "EIP1" {
  count = "${var.NATGateway}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP2" {
  count = "${var.NATGateway}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_eip" "EIP4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc   = true
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT1" {
  count = "${var.NATGateway == 1 ? 1 : 0}"
  allocation_id = "${aws_eip.EIP1.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz1.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT2" {
  count = "${var.NATGateway == 1 ? 1 : 0}"
  allocation_id = "${aws_eip.EIP2.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz2.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  allocation_id = "${aws_eip.EIP3.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz3.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_nat_gateway" "NAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  allocation_id = "${aws_eip.EIP4.id}"
  subnet_id     = "${aws_subnet.NATGWSubnetAz4.id}"
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]
}

resource "aws_subnet" "MGMTSubnetAz1" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[0]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz1"))}"
    Network = "MGMT"
  }
}

resource "aws_subnet" "MGMTSubnetAz2" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[1]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz2"))}"
    Network = "MGMT"
  }
}

resource "aws_subnet" "MGMTSubnetAz3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[2]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz3"))}"
    Network = "MGMT"
  }
}


resource "aws_subnet" "MGMTSubnetAz4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.MgmtSubnetIpBlocks[3]}"
  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTSubnetAz4"))}"
    Network = "MGMT"
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    Network =  "MGMT"
    Name = "${join("-", list(var.StackName, "InternetGateway"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz1" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz1"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz2" {
  count = "${var.NATGateway}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz2"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz3"))}"
  }
}

resource "aws_route_table" "NATGWRouteTableAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "NATGWRouteTableAz4"))}"
  }
}

resource "aws_route" "NATGWRoute1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "NATGWRoute2" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "NATGWRoute3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  route_table_id               = "${aws_route_table.NATGWRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table" "MGMTRouteTableAz1" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz1"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz2" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz2"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz3" {
  count = "${var.NumberOfAzs * var.NATGateway == 3 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz3"))}"
  }
}

resource "aws_route_table" "MGMTRouteTableAz4" {
  count = "${var.NumberOfAzs * var.NATGateway == 4 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Application = "${var.StackName}"
    Name = "${join("-", list(var.StackName, "MGMTRouteTableAz4"))}"
  }
}

resource "aws_route" "MGMTRoute1" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
  depends_on = ["aws_route_table.MGMTRouteTableAz1"]
}

resource "aws_route" "MGMTRoute2" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
  depends_on = ["aws_route_table.MGMTRouteTableAz2"]
}

resource "aws_route" "MGMTRoute3" {
  count = "${(var.NATGateway * var.NumberOfAzs) + var.NumberOfAzs == 3 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "MGMTRoute4" {
  count = "${(var.NATGateway * var.NumberOfAzs) + var.NumberOfAzs == 4 ? 1 : 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route" "LambdaRoute1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT1.id}"
}

resource "aws_route" "LambdaRoute2" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT2.id}"
}

resource "aws_route" "LambdaRoute3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT3.id}"
}

resource "aws_route" "LambdaRoute4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  route_table_id               = "${aws_route_table.LambdaRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT4.id}"
}

resource "aws_route" "MGMTRouteNAT1" {
  count = "${var.NATGateway}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz1.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT1.id}"
}

resource "aws_route" "MGMTRouteNAT2" {
  count = "${var.NATGateway * var.NumberOfAzs == 2 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz2.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT2.id}"
}

resource "aws_route" "MGMTRouteNAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz3.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT3.id}"
}

resource "aws_route" "MGMTRouteNAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  route_table_id               = "${aws_route_table.MGMTRouteTableAz4.id}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NAT4.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation1" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz1.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz1.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation2" {
  count = "${var.NATGateway * var.NumberOfAzs == 2 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz2.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz2.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz3.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz3.id}"
}

resource "aws_route_table_association" "LambdaSubnetRouteTableAssociation4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.LambdaSubnetAz4.id}"
  route_table_id = "${aws_route_table.LambdaRouteTableAz4.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation1" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz1.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz1.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation2" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz2.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz2.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation3" {

  count = "${(var.NATGateway * 3) + var.NumberOfAzs == 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz3.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz3.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociation4" {
  count = "${(var.NATGateway * 4) + var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz4.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz4.id}"
}

resource "aws_route_table_association" "NAT1SubnetRouteTableAssociation" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz1.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz1.id}"
}

resource "aws_route_table_association" "NAT2SubnetRouteTableAssociation" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz2.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz2.id}"
}

resource "aws_route_table_association" "NAT3SubnetRouteTableAssociation" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz3.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz3.id}"
}

resource "aws_route_table_association" "NAT4SubnetRouteTableAssociation" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.NATGWSubnetAz4.id}"
  route_table_id = "${aws_route_table.NATGWRouteTableAz4.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT1" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz1.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz1.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT2" {
  count = "${var.NATGateway}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz2.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz2.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT3" {
  count = "${var.NATGateway * var.NumberOfAzs == 3 ? 1: 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz3.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz3.id}"
}

resource "aws_route_table_association" "MGMTSubnetRouteTableAssociationNAT4" {
  count = "${var.NATGateway * var.NumberOfAzs == 4 ? 1: 0}"
  subnet_id      = "${aws_subnet.MGMTSubnetAz4.id}"
  route_table_id = "${aws_route_table.MGMTRouteTableAz4.id}"
}

/*
  Create the Lambda subnet for the first AZ
*/
resource "aws_subnet" "UNTRUSTSubnet1" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet1"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet1"))}"
  }
}

/*
*/
resource "aws_subnet" "UNTRUSTSubnet2" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet2"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet2"))}"
  }
}

/*
*/
resource "aws_subnet" "UNTRUSTSubnet3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet3"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet3"))}"
  }
}

resource "aws_subnet" "UNTRUSTSubnet4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.UntrustSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet4"
        "Name" = "${join("-", list(var.StackName, "UNTRUSTSubnet4"))}"
  }
}

resource "aws_route_table" "UNTRUSTRouteTable" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    "Network"= "UntrustSubnet4"
    "Name" = "${join("-", list(var.StackName, "UntrustRouteTable"))}"
  }
}

resource "aws_route" "UNTRUSTRoute" {
  route_table_id               = "${aws_route_table.UNTRUSTRouteTable.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation1" {
  subnet_id      = "${aws_subnet.UNTRUSTSubnet1.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
  depends_on = ["aws_route.UNTRUSTRoute"]
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation2" {
  subnet_id      = "${aws_subnet.UNTRUSTSubnet2.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.UNTRUSTSubnet3.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

resource "aws_route_table_association" "UNTRUSTSubnetRouteTableAssociation4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.UNTRUSTSubnet4.id}"
  route_table_id = "${aws_route_table.UNTRUSTRouteTable.id}"
}

/*
  Create the Trust subnet for the first AZ
*/
resource "aws_subnet" "TRUSTSubnet1" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet1"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet1"))}"
  }
}

/*
*/
resource "aws_subnet" "TRUSTSubnet2" {

  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet2"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet2"))}"
  }
}

/*
*/
resource "aws_subnet" "TRUSTSubnet3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[2]}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "TrustSubnet3"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet3"))}"
  }
}

resource "aws_subnet" "TRUSTSubnet4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.TrustSubnetIpBlocks[3]}"
  availability_zone = "${data.aws_availability_zones.available.names[3]}"
  tags {
        "Application" = "${var.StackName}"
        "Network"= "UntrustSubnet4"
        "Name" = "${join("-", list(var.StackName, "TRUSTSubnet4"))}"
  }
}

resource "aws_route_table" "TrustRouteTable" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Application = "${var.StackName}"
    "Network"= "UntrustSubnet4"
    "Name" = "${join("-", list(var.StackName, "TrustRouteTable"))}"
  }
}

resource "aws_route" "TRUSTRoute" {
  route_table_id               = "${aws_route_table.TrustRouteTable.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation1" {
  subnet_id      = "${aws_subnet.TRUSTSubnet1.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation2" {
  subnet_id      = "${aws_subnet.TRUSTSubnet2.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  subnet_id      = "${aws_subnet.TRUSTSubnet3.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_route_table_association" "TRUSTSubnetRouteTableAssociation4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  subnet_id      = "${aws_subnet.TRUSTSubnet4.id}"
  route_table_id = "${aws_route_table.TrustRouteTable.id}"
}

resource "aws_security_group" "PublicLoadBalancerSecurityGroup" {
  name        = "PublicLoadBalancerSecurityGroup"
  description = "Public ELB Security Group with HTTP access on port 80 from the internet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a new load balancer
resource "aws_elb" "PublicLoadBalancer" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name            = "${var.ELBName}"
  internal        = false
  security_groups = ["${aws_security_group.PublicLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.UNTRUSTSubnet1.id}", "${aws_subnet.UNTRUSTSubnet2.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  connection_draining = true
  connection_draining_timeout = 300

  idle_timeout = 300
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  depends_on = ["aws_vpc.main",
                "aws_security_group.PublicLoadBalancerSecurityGroup"]
}

# Create a new load balancer
resource "aws_elb" "PublicLoadBalancer3" {
  count = "${var.NumberOfAzs == 3 ? 1: 0}"
  name            = "${var.ELBName}"
  internal        = false
  security_groups = ["${aws_security_group.PublicLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.UNTRUSTSubnet1.id}", "${aws_subnet.UNTRUSTSubnet2.id}",
                      "${aws_subnet.UNTRUSTSubnet3.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  connection_draining = true
  connection_draining_timeout = 300

  idle_timeout = 300
  cross_zone_loadbalancing = true

  enable_deletion_protection = true

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }
  depends_on = ["aws_vpc.main",
                "aws_security_group.PublicLoadBalancerSecurityGroup"]
}

resource "aws_vpc_endpoint" "S3Endpoint2" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("", list("com.amazonaws.", "${var.aws_region}", ".s3"))}"
  route_table_ids = ["${aws_route_table.UNTRUSTRouteTable.id}"]

  policy = <<POLICY
{
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": "${join("", list("arn:aws:s3:::", var.MasterS3Bucket))}"
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${join("", list("arn:aws:s3:::", var.MasterS3Bucket, "/*"))}"
        },
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "*",
          "Resource": [
              "arn:aws:s3:::*.amazonaws.com",
              "arn:aws:s3:::*.amazonaws.com/*"
          ]
        }
        ]
}
POLICY
}

resource "aws_vpc_endpoint" "S3Endpoint3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("", list("com.amazonaws.", "${var.aws_region}", ".s3"))}"
  route_table_ids = "${aws_route_table.UNTRUSTRouteTable.id}"
  policy = <<POLICY
  {
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" } ] ] }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" }, "/*" ] ] }
        }
        ],
      "RouteTableIds" : [ {"Ref" : "UNTRUSTRouteTable"}],
      "ServiceName" : { "Fn::Join": [ "", [ "com.amazonaws.", { "Ref": "AWS::Region" }, ".s3" ] ] },
      "VpcId" : {"Ref" : "VPC"}
   }
   POLICY
}

resource "aws_vpc_endpoint" "S3Endpoint4" {
  count = "${var.NumberOfAzs == 4 ? 1 : 0}"
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${join("com.amazonaws.", "${var.aws_region}", ".s3")}"
  route_table_ids = "${aws_route_table.UNTRUSTRouteTable.id}"
  policy = <<POLICY
  {
        "Version":"2012-10-17",
        "Statement":[
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:ListBucket",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" } ] ] }
        },
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": { "Fn::Join": [ "", [ "arn:aws:s3:::", { "Ref": "MasterS3Bucket" }, "/*" ] ] }
        }
        ]
      },
      "RouteTableIds" : [ {"Ref" : "UNTRUSTRouteTable"}],
      "ServiceName" : { "Fn::Join": [ "", [ "com.amazonaws.", { "Ref": "AWS::Region" }, ".s3" ] ] },
      "VpcId" : {"Ref" : "VPC"}
   }
   POLICY
}

resource "aws_security_group" "PrivateLoadBalancerSecurityGroup" {
  name        = "PrivateLoadBalancerSecurityGroup"
  description = "Private ALB Security Group with HTTP access on port 80 from the VM-Series firewall fleet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a new load balancer
resource "aws_alb" "PrivateElasticLoadBalancer" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name            = "${var.ILBName}"
  internal        = true
  security_groups = ["${aws_security_group.PrivateLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}"]

  depends_on = ["aws_vpc.main",
                "aws_security_group.PrivateLoadBalancerSecurityGroup"]
}

# Create a new load balancer
resource "aws_alb" "PrivateElasticLoadBalancer3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name            = "${var.ILBName}"
  internal        = true
  security_groups = ["${aws_security_group.PrivateLoadBalancerSecurityGroup.id}"]
  subnets         = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}",
                      "${aws_subnet.TRUSTSubnet3.id}"]

  depends_on = ["aws_vpc.main",
                "aws_security_group.PrivateLoadBalancerSecurityGroup"]
}

resource "aws_security_group" "WebServerSecurityGroup" {
  name        = "WebServerSecurityGroup"
  description = "Private ALB Security Group with HTTP access on port 80 from the VM-Series firewall fleet"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.SSHLocation}"]
  }

  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["${var.VPCCIDR}"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "WebServerGroup" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  depends_on = ["aws_vpc.main",
                "aws_internet_gateway.InternetGateway",
                "aws_subnet.TRUSTSubnet1", "aws_subnet.TRUSTSubnet2"]

  availability_zones        = ["${data.aws_availability_zones.available.names[0]}",
                                "${data.aws_availability_zones.available.names[1]}"
                              ]
  name                      = "WebServerGroup"
  max_size                  = "6"
  min_size                  = "2"
  launch_configuration      = "${aws_launch_configuration.WebServerLaunchConfig.name}"
  target_group_arns         = ["${aws_alb_target_group.WebServerTargetGroup.arn}"]
  vpc_zone_identifier       = ["${aws_subnet.TRUSTSubnet1.id}", "${aws_subnet.TRUSTSubnet2.id}"]

  tag {
    key = "ResourceType"
    value  = "auto-scaling-group"
    key = "ResourceId"
    value = "WebServerGroup"
    key                 = "Name"
    value               = "${join("-", list(var.StackName, "WebServerGroup"))}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "WebServerGroup3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"
  dependson = ["aws_vpc.main",
                "aws_internet_gateway.InternetGateway",
                "aws_subnet.TRUSTSubnet1", "aws_subnet.TRUSTSubnet2",
                "aws_subnet.TRUSTSubnet3"]

  availability_zones        = ["${data.aws_availability_zones.available.names[0]}",
                                "${data.aws_availability_zones.available.names[1]}",
                                "${data.aws_availability_zones.available.names[2]}"
                              ]
  name                      = "WebServerGroup3"
  max_size                  = "2"
  min_size                  = "6"
  launch_configuration      = "${aws_launch_configuration.WebServerLaunchConfig.name}"
  target_group_arns         = ["${aws_alb_target_group.WebServerTargetGroup.arn}"]
  vpc_zone_identifier       = ["${aws_subnet.TRUSTSubnet1.id}",
                                "${aws_subnet.TRUSTSubnet2.id}",
                                "${aws_subnet.TRUSTSubnet3.id}"
                              ]

  tag {
    key = "ResourceType"
    value = "auto-scaling-group"
    key = "ResourceId"
    value  = "WebServerGroup3"
    key                 = "Name"
    value               = "${join("-", list(var.StackName, "WebServerGroup3"))}"
    propagate_at_launch = true
  }
}

resource "aws_alb_target_group" "WebServerTargetGroup" {
  name = "${join("-", list(var.StackName, "WebServerTargetGroup"))}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"

  health_check {
    path = "/index.html"
    port = "80"
    protocol = "HTTP"
    timeout = "10"
    healthy_threshold = "5"
    unhealthy_threshold = "3"
    matcher = "200"
  }
}

/* */
resource "aws_alb_listener" "WebServerListener" {
  count = "${var.NumberOfAzs == 2 ? 1 : 0}"
  load_balancer_arn = "${aws_alb.PrivateElasticLoadBalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.WebServerTargetGroup.arn}"
    type = "forward"
  }
}
/* */
resource "aws_alb_listener" "WebServerListener3" {
  count = "${var.NumberOfAzs >= 3 ? 1 : 0}"

  default_action {
    target_group_arn = "${aws_alb_target_group.WebServerTargetGroup.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.PrivateElasticLoadBalancer3.arn}"
  port              = "80"
  protocol          = "HTTP"
}

resource "aws_launch_configuration" "WebServerLaunchConfig" {
  depends_on = ["aws_vpc.main", "aws_internet_gateway.InternetGateway"]

  name = "WebServerLaunchConfig"
  image_id = "${var.WebServerImageId}"
  instance_type = "${var.InstanceType}"
  security_groups = ["${aws_security_group.WebServerSecurityGroup.id}"]
  user_data = "${file("./webserver_config_amzn_ami.sh")}"
  key_name = "${var.KeyName}"
  associate_public_ip_address = true
}

resource "aws_autoscaling_policy" "WebServerScaleUpPolicy" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name                   = "WebServerScaleUpPolicy"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleDownPolicy" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  name                   = "WebServerScaleDownPolicy"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleUpPolicy3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name                   = "WebServerScaleUpPolicy3"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup3.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleDownPolicy3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  name                   = "WebServerScaleDownPolicy3"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "60"
  autoscaling_group_name = "${aws_autoscaling_group.WebServerGroup3.name}"
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmHigh" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  alarm_name                = "CPUAlarmHigh"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "Scale-up if CPU > 90% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleUpPolicy.arn}"]

}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmLow" {
  count = "${var.NumberOfAzs == 2 ? 1: 0}"
  alarm_name                = "CPUAlarmLow"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "Scale-down if CPU < 70% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleDownPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmHigh3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  alarm_name                = "CPUAlarmHigh3"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "Scale-up if CPU > 90% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup3.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleUpPolicy3.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmLow3" {
  count = "${var.NumberOfAzs >= 3 ? 1: 0}"
  alarm_name                = "CPUAlarmLow3"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "Scale-down if CPU < 70% for 10 minutes"
  insufficient_data_actions = []
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.WebServerGroup3.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.WebServerScaleDownPolicy3.arn}"]
}

output "LambdaSubnetAz1" {
  value = "${aws_subnet.LambdaSubnetAz1.id}"
}

output "LambdaSubnetAz2" {
  value = "${aws_subnet.LambdaSubnetAz2.id}"
}

output "LambdaSubnetAz3" {
  value = "${aws_subnet.LambdaSubnetAz3.id}"
}

output "LambdaSubnetAz4" {
  value = "${aws_subnet.LambdaSubnetAz4.id}"
}

output "NATGWSubnetAz1" {
  value = "${aws_subnet.NATGWSubnetAz1.id}"
}

output "NATGWSubnetAz2" {
  value = "${aws_subnet.NATGWSubnetAz2.id}"
}

output "NATGWSubnetAz3" {
  value = "${aws_subnet.NATGWSubnetAz3.id}"
}

output "MGMTSubnetAz1" {
  value = "${aws_subnet.MGMTSubnetAz1.id}"
}

output "MGMTSubnetAz2" {
  value = "${aws_subnet.MGMTSubnetAz2.id}"
}

output "MGMTSubnetAz3" {
  value = "${aws_subnet.MGMTSubnetAz3.id}"
}

output "UNTRUSTSubnet1" {
  value = "${aws_subnet.UNTRUSTSubnet1.id}"
}

output "UNTRUSTSubnet2" {
  value = "${aws_subnet.UNTRUSTSubnet2.id}"
}

output "UNTRUSTSubnet3" {
  value = "${aws_subnet.UNTRUSTSubnet3.id}"
}

output "TRUSTSubnet1" {
  value = "${aws_subnet.TRUSTSubnet1.id}"
}

output "TRUSTSubnet2" {
  value = "${aws_subnet.TRUSTSubnet2.id}"
}

output "TRUSTSubnet3" {
  value = "${aws_subnet.TRUSTSubnet3.id}"
}

output "VPCCIDR" {
  value = "${var.VPCCIDR}"
}

output "StackName" {
  value = "${var.StackName}"
}

output "PanFwAmiId" {
  value = "${var.PanFwAmiId}"
}

output "VPCID" {
  value = "${aws_vpc.main.id}"
}

output "KeyName" {
  value = "${var.KeyName}"
}

output "KeyPANWPanorama" {
  value = "${var.KeyPANWPanorama}"
}

output "KeDeLicense" {
  value = "${var.KeyDeLicense}"
}

output "MasterS3Bucket" {
  value = "${var.MasterS3Bucket}"
}

output "NATGateway" {
  value = "${var.NATGateway}"
}

output "SSHLocation" {
  value = "${var.SSHLocation}"
}
