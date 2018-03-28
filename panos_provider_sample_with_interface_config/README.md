PaloAltoNetworks Terraform Template which uses the panos provider to deploy policies on the VM-Series FW
-------------------------------------------------------------------------------------------------------

This repository contains Terraform templates to deploy policies onto the VM-Series Firewalls using the PaloAltoNetworks
Terraform provider. 

This template does the following:

   - Configures the network interfaces
   - Assigns interfaces to virtual routers 
   - Creates zones and attaches interfaces to the specified zones
   - Creates a service object 
   - Creates various NAT rules 
   - Creates various Security rules

Support:
--------

These templates are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
