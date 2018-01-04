# Terraform Templates to Deploy Infrastructure onto AWS and Configure the NGFW using Ansible

## Summary:

This directory contains Terraform templates that automates the deployment of a two tier 
application deployment on AWS using Terraform and additionally configures the Palo Alto 
Networks VM-Series Firewall using Ansible. 

It should be noted that this deployment is tightly coupled with ansible playbooks that are available 
at: https://github.com/PaloAltoNetworks/ansible-pan. 

## Docker Integration

A lot of the steps shown below have already been automated into a docker container
for ease of use, distribution and portability. If you so desire please pull down the docker container
which will do the following for you automatically:
 - cloning of the terraform-templates repo
 - cloning of the ansible-pan repo
 - pre-configured environment which contains ansible 

 - Docker command:
   docker pull vinayvenkat/terraform_ansbile_v1
 
 - Detailed instructions to use and execute the docker container
   can be accessed at: 
   ``` https://github.com/PaloAltoNetworks/terraform-templates/blob/master/Terraform_Container_Readme.md ```
   - Execute steps 1,2,3,4,5 

##  PreRequisites:
 - Please see section 2 below pertaining to Credentials and Authentication.
 - Please see section 3 below about configuring the AWS key pair.

 - Following sections to be executed if you are NOT using the Docker 
   container mentioned above:
    - Clone the terraform-templates repository
    - Clone the ansible-pan repository to a location that is accessible on the same
      machine as the terraform templates.
    - Make sure to have your aws key pair also available that will be used 
      for the deployment. 
    - Please make sure have Ansible installed on your system. 

## Default username and password

### Please note that the vars-sample.yml file has the username and password that will be used. Its highly recommended to changes these values to suit your needs and compliance requirements.

### 1. Terraform and Ansible Integration and Directory Layout Recommendation:

  The following directory layout is recommended:

  - top level directory
      - terraform-templates (git cloned into this directory under the top level)
      - ansible-pan         (git cloned into this directory under the top level)

  - Example:
    [root@18ba5ce212ce home]# ls -v
    ansible-pan  creds  pan_install.sh  terraform-templates


### 2. Credentials and Authentication:

  - Populate the ```aws_creds.tf ``` file with the AWS ACCESS_KEY and SECRET_KEY.

  - The structure of the ```aws_creds.tf``` file should be as follows:

    ```
        provider "aws" {
          access_key = "<access_key>"
          secret_key = "<secret_key>"
          region     = "${var.aws_region}"
        }
    ```

### 3. AWS Key Pair Reference and Usage 

  - The private key associated with the deployment will be required during this deployment. 
  - ### Please note the directory path and the file name of the AWS key pair shown below. These will either need to match as shown or be edited to match your file names and directory paths.
  - This key is used and referenced in two files of this deployment:
    - /home/terraform-templates/aws_two_tier_no_bootstrap/terraform.tfvars
      - the path to the key pair needs to be specified as shown below:
      - aws_key_pair_id = "/home/creds/my-key.pem"
    - /home/ansible-pan/ansible-playbooks/terraform_integration/vars-sample.yml
      - the path to the key pair needs to be specified as shown below:
      - key_name: "/home/creds/my-key.pem"

### Usage:

   run terraform: ```terraform apply```

### Support:

This CFT is released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
