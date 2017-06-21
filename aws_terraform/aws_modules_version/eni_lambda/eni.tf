resource "aws_lambda_function" "AddENILambda" {
  count = "${var.NATGateway == 0 ? 1 : 0}"
  s3_bucket = "vv-payg-lambda"
  s3_key = "panw-aws.zip"
  function_name    = "${join("-", list(var.StackName, "AddENILambda"))}"
  role             = "${var.LambdaExecutionRole}"
  handler          = "add_eni.lambda_handler"
  runtime          = "python2.7"
  timeout          = "300"
}

output "add_eni_lambda_arn" {
  value = "${aws_lambda_function.AddENILambda.arn}"
}
