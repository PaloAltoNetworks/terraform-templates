#!/bin/bash
sleep 30
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo \"export new_routers='"${aws_network_interface.FWPrivate12NetworkInterface.private_ips[0]}"'\" >> /etc/dhcp/dhclient-enter-hooks.d/aws-default-route"
ifdown eth0
ifup eth0\n"

while true
do
resp=$(curl -s -S -g --insecure \"https://"${aws_eip.ManagementElasticIP.public_ip}"/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=LUFRPT10VGJKTEV6a0R4L1JXd0ZmbmNvdUEwa25wMlU9d0N5d292d2FXNXBBeEFBUW5pV2xoZz09\")",
if [[ $resp == *\"[CDATA[yes\"* ]] ; then
   break
fi
sleep 10s
done
apt-get update
apt-get install -y apache2
