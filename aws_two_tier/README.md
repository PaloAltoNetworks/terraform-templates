Terraform Templates to Deploy Infrastructure onto AWS
-------------------------------------------------------

0. PreRequisites:
-------------
 - Please see section 2 below pertaining to Credentials and Authentication.
 - Please see section 3 below about Configuring the S3 bucket.

1. Code Organization:
-----------------

  ```
      aws_two-tier/
      - aws_two_tier.tf: Contains the definition of the various artifacts that will be deployed on AWS.
      - aws_vars.tf: Define the various variables that will be required as inputs to the Terraform template.
      - terraform.tfvars: Defines default values for all the variables.
      - webserver_config_amzn_ami.sh: The commands to pass as userdata to be executed on an instance.
  ```

  Note: The aws_vars.tf has default values provided for certain variables. These can obviously be overridden by
        specifying those variables and values in the terraform.tfvars file.

2. Credentials and Authentication:
------------------------------

  - Create a file called ```aws_creds.tf ``` to provide the AWS ACCESS_KEY and SECRET_KEY.

  - The structure of the ```aws_creds.tf``` file should be as follows:

    ```
        provider "aws" {
          access_key = "<access_key>"
          secret_key = "<secret_key>"
          region     = "${var.aws_region}"
        }
    ```

3. Configuring the S3 bucket

  - Create and S3 bucket in the region the infrastructure will be deployed to.
  - In the bucket, create the following folders:
    - ```config```
    - ```license```
    - ```software```
    - ```content```
  - Upload files the various buckets from the following link:
    ``` https://github.com/PaloAltoNetworks/aws/tree/master/two-tier-sample/bootstrap ```
    - Upload the ``` bootstrap.xml ``` and ``` init-cfg.txt ``` files to the ``` config ``` folder.
    - Upload the ```panupv2-all-contents-695-4002``` file to the ``` content ``` folder.

  - Hint: Its probably a good idea to clone the ```PaloAltoNetworks / aws ```
          repo (link: ```https://github.com/PaloAltoNetworks/aws ``` ) to your machine, and then navigate
          to the ```two-tier-sample``` folder and upload the files. Please note the name of the parent folder: ```two-tier-sample``` and not the ``` two-tier sample```. Note the space in the latter.

Usage:
------

   run terraform: ```terraform apply```

Support:
--------

This CFT is released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
