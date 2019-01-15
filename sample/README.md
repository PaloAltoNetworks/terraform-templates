## Info ##
Enclosed in this folder are the files that contains the terraform templates.  There are three terraform files.  Two of them are the templates for the VPC and the firewall.  The last file is just a list of variables for users to set for the template.  I purposely separated the VPC and the firewall to give myself an option to just deploy and create a VPC and add the firewall if needed.

## Zip Content: ##
deploy_pavm.tf - Terraform template for Palo Alto Networks VM-Series firewall.
deploy_vpc.tf - Terraform template for create a VPC on AWS.  The VPC will create the management, trust, and untrust subnets for the VM-Series firewall.  An internet gateway needed for the internet connection and AWS endpoint (currently disabled.  need to uncomment the code to enable the feature) to allow the firewall to access the S3 bucket via private IP address.
variables.tf - Variables you can set for the deployment


Before deploying the template, you need to create a terraform.tfvars file to set the AWS access key and secret key. 
 The template is also setup to deploy in US East Region.
 
Example terraform.tfvars content:

```bash
access_key="YOURKEYHERE"
secret_key="YOURSECRETHERE"
pavm_key_name="KEYPAIR"
pavm_key_path="~/keys/KEYPAIR.pem"
region="us-east-2"
availability_zone="us-east-2b"
pavm_bootstrap_s3="BOOTSTRAP_BUCKET_NAME"
```

Refer to https://panos-bootstrapper.readthedocs.io/en/latest/ for information on building a valid S3 Bootstrap bucket. 

To deploy using Terraform, download and install Terraform from terraform.io.

Commands to deploy

Run terraform init to initialize the terraform state and download the aws plugin.

`$ terraform init`

Run terraform plan to validate the template and see the preview of the objects that will be created on AWS.

`$ terraform plan`

Run terraform apply to deploy the template

`$ terraform apply`

To clean up the deployment, just run the following command

`$ terraform destroy`

it will automatically delete every object that was created by the template.

If you don’t want to deploy the VM-Series firewall, just rename the deploy_pavm.tf file extension to something else.

# Troubleshooting

The first time you deploy this project, you may get an error that you need to 'Opt In' to the Palo Alto Networks VM-Series
licensing agreement. Just follow the link provided to accept the agreement, wait 3-4 minutes, then try again. 
