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

   - ``` aws_two_tier ```

      - Deploy a two tier application
      - Deploy the Web instances into a secure subnet
      - Deploy the PAN FW with interfaces on the untrust, trust and management subnets.

   - ``` azure/two-tier-sample ```

      - Deploy a two tier application
      - Deploy the Web instances into a secure subnet
      - Deploy the PAN FW with interfaces on the untrust, trust and management subnets.
