resource "aws_sns_topic" "LambdaENISNSTopic" {
  name = "LambdaENISNSTopic"
}

resource "aws_sns_topic_subscription" "LambdaENISNSTopicSubscription" {
  topic_arn = "${aws_sns_topic.LambdaENISNSTopic.arn}"
  protocol = "lambda"
  endpoint = "${var.AddENILambdaARN}"
}

resource "aws_lambda_permission" "LambdaENIPermission" {
  statement_id = "ProvideLambdawithPermissionstoSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${var.AddENILambdaARN}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.LambdaENISNSTopic.arn}"
}

resource "aws_iam_role" "ASGNotifierRole" {
  name = "ASGNotifierRole"

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": ["autoscaling.amazonaws.com"]
    },
    "Action": ["sts:AssumeRole"]
    }]
}
EOF
}

resource "aws_iam_role_policy" "ASGNotifierRolePolicy" {
  name = "ASGNotifierRolePolicy"
  role = "${aws_iam_role.ASGNotifierRole.id}"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [{
  "Effect": "Allow",
  "Action": "sns:Publish",
  "Resource": "${aws_sns_topic.LambdaENISNSTopic.arn}"
  }]
}
EOF
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.LambdaENISNSTopic.arn}"
}

output "asg_notifier_role_arn" {
  value = "${aws_iam_role.ASGNotifierRole.arn}"
}

output "asg_notifier_role_policy_id" {
  value = "${aws_iam_role_policy.ASGNotifierRolePolicy.id}"
}
