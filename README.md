PaloAltoNetworks Repository of Terraform Templates to Secure Workloads on AWS and Azure
---------------------------------------------------------------------------------------

This repository contains Terraform templates to deploy 3-tier and 2-tier applications along with the PaloAltoNetworks Firewall
on cloud platforms such as AWS and Azure.

The templates provided in these repositories provide best practice guidelines to deploy workloads on public cloud platforms
and to secure these workloads using the PaloAltoNetworks VM-Series Firewall.

``` Note: Each of the sub repos contain a README with instructions on usage and deployment. ```

This repo contains the following sub repositories:

   - ``` aws_elb_autoscale ```

      - Deploy a 3-tier application
      - Deploy and External Load Balancer that sits in front of the PAN FW's.
      - Deploy the PAN FW into an auto scale group
      - Deploy and Internal Load Balancer that site behind the PAN FW and fronts the web tier
      - Deploys the lambda functions to configure the PANFW's

   - ``` aws_two_tier_no_bootstrap_with_ansible ```

      - Deploy a two tier application
      - Deploy the Web instances into a secure subnet
      - Deploy the PAN FW with interfaces on the untrust, trust and management subnets.
      - Deploy an application on the backend trust subnets.
      - Configures the VM-Series with Ansible 
      - Ansible is invoked directly from Terraform

   - ``` aws_two_tier ```

      - Deploy a two tier application
      - Deploy the Web instances into a secure subnet
      - Deploy the PAN FW with interfaces on the untrust, trust and management subnets.

   - ``` azure_two_tier_sample ```

      - Deploy a two tier application
      - Deploy the Web instances into a secure subnet
      - Deploy the PAN FW with interfaces on the untrust, trust and management subnets.

   - ``` Automated Terraform & Ansible One-click deployment for AWS and Azure```

        [Terraform and Ansible Docker Container README](./Terraform_Container_Readme.md)

Support:
--------

These templates are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
