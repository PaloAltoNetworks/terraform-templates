# terraform-templates
README: AWS ELB Sandwich with PANFW Deployed using terraform_version

Terraform is a DSL, which allows users to define infrastructure as code, along with the capability to deploy that infrastructure
onto the cloud platform of choice.

1. Terraform Code Overview:

Directory Layout
-----------------

This particular repository has been implemented in order to duplicate the PAN ELB Autoscaling template. Consequently,
there are terraform files which deploys the networking and the various other entities of the alb template. There is also another directory
which provides the definition and deployment of the inner firewall template.

The outer template files are stored in the ```aws/aws_cft``` directory.
The inner template files are stored int he ```aws_modules_version``` directory.

Terraform Specifics
-------------------

The code follows the following Terraform conventions:

a. Variable parameters are specified in the ```terraform.tfvars``` file.
b. Variable are defined in the ```*_vars.tf``` file.
c. The infrastructure definition is specified in the other ```*.tf``` files.

# PreRequisites for Using the Terraform Template

## Configure and setup the S3 Buckets with the Bootstrap and Lambda Code
   This is described in Section 1 below.


### Identify the right AMI ID's for the PAN FW (depending on the license type desired)

    This can be found at:
    https://www.paloaltonetworks.com/documentation/global/compatibility-matrix/vm-series-firewalls/aws-cft-amazon-machine-images-ami-list

### Identify the right AMI ID's for the Web Server
    The selection depends on a combination of the supported Architectures as well as the desired instance type.
    This table can be found in the file: ```webserver_ami_ids.md``` in this repo.

### 1. Setting up the S3 Bucket

    - Create the ```bootstrap``` S3 bucket in the region the infrastructure will be deployed to.
        - In the bucket, create the following folders:
            - ```config```
            - ```license```
            - ```software```
            - ```content```
      - Upload files the various buckets from the following link:

        - Upload the ``` bootstrap.xml ``` and ``` init-cfg.txt ``` files to the ``` config ``` folder.
          - The bootstrap file link is: https://github.com/PaloAltoNetworks/aws-elb-autoscaling/blob/master/Version-1.2/bootstrap.xml
          - The init.cfg file link is: https://github.com/PaloAltoNetworks/aws-elb-autoscaling/tree/master/Version-1.2

    - Create the ```lambda``` code S3 bucket in the same region selected for the infrastructure deployment.
        - Upload the lambda code zip file to this bucket.
        - The link to the lambda code is: https://github.com/PaloAltoNetworks/aws-elb-autoscaling/blob/master/Version-1.2/panw-aws.zip

### 2. Setting up the AWS Security Credentials:
    --------------------------------------

 - Before applying the terraform templates, setup the AWS credentials.
 - This can be done by the usual methods as prescribed by AWS namely:
    - export the credentials as environment variables
    - Static credentials in a <filename>.tf file
    - Other options are specified at: https://www.terraform.io/docs/providers/aws/index.html

### 3. Salient Arguments that need to be set that are user specific:
    ---------------------------------------------------------

  - The S3 buckets which contain the PAN bootstrap code as well as the Lambda code need to be specified.
    - Variable: MasterS3Bucket File: ```aws/aws_cft/terraform.tfvars```

  - You will also be required to specify the S3 Bucket which contains the lambda code.
     - You will be prompted for this value when you run the terraform apply command for the inner template.



Usage Instructions for the Outer Template:
------------------------------------------
1. cd into the aws/aws_cft directory
2. Introspect the ```aws_cft_vars.tf``` file to identify the various variables.
3. Provide the input parameters for these variables either when prompted or in the ```terraform.tfvars``` file.
4. (Assumption: terraform binary executable is in the PATH. If not please add it to the PATH). Run: terraform apply
5. Invoking step 5 above should begin the installation of the artifacts associated with the outer template.
6. Once the deployment has completed, execute: terraform output > ../../aws_modules_version/output.tfvars

Usage Instructions for the Inner Template:
------------------------------------------

Note regarding the Inner Template:

 1. There are two options to choose while deploying the inner template. The option is to either deploy with a NATGateway or without
    a NATGateway.
 2. If a NATGateway is specified in the outer template then do the following:
    a. edit the main.tf file and uncomment out the AddENILambda to look as follows:
       AddENILambdaARN = "${module.eni.add_eni_lambda_arn}"
 3. If a NATGateway is not required then the AddENILambdaARN line should like as follows:
    a. edit the main.tf file and uncomment out the AddENILambda to look as follows:
      AddENILambdaARN = "${module.eni.add_eni_lambdan_arn}"

1. cd into the aws_modules_version directory.
2. This directory should not contain the ```output.tfvars``` file, containing the output variables from the outer template.
3. Run: ./prep_tf.py
4. Step 3 above will created the ```terraform.tfvars``` file in the current directory. This essentially defines the values for
   various input variables that will be required for the inner template.
5. Run: terraform apply
6. This should start the deployment of the inner template.

Destroy / Cleanup
-----------------

The general process to cleanup the deployed infrastructure is as follows:
  - run: terraform destroy
  - this should be run from the respective directories in the same order (i.e inner template first, followed by outer template)

Destroying the Infrastructure or the Cleanup
--------------------------------------------

The following issues should be noted during the cleanup:
1. There are some dependencies that do not get deleted which cause the deletion of other objects to fail.
2. These typically are:
   - ENI's for the MgmtSecurityGroup
   - please manually detach and delete these ENI's
3. Rerun: terraform destroy.
4. [Important] Also make sure to cleanup the Auto Scale Group entities as well as the previously created Launch Configurations
   prior to running the infrastructure again (typically if using the same name.)

Support Policy

This CFT is released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our
expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support
options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used
(the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or
using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or
sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.