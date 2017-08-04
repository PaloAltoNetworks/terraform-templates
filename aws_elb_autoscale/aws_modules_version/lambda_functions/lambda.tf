resource "aws_iam_role_policy" "FirewallBootstrapRolePolicy" {
  name = "FirewallBootstrapRolePolicy"
  role = "${aws_iam_role.FirewallBootstrapRole.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.MasterS3Bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.MasterS3Bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "FirewallBootstrapRole" {
  name = "FirewallBootstrapRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "FirewallBootstrapInstanceProfile" {
  name  = "FirewallBootstrapInstanceProfile"
  role = "${aws_iam_role.FirewallBootstrapRole.name}"
  path = "/"
}

resource "aws_iam_role" "LambdaExecutionRole" {
  name = "LambdaExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
      },
    "Action": "sts:AssumeRole"
  }
  ]
}
EOF
}

resource "aws_iam_role_policy" "LambdaExecutionRolePolicy" {
  name = "LambdaExecutionRolePolicy"
  role = "${aws_iam_role.LambdaExecutionRole.id}"

  policy = <<EOF
{
            "Version": "2012-10-17",
            "Statement": [{
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": ["arn:aws:s3:::vv-payg-bootstrap/*"]
            },
            {
                "Effect": "Allow",
                "Action": "s3:GetObject",
                "Resource": ["arn:aws:s3:::vv-payg-bootstrap/*"]
            },
            {
                    "Effect": "Allow",
                    "Action": "s3:ListBucket",
                    "Resource": ["arn:aws:s3:::${var.BucketRegionMap[var.aws_region]}"]
            },
            {
                    "Effect": "Allow",
                    "Action": "s3:GetObject",
                    "Resource": ["arn:aws:s3:::${var.BucketRegionMap[var.aws_region]}/*"]
            },
            {
                    "Effect": "Allow",
                    "Action": "s3:ListBucket",
                    "Resource": ["arn:aws:s3:::${var.PanS3BucketTpl}"]
            },
            {
                    "Effect": "Allow",
                    "Action": "s3:GetObject",
                    "Resource": ["arn:aws:s3:::${var.PanS3BucketTpl}/*"]
            },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:AllocateAddress",
            "ec2:AssociateAddress",
            "ec2:AssociateRouteTable",
            "ec2:AttachInternetGateway",
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:CreateTags",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteRouteTable",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteTags",
            "ec2:DescribeAddresses",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeInstanceAttribute",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances",
            "ec2:DescribeImages",
            "ec2:DescribeNatGateways",
            "ec2:DescribeNetworkInterfaceAttribute",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeTags",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeVpcs",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DetachInternetGateway",
            "ec2:DetachNetworkInterface",
            "ec2:DetachVolume",
            "ec2:DisassociateAddress",
            "ec2:DisassociateRouteTable",
            "ec2:ModifyNetworkInterfaceAttribute",
            "ec2:ModifySubnetAttribute",
            "ec2:MonitorInstances",
            "ec2:RebootInstances",
            "ec2:ReleaseAddress",
            "ec2:ReportInstanceStatus",
            "ec2:TerminateInstances",
            "ec2:DescribeIdFormat"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "events:*"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "cloudwatch:*"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "lambda:AddPermission",
            "lambda:CreateEventSourceMapping",
            "lambda:CreateFunction",
            "lambda:DeleteEventSourceMapping",
            "lambda:DeleteFunction",
            "lambda:GetEventSourceMapping",
            "lambda:ListEventSourceMappings",
            "lambda:RemovePermission",
            "lambda:UpdateEventSourceMapping",
            "lambda:UpdateFunctionCode",
            "lambda:UpdateFunctionConfiguration",
            "lambda:GetFunction",
            "lambda:ListFunctions"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "autoscaling:*"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "sqs:ReceiveMessage",
            "sqs:SendMessage",
            "sqs:SetQueueAttributes",
            "sqs:PurgeQueue"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:AttachLoadBalancerToSubnets",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:DescribeInstanceHealth",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
            "elasticloadbalancing:DescribeLoadBalancerPolicies",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTags",
            "elasticloadbalancing:DetachLoadBalancerFromSubnets",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:RemoveTags"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:PassRole",
            "iam:GetRole"
        ],
        "Resource": [
            "*"
        ]
    },
    {
      "Effect": "Allow",
      "Action": ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": ["cloudformation:DescribeStacks"],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutDestination",
            "logs:PutDestinationPolicy",
            "logs:PutLogEvents",
            "logs:PutMetricFilter"
        ],
        "Resource": [
            "*"
        ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "InitLambda" {
  function_name = "${join("-", list(var.StackName, "InitLambda"))}"
  handler = "init.lambda_handler"
  role = "${aws_iam_role.LambdaExecutionRole.arn}"
  s3_bucket = "${var.PanS3BucketTpl}"
  s3_key = "${var.KeyMap["Key"]}"
  runtime = "python2.7"
  timeout = "300"
}

resource "aws_cloudformation_stack" "LambdaCustomResource" {
  name = "LambdaCustomResource6"
  parameters {
    InitLambda = "${aws_lambda_function.InitLambda.arn}"
    StackName = "${var.StackName}"
    Region = "${var.aws_region}"
    VPCID = "${var.VPCID}"
    AZSubnetIDLambda = "${var.AZSubnetIDLambda}"
    AZSubnetIDNATGW = "${var.AZSubnetIDNATGW}"
    AZSubnetIDMgmt = "${var.AZSubnetIDMgmt}"
    AZSubnetIDUntrust = "${var.AZSubnetIDUntrust}"
    AZSubnetIDTrust = "${var.AZSubnetIDTrust}"
    KeyName = "${var.KeyName}"
    FWInstanceType = "${var.FWInstanceType}"
    PanFwAmiId = "${var.PanFwAmiId}"
    KeyDeLicense = "${var.KeyDeLicense}"
    MinInstancesASG = "${var.MinInstancesASG}"
    MaximumInstancesASG = "${var.MaximumInstancesASG}"
    ScaleUpThreshold = "${var.ScaleUpThreshold}"
    ScaleDownThreshold = "${var.ScaleDownThreshold}"
    ScalingParameter = "${var.ScalingParameter}"
    ScalingPeriod = "${var.ScalingPeriod}"
    PanS3BucketTpl = "${var.PanS3BucketTpl}"
    MgmtSecurityGroup = "${var.MgmtSecurityGroup}"
    UntrustSecurityGroup = "${var.UntrustSecurityGroup}"
    TrustSecurityGroup = "${var.TrustSecurityGroup}"
    VPCSecurityGroup = "${var.VPCSecurityGroup}"
    ELBName = "${var.ELBName}"
    ILBName = "${var.ILBName}"
    SSHLocation = "${var.SSHLocation}"
    LambdaENISNSTopic = "${var.LambdaENISNSTopic}"
    FirewallBootstrapInstanceProfile = "${aws_iam_instance_profile.FirewallBootstrapInstanceProfile.arn}"
    LambdaExecutionRole = "${aws_iam_role.LambdaExecutionRole.name}"
    ASGNotifierRole = "${var.ASGNotifierRole}"
    ASGNotifierRolePolicy = "${var.ASGNotifierRolePolicy}"
    MasterS3Bucket = "${var.MasterS3Bucket}"
    KeyPANWFirewall = "${var.KeyPANWFirewall}"
    KeyPANWPanorama = "${var.KeyPANWPanorama}"
    NATGateway = "${var.NATGateway == 1 ? "Yes" : "No"}"
    AddENILambda = "${var.AddENILambda}"
    LambdaENIQueue = "${var.LambdaENIQueue}"
    Version = "${var.VersionMap["Key"]}"
    PanS3KeyTpl = "${var.KeyMap["Key"]}"
  }
  template_body = <<STACK
{
  "Parameters" : {
    "InitLambda": {
      "Type": "String",
      "Description": "ARN of the Init Lambda function"
    },
    "StackName": {
      "Type": "String",
      "Description": "Name of the Stack"
    },
    "Region": {
      "Type": "String",
      "Description": "The Region that the infrastructure is being deployed into"
    },
    "VPCID": {
      "Type": "String",
      "Description": "VPC ID"
    },
    "AZSubnetIDLambda": {
        "Description": "Subnet IDs of Lambda Function interface",
        "Type" : "CommaDelimitedList"
    },
    "AZSubnetIDNATGW": {
        "Description": "Subnet IDs of AWS NAT Gateway ",
        "Type" : "CommaDelimitedList"
    },
    "AZSubnetIDMgmt" : {
      "Type" : "List<AWS::EC2::Subnet::Id>",
      "Description": "Enter Subnet ID for the mgmt interface for all the AZs"
    },
    "AZSubnetIDUntrust" : {
      "Type" : "List<AWS::EC2::Subnet::Id>",
      "Description": "Enter Subnet ID for the untrust interface for all the AZs"
    },
    "AZSubnetIDTrust" : {
      "Type" : "List<AWS::EC2::Subnet::Id>",
      "Description": "Enter Subnet ID for the trust interface for all the AZs"
    },
    "KeyName": {
      "Type": "String",
      "Description": "Name of an existing Key in AWS"
    },
    "MgmtSecurityGroup": {
      "Type": "String",
      "Description": "Mgmt Security Group"
    },
    "UntrustSecurityGroup": {
      "Type": "String",
      "Description": "Untrust Security Group"
    },
    "TrustSecurityGroup": {
      "Type": "String",
      "Description": "Trust Security Group"
    },
    "VPCSecurityGroup": {
      "Type": "String",
      "Description": "VPC Security Group"
    },
    "ELBName": {
      "Type": "String",
      "Description": "Name of the ELB"
    },
    "ILBName": {
      "Type": "String",
      "Description": "Name of the ILB"
    },
    "FWInstanceType": {
      "Type": "String",
      "Description": "The instance type to be used to instantiate the FW"
    },
    "SSHLocation": {
      "Type": "String",
      "Description": "The CIDR from where ssh sessions will originate"
    },
    "MaximumInstancesASG": {
      "Type": "String",
      "Description": "Max # of instances in the ASG"
    },
    "ScaleUpThreshold": {
      "Type": "String",
      "Description": "The threshold which triggers a scale up event"
    },
    "ScaleDownThreshold": {
      "Type": "String",
      "Description": "The threshold which triggers a scale down event"
    },
    "ScalingParameter": {
      "Type": "String",
      "Description": "Parameter which determines the scaling"
    },
    "ScalingPeriod": {
      "Type": "String",
      "Description": "The duration of the scaling"
    },
    "PanFwAmiId": {
      "Type": "String",
      "Description": "AMI id of the PANW FW for the chosen region"
    },
    "MinInstancesASG": {
      "Type": "String",
      "Description": "Minimum # of desired FW instances"
    },
    "FirewallBootstrapInstanceProfile": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "LambdaExecutionRole": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "ASGNotifierRole": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "ASGNotifierRolePolicy": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "MasterS3Bucket": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "PanS3BucketTpl": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "KeyPANWFirewall": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "KeyPANWPanorama": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "NATGateway": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "AddENILambda": {
      "Type": "String",
      "Description": "ARN of the lambda function to add ENIs"
    },
    "KeyDeLicense": {
      "Type": "String",
      "Description": "The key to be used to delicense the Firewall"
    },
    "LambdaENIQueue": {
      "Type": "String",
      "Description": "Just a simple message"
    },
    "LambdaENISNSTopic": {
      "Type": "String",
      "Description": "SNS topic that receives ASG notifications"
    },
    "Version": {
      "Type": "String",
      "Description": "Version Associated with PANW Lambda"
    },
    "PanS3KeyTpl": {
      "Type": "String",
      "Description": "Version Associated with PANW Lambda"
    }
  },
  "Resources" : {
    "LambdaCustomResource": {
      "Type": "AWS::CloudFormation::CustomResource",
      "Version" : "1.0",
       "Properties" : {
           "ServiceToken": { "Ref": "InitLambda" },
           "StackName": {"Ref": "StackName"},
           "Region": {"Ref": "Region"},
           "VPCID": {"Ref": "VPCID"},
           "SubnetIDMgmt": {"Ref": "AZSubnetIDMgmt"},
           "SubnetIDUntrust": {"Ref": "AZSubnetIDUntrust"},
           "SubnetIDTrust": {"Ref": "AZSubnetIDTrust"},
           "MgmtSecurityGroup": {"Ref": "MgmtSecurityGroup"},
           "UntrustSecurityGroup": {"Ref": "UntrustSecurityGroup"},
           "TrustSecurityGroup": {"Ref": "TrustSecurityGroup"},
           "VPCSecurityGroup": {"Ref": "VPCSecurityGroup"},
           "KeyName" : {"Ref": "KeyName"},
           "ELBName" : {"Ref": "ELBName"},
           "ILBName" : {"Ref": "ILBName"},
           "FWInstanceType" : {"Ref": "FWInstanceType"},
           "SSHLocation" : {"Ref": "SSHLocation"},
           "MaximumInstancesASG" : {"Ref": "MaximumInstancesASG"},
           "ScaleUpThreshold" : {"Ref": "ScaleUpThreshold"},
           "ScaleDownThreshold" : {"Ref": "ScaleDownThreshold"},
           "ScalingParameter" : {"Ref": "ScalingParameter"},
           "ScalingPeriod" : {"Ref": "ScalingPeriod"},
           "ImageID" : { "Ref": "PanFwAmiId" },
           "LambdaENISNSTopic": {"Ref": "LambdaENISNSTopic"},
           "MinInstancesASG": {"Ref": "MinInstancesASG"},
           "FirewallBootstrapRole": {"Ref": "FirewallBootstrapInstanceProfile"},
           "LambdaExecutionRole": {"Ref": "LambdaExecutionRole"},
           "ASGNotifierRole": { "Ref" : "ASGNotifierRole"},
           "ASGNotifierRolePolicy": {"Ref": "ASGNotifierRolePolicy"},
           "MasterS3Bucket" : { "Ref" : "MasterS3Bucket" },
           "PanS3BucketTpl" : { "Ref" : "PanS3BucketTpl" },
           "PanS3KeyTpl" : { "Ref": "PanS3KeyTpl" },
           "KeyPANWFirewall" : { "Ref" : "KeyPANWFirewall" },
           "KeyPANWPanorama" : { "Ref" : "KeyPANWPanorama" },
           "NATGateway" : { "Ref" : "NATGateway" },
           "SubnetIDNATGW": {"Ref": "AZSubnetIDNATGW"},
           "SubnetIDLambda": {"Ref": "AZSubnetIDLambda"},
           "AddENILambda": {"Ref": "AddENILambda"},
           "InitLambda": {"Ref": "InitLambda"},
           "Version" : { "Ref": "Version" },
           "KeyDeLicense": { "Ref": "KeyDeLicense" },
           "LambdaENIQueue" : { "Ref": "LambdaENIQueue" }
       }
    }
  }
}
STACK
}


output "lambda_execution_role_arn" {
  value = "${aws_iam_role.LambdaExecutionRole.arn}"
}
