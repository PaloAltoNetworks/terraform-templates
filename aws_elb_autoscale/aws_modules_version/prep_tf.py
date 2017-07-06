#!/usr/bin/python

import json

tdata = {}
pdata = {
    'LambdaSubnet': "AZSubnetIDLambda",
    'MGMTSubnet' : "AZSubnetIDMgmt",
    'UNTRUST': "AZSubnetIDUntrust",
    "TRUST": "AZSubnetIDTrust",
    "NATGW": "AZSubnetIDNATGW",
    "VPCID": "VPCID",
    "PanFwAmiId": "PanFwAmiId",
    "KeyName": "KeyName",
    "KeyPANWPanorama": "KeyPANWPanorama",
    "KeyDeLicense": "KeyDeLicense",
    "MasterS3Bucket": "MasterS3Bucket",
    "StackName": "StackName",
    "NATGateway": "NATGateway",
    "SSHLocation": "SSHLocation",
    "VPCCIDR": "VPCCIDR"
}

odata = {
    "AZSubnetIDLambda": "",
    "AZSubnetIDMgmt": "",
    "AZSubnetIDUntrust": "",
    "AZSubnetIDTrust": "",
    "AZSubnetIDNATGW": "",
    "VPCID": "",
    "PanFwAmiId": "",
    "KeyName": "",
    "KeyPANWPanorama": "",
    "KeyDeLicense": "",
    "MasterS3Bucket": "",
    "StackName": "",
    "NATGateway": "NATGateway",
    "SSHLocation": "SSHLocation",
    "VPCCIDR": ""
}

def main():

  f = open("./output.tfvars", 'r')

  lines = f.readlines()
  for line in lines:
    key, value = line.split("=")
    tdata[key] = value
  #print(tdata)

  f.close()

  f = open("./terraform.tfvars", "w")
  l = []
  final_str = ""
  for key, value in pdata.items():
      for _k, _v in tdata.items():
          if _k.startswith(key):
              l.append(_v.strip())
      print "The list value for {} : {}".format(value, l)
      final_str = '{} = "{}"'.format(value, ",".join(l))
      l = []
      print odata[value]
      f.write(final_str)
      f.write('\n')
  f.close()

if __name__ == "__main__":
  main()
