while true
do
  echo "$1" >> /tmp/pan.log
  resp=$(curl -vvv -s -S -g --insecure "https://$1")
  exit_code=$?
  if [ $exit_code -ne 0 ] ; then
    echo "Continuing.." >> pan.log
    echo "Continuing because exit code not 0"
  else
    echo "Breaking out because exit code is 0"
    break
  fi
  echo "Response $exit_code" 
  sleep 10s
done
for i in `seq 1 48` 
do
sleep 5
echo "Mandatory wait for api access... "
done
echo "Exiting.."
exit 0
