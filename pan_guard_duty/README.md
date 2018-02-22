Terraform Templates to Deploy the Palo Alto Networks Integration with Guard Duty
--------------------------------------------------------------------------------

0. PreRequisites:
-------------
 - Please see section 2 below pertaining to Credentials and Authentication.
 - Please see section 3 below about Configuring the S3 bucket.
 
 
1. Code Organization:
-----------------

  ```
      pan_guard_duty/
      - gd_deploy.tf: Contains the definition of the various components that will be deployed
                      with regards to the integration.
      - gd_vars.tf: Define the various variables that will be required as inputs to the Terraform template.
      - aws_creds.tf: Place holder for the AWS credentials.
      - gd.zip: A pre-canned zip file containing all the code that will be used to deploy the lambda functions
                and the integration.
      - lambda_code/ : The directory containing the lambda code and the dependencies
  ```

2. Credentials and Authentication:
----------------------------------

  - Populate the file called ```aws_creds.tf ``` to provide the AWS ACCESS_KEY and SECRET_KEY.

  - The structure of the ```aws_creds.tf``` file is shown below:

    ```
        provider "aws" {
          access_key = "<access_key>"
          secret_key = "<secret_key>"
          region     = "${var.aws_region}"
        }
    ```
    
  Note: Replace the placeholders for the "<access_key>" and the "<secret_key>" with your account credentials. 
  Note: Please make sure to keep the credentials safe and confidential.
  
  
3. Configuring the S3 Bucket

    - Create an S3 Bucket in the same region in which the Lambda functions will be deployed in.
    - Create a folder in the S3 bucket  
    - Upload the zip file to the folder of the specified bucket
    
    Important (0):
    --------------
    
    The zip file called gd.zip is provided in the folder for convenience. This can be used as is unless 
    you want to make customization in which case you will have to create the zip file again with the updates
    to your code.
    
    Important (1):
    ---------- 
    Please make sure to note the names of the S3 bucket, the folder and 
    the zip file. These will be required as inputs when deploying the 
    terraform templates which will deploy, setup and configure the 
    lambda function and other artifacts. 
          

4. Deploying the Lambda Functions

   - Once steps 2 and 3 have been completed the following command can be executed in order to deploy the lambda function. 
   
   Deployment Command:
   -------------------
   
   - Ensure you are in the <some path>/terraform-templates/pan_guard_duty directory
   - Run the command shown below
   -----------------------------
   terraform apply 
   ---------------