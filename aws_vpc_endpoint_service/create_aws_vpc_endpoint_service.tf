resource "aws_vpc_endpoint_service" "custom_endpoint_service" {
  acceptance_required        = "${var.acceptance_required}"
  network_load_balancer_arns = "${var.nlb_arns}"
  allowed_principals         = "${var.allowed_principals}"
}

output "availability_zones" {
  value = "${aws_vpc_endpoint_service.custom_endpoint_service.availability_zones}"
}

output "private_dns_name" {
  value = "${aws_vpc_endpoint_service.custom_endpoint_service.private_dns_name}"
}

output "base_endpoint_dns_names" {
  value = "${aws_vpc_endpoint_service.custom_endpoint_service.base_endpoint_dns_names}"
}

output "service_name" {
  value = "${aws_vpc_endpoint_service.custom_endpoint_service.service_name}"
}

output "endpoint_service_state" {
  value = "${aws_vpc_endpoint_service.custom_endpoint_service.state}"
}
