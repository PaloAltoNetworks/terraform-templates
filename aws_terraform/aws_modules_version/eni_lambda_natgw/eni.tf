resource "aws_lambda_function" "AddENILambdaN" {
  count = "${var.NATGateway == 1 ? 1 : 0}"
  s3_bucket = "${var.PanS3BucketTpl}"
  s3_key = "${var.KeyMap["Key"]}"
  function_name    = "${join("-", list(var.StackName, "AddENILambdaN"))}"
  role             = "${var.LambdaExecutionRole}"
  handler          = "add_eni.lambda_handler"
  runtime          = "python2.7"
  timeout          = "300"

  vpc_config {
    subnet_ids = "${split(",", var.AZSubnetIDLambda)}"
    security_group_ids = ["${var.VPCSecurityGroup}"]
  }
}

output "add_eni_lambdan_arn" {
  value = "${aws_lambda_function.AddENILambdaN.arn}"
}
