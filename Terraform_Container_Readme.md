Palo Alto Networks Terraform and Ansible Automation Container
-------------------------------------------------------------


Overview
========

The objective for the Docker Container made available by Palo Alto Networks are as follows:

 - Enable the easy deployment and configuration of Palo Alto Network Firewalls, for multi-tier architectures 
   in a multi-cloud environment (AWS and Azure).
   
 - Provide a pre-packaged runtime wherein environment and package dependencies are addressed 
   and managed on behalf of the user of the container. 
   
 - Ensure the latest Palo Alto Terraform and Ansible code base are used in the deployments. 
 

Steps to use the Palo Alto Networks Automation (Terraform + Ansible) Container 
==============================================================================

0. Pre-requisites 

   __NOTE__ Credentials for the AWS and / or the Azure Cloud Platforms are required 
   
   - If the intention is to use __AWS cloud__, then please ensure the following:
    
     a. You have a file named: ```<filename>.tf```
     b. The contents of the file should be as follows:
     
        ```
            provider "aws" {
                access_key = "<aws access key>"
                secret_key = "<aws secret key"
                region     = "${var.aws_region}"
            }
        ```
        
   - If the intention is to use the __Azure Cloud__, then please ensure the following:
   
       a. You have a file named ```<filename>.tf```
       b. The contents of the file should be as follows:
       
            ```
            provider "azurerm" {
              subscription_id = "<subscription id>"
              client_id = "<client id>"
              client_secret = "<client secret>"
              tenant_id = "<azure ad tenant id>"
            }
            ```
    
   - __Recommendation__ Place both of of the files in a directory called ```/<path to directory>/cloud_creds```
     
     This directory will be mapped into the container when deployed. 

1. Install docker (docker runtime engine)on your machine. 

2. Download (pull) the Palo Alto Docker Image

   ```
   - docker search terraform_ansible
   
     SJCMACT0E6G8WL:~$ docker search terraform_ansible
     NAME                            DESCRIPTION   STARS     OFFICIAL   AUTOMATED
     vinayvenkat/terraform_ansible                 0
   
   - docker pull vinayvenkat/terraform_ansible 
     
   ```
3. Run the image as a docker container with the following command:
 
   __NOTE__: Please note the -v option in the command below, which maps a local directory 
             into the container. 
 
   ``` docker run -v /<path to directory>/cloud_creds:/home/creds -it vinayvenkat/terraform_ansible ``` 

   __NOTE__: This will run the container and drop into a shell on the container. 

4. __Execute inside the container__ ``` cd /home ```

5. __Execute inside the container__ ``` ./pan_install.sh ```

    __NOTE__: This will install all the necessary binaries, packages as well as the 
              Palo Alto Networks terraform and ansible code from the respective github repos. 
              
6. __AWS one-click-deployment Use Case__
     
   __NOTE__: This template will deploy a multi-tier application on to AWS using Terraform. 
             Additionally, ```terraform``` will orchestrate and invoke ```ansible``` to configure 
             the firewall. 
              
   - ``` cd /home/terraform-templates/one-click-multi-cloud/one-click-aws ```
   - ``` cp /home/creds/<aws creds filename>.tf .```
   - ``` terraform apply ```
   - input the required parameters
   - Upon completion of tall the defined actions, ``` terraform ``` will output both the
     Firewalls Public IP address as well as IP address to access the web service being 
     protected by the Palo Alto Networks firewall. 
     
7. __Azure one-click-deployment Use Case__
     
   __NOTE__: This template will deploy a multi-tier application on to Azure using Terraform. 
             Additionally, ```terraform``` will orchestrate and invoke ```ansible``` to configure 
             the firewall. 
              
   - ``` cd /home/terraform-templates/one-click-multi-cloud/one-click-azure ```
   - ``` cp /home/creds/<azure creds filename>.tf .```
   - ``` terraform apply ```
   - input the required parameters
   - Upon completion of tall the defined actions, ``` terraform ``` will output both the
     Firewalls Public IP address as well as IP address to access the web service being 
     protected by the Palo Alto Networks firewall.

