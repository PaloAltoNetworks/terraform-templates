
module "lambda" {
  source = "./lambda_functions"
  aws_region = "${var.aws_region}"
  NATGateway = "${var.NATGateway}"
  AZSubnetIDLambda = "${var.AZSubnetIDLambda}"
  AZSubnetIDTrust = "${var.AZSubnetIDTrust}"
  AZSubnetIDUntrust = "${var.AZSubnetIDUntrust}"
  AZSubnetIDMgmt = "${var.AZSubnetIDMgmt}"
  KeyPANWPanorama = "${var.KeyPANWPanorama}"
  AZSubnetIDNATGW = "${var.AZSubnetIDNATGW}"
  SSHLocation = "${var.SSHLocation}"
  PanS3BucketTpl = "${var.PanS3BucketTpl}"
  StackName = "${var.StackName}"
  KeyDeLicense = "${var.KeyDeLicense}"
  LambdaENISNSTopic = "${module.sns.sns_topic_arn}"
  VPCSecurityGroup = "${module.vpc.vpc_security_group_id}"
  MgmtSecurityGroup = "${module.vpc.mgmt_security_group_id}"
  UntrustSecurityGroup = "${module.vpc.untrust_security_group_id}"
  TrustSecurityGroup = "${module.vpc.trust_security_group_id}"
  ASGNotifierRole = "${module.sns.asg_notifier_role_arn}"
  KeyName = "${var.KeyName}"
  ILBName = "${var.ILBName}"
  ELBName = "${var.ELBName}"
  ASGNotifierRolePolicy = "${module.sns.asg_notifier_role_policy_id}"
  ASGNotifierRole = "${module.sns.asg_notifier_role_arn}"
  PanFwAmiId = "${var.PanFwAmiId}"
  FWInstanceType = "${var.FWInstanceType}"
  ScaleDownThreshold = "${var.ScaleDownThreshold}"
  ScaleUpThreshold = "${var.ScaleUpThreshold}"
  BucketRegionMap = "${var.BucketRegionMap}"
  VPCID = "${var.VPCID}"
  MaximumInstancesASG = "${var.MaximumInstancesASG}"
  KeyPANWFirewall = "${var.KeyPANWFirewall}"
  MinInstancesASG = "${var.MinInstancesASG}"
  KeyMap = "${var.KeyMap}"
  MasterS3Bucket = "${var.MasterS3Bucket}"
  ScalingPeriod = "${var.ScalingPeriod}"
  VersionMap = "${var.VersionMap}"
  VPCCIDR = "${var.VPCCIDR}"
  ScalingParameter = "${var.ScalingParameter}"
  LambdaENIQueue = "${module.sqs.lambda_eni_queue_arn}"
  #AddENILambda = "${module.eni_natgw.add_eni_lambdan_arn}"
  AddENILambda = "${module.eni.add_eni_lambda_arn}"
}


module "eni_natgw" {
  source = "./eni_lambda_natgw"
  StackName = "${var.StackName}"
  NATGateway = "${var.NATGateway}"
  LambdaExecutionRole = "${module.lambda.lambda_execution_role_arn}"
  AZSubnetIDLambda = "${var.AZSubnetIDLambda}"
  VPCSecurityGroup = "${module.vpc.vpc_security_group_id}"
  PanS3BucketTpl = "${var.PanS3BucketTpl}"
  KeyMap = "${var.KeyMap}"
  MasterS3Bucket = "${var.MasterS3Bucket}"
  aws_region = "${var.aws_region}"
}

module "eni" {
  source = "./eni_lambda"
  NATGateway = "${var.NATGateway}"
  StackName = "${var.StackName}"
  LambdaExecutionRole = "${module.lambda.lambda_execution_role_arn}"
  PanS3BucketTpl = "${var.PanS3BucketTpl}"
  KeyMap = "${var.KeyMap}"
  MasterS3Bucket = "${var.MasterS3Bucket}"
  aws_region = "${var.aws_region}"
}

module "sns" {
  source = "./sns"
  NATGateway = "${var.NATGateway}"
  AddENILambdaARN = "${module.eni.add_eni_lambda_arn}"
  #AddENILambdaARN = "${module.eni_natgw.add_eni_lambdan_arn}"
  aws_region = "${var.aws_region}"
}

module "vpc" {
  source = "./vpc"
  VPCID = "${var.VPCID}"
  StackName = "${var.StackName}"
  VPCCIDR = "${var.VPCCIDR}"
  SSHLocation = "${var.SSHLocation}"
  aws_region = "${var.aws_region}"
}

module "sqs" {
  source = "./sqs"
  aws_region = "${var.aws_region}"
}
