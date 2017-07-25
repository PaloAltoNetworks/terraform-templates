
## The following matrix can be used to identify the AMI ID to use for the webserver
   depending upon the Architecture (Table 2 below) and the Region (from Table 1).

## The matrix below contains the Region to AMI ID mapping
### Table 1.

| Region | AMI-ID |
| -------| ------- |
| "us-east-1"|"PV64" : "ami-1ccae774", "HVM64" : "ami-1ecae776", "HVMG2" : "ami-8c6b40e4"|
|      "us-east-2"|"PV64" : "NOT_SUPPORTED", "HVM64" : "ami-c55673a0", "HVMG2" : "NOT_SUPPORTED"|
|      "us-west-2"|"PV64" : "ami-ff527ecf", "HVM64" : "ami-e7527ed7", "HVMG2" : "ami-abbe919b"|
|      "us-west-1"|"PV64" : "ami-d514f291", "HVM64" : "ami-d114f295", "HVMG2" : "ami-f31ffeb7"|
|      "eu-west-1"|"PV64" : "ami-bf0897c8", "HVM64" : "ami-a10897d6", "HVMG2" : "ami-d5bc24a2"|
|      "eu-central-1"|"PV64" : "ami-ac221fb1", "HVM64" : "ami-a8221fb5", "HVMG2" : "ami-7cd2ef61"|
|      "ap-northeast-1"|"PV64" : "ami-27f90e27", "HVM64" : "ami-cbf90ecb", "HVMG2" : "ami-6318e863"|
|      "ap-southeast-1"|"PV64" : "ami-acd9e8fe", "HVM64" : "ami-68d8e93a", "HVMG2" : "ami-3807376a"|
|      "ap-southeast-2"|"PV64" : "ami-ff9cecc5", "HVM64" : "ami-fd9cecc7", "HVMG2" : "ami-89790ab3"|
|      "sa-east-1"|"PV64" : "ami-bb2890a6", "HVM64" : "ami-b52890a8", "HVMG2" : "NOT_SUPPORTED"|
|      "cn-north-1"  |"PV64" : "ami-fa39abc3", "HVM64" : "ami-f239abcb", "HVMG2" : "NOT_SUPPORTED"|

## The matrix below represents the Web Server AMI ID Matrix for the various architectures
   and regions.
### Table 2
| Instance Type | Arch |
| ------| -------|
|"t1.micro" | "PV64"   |
|"t2.micro"    | "HVM64"  |
|"t2.small"    | "HVM64"  |
|t2.medium|   "HVM64"  |
|m1.small|    "PV64"   |
|"m1.medium"   | "PV64"   |
|"m1.large"    | "PV64"   |
|"m1.xlarge"   | "PV64"   |
|"m2.xlarge"   | "PV64"   |
|"m2.2xlarge"  | "PV64"   |
|"m2.4xlarge"  | "PV64"   |
|"m3.medium"   | "HVM64"  |
|"m3.large"    | "HVM64"  |
|"m3.xlarge"   | "HVM64"  |
|"m3.2xlarge"  | "HVM64"  |
|"c1.medium"   | "PV64"   |
|"c1.xlarge"   | "PV64"   |
|"c3.large"    | "HVM64"  |
|"c3.xlarge"   | "HVM64"  |
|"c3.2xlarge"  | "HVM64"  |
|"c3.4xlarge"  | "HVM64"  |
|"c3.8xlarge"  | "HVM64"  |
|"c4.large"    | "HVM64"  |
|"c4.xlarge"   | "HVM64"  |
|"c4.2xlarge"  | "HVM64"  |
|"c4.4xlarge"  | "HVM64"  |
|"c4.8xlarge"  | "HVM64"  |
|"g2.2xlarge"  | "HVMG2"  |
|"r3.large"    | "HVM64"  |
|"r3.xlarge"   | "HVM64"  |
|"r3.2xlarge"  | "HVM64"  |
|"r3.4xlarge"  | "HVM64"  |
|"r3.8xlarge"  | "HVM64"  |
|"i2.xlarge"   | "HVM64"  |
|"i2.2xlarge"  | "HVM64"  |
|"i2.4xlarge"  | "HVM64"  |
|"i2.8xlarge"  | "HVM64"  |
|"d2.xlarge"   | "HVM64"  |
|"d2.2xlarge"  | "HVM64"  |
|"d2.4xlarge"  | "HVM64"  |
|"d2.8xlarge"  | "HVM64"  |
|"hi1.4xlarge" | "HVM64"  |
|"hs1.8xlarge" | "HVM64"  |
|"cr1.8xlarge" | "HVM64"  |
|"cc2.8xlarge" | "HVM64"  |