ssh -p 221 -o "StrictHostKeyChecking no" -i $1 ubuntu@$2 'sudo apt-get update -y && sudo apt-get install apache2 -y' 
