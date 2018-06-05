resource "aws_security_group" "access_to_vpc_endpoint" {
  name        = "sec_group_for_vpc_endpoint"
  description = "Allow http/https traffic across vpc endpoint"
  vpc_id      = "${var.subscribing_vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "custom_vpc_endpoint" {
  vpc_id             = "${var.subscribing_vpc_id}"
  service_name       = "${var.service_name}"
  security_group_ids = ["${aws_security_group.access_to_vpc_endpoint.id}"]
  vpc_endpoint_type  = "${var.vpc_endpoint_type}"
  subnet_ids         = "${var.subnet_ids}"
}

output "endpoint_state" {
  value = "${aws_vpc_endpoint.custom_vpc_endpoint.state}"
}

output "network_interface_ids" {
  value = "${aws_vpc_endpoint.custom_vpc_endpoint.network_interface_ids}"
}

output "dns_entry" {
  value = "${aws_vpc_endpoint.custom_vpc_endpoint.dns_entry}"
}
