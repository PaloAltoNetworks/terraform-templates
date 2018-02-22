/* Create permission to allow
 * Cloud Watch Events to invoke
 * the Lambda function.
*/
resource "aws_lambda_permission" "cloud_watch_invoke_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.GuardDutyLambdaFunction.id}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.guard_duty_event_rule.arn}"
}

/* Create the Lambda Guard Duty Function */
resource "aws_lambda_function" "GuardDutyLambdaFunction" {
  function_name = "${var.guard_duty_function_name}"
  handler = "lambda_fw_config.lambda_handler"
  role = "${aws_iam_role.GuardDutyRole.arn}"
  runtime = "python2.7"
  timeout = "120"
  s3_bucket = "${var.GuardDutyBucketName}"
  s3_key = "${join("/", list(var.GuardDutyObjectName, var.ZipFileName))}"
  environment {
    variables = {
      "FWIP" = "${var.FirewallMgmtIp}",
      "USERNAME" = "${var.FirewallUsername}",
      "PASSWORD" = "${var.FirewallPassword}",
      "TRUST_ZONE" = "${var.untrust_zone_name}",
      "UNTRUST_ZONE" = "${var.trust_zone_name}",
      "SECURITY_RULE_NAME" = "${var.security_rule_name}",
      "RULE_ACTION" = "${var.rule_action}",
      "GD_DAG_NAME" = "${var.guard_duty_dag_name}",
      "FW_DAG_TAG" = "${var.tag_for_gd_ips}"
    }
  }
}

/* Create and configure the Cloud Watch Event Rule */
resource "aws_cloudwatch_event_rule" "guard_duty_event_rule" {
  name = "guard_duty_events"
  description = "Rule to invoke lambda when GD Findings arrive"
  event_pattern = <<PATTERN
{
    "source": [
          "aws.guardduty"
    ]
}
PATTERN
  is_enabled = true
}

/* Configure the target for the cloud watch event rule */
resource "aws_cloudwatch_event_target" "cloud_watch_event_target" {
  target_id = "gd_lambda_function"
  rule = "${aws_cloudwatch_event_rule.guard_duty_event_rule.name}"
  arn = "${aws_lambda_function.GuardDutyLambdaFunction.arn}"
}

/* Create a role with AssumeRole privileges */
resource "aws_iam_role" "GuardDutyRole" {
  name = "GuardDutyRole"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": ["lambda.amazonaws.com"]
    },
    "Action": ["sts:AssumeRole"]
    }]
}
EOF
}

/* Create a role policy with the necessary
 * permissions to be associated with the
 * GuardDuty role.
*/

resource "aws_iam_role_policy" "guard_duty_role_policy" {
  name = "GuardDutyRolePolicy"
  role = "${aws_iam_role.GuardDutyRole.id}"
  policy = <<EOF
{
  "Statement": [{
      "Action": [
          "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.GuardDutyBucketName}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.GuardDutyBucketName}/*"
    }
    ],
    "Version": "2012-10-17"
}
EOF
}

output "S3ObjectKeyName" {
  value = "${join("/", list(var.GuardDutyObjectName, var.ZipFileName))}"
}
