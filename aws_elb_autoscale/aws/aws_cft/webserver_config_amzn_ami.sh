#!/bin/bash
sleep 30
yum update -y
yum install -y httpd24
service httpd start
chkconfig httpd on
groupadd www
usermod -a -G www ec2-user
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +
find /var/www -type f -exec chmod 0664 {} +
echo "<img src=\"https://www.paloaltonetworks.com/content/dam/pan/en_US/images/logos/brand/pan-logo-badge-blue-medium-kick-up.png\" alt=\"VM-Series CloudFormation\"/>" > /var/www/html/index.html
echo "<h1>Congratulations, you have successfully launched VM-Series ASG CloudFormation. </h1>" >> /var/www/html/index.html
echo "<h1>This templates creates - VPC, Subnets, Route Tables, Webservers ASG, Lambda Infra </h1>" >> /var/www/html/index.html
