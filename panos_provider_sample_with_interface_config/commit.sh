KEY=`curl -s -kd 'user=admin&password=paloalto&type=keygen' https://$1/api | awk '{print $NF $(NF-1)}' | awk -F '>' '{print $(NF-3)}' | awk -F '<' '{print $(NF-1)}'`
echo $KEY
curl -kd "type=commit&cmd=<commit><description>This is my commit message</description></commit>&key=$KEY" https://$1/api
