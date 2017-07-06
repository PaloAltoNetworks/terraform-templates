resource "aws_sqs_queue" "LambdaENIQueue" {
  name                      = "LambdaENIQueue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  #depends_on = ["aws_lambda_function.AddENILambda"]
}

output "lambda_eni_queue_arn" {
  value = "${aws_sqs_queue.LambdaENIQueue.id}"
}
