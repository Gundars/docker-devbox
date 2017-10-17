#!/bin/bash

echo ">> Starting vagrant upstart scripts"
echo ">> Composing Docker..."

if ! [ -d "/vagrant" ]; then
    echo -e "\n>> Can't locate /vagrant dir in guest box. ABORTING"
    echo -e "\n>> Try running 'vagrant reload'"
    exit 1
fi

cd /vagrant
sudo docker-compose up -d -t 120 --build
echo -e "\n\n>> Docker composed! :)"
sleep 3
sudo docker ps --format "table {{.Names}}\t{{.ID}}\t{{.RunningFor}}\t{{.Size}}\t{{.Ports}}"

echo -e "\nPHP APIs Nginx at http://devbox.local"
echo -e "PHP APIs Apache2 at http://devbox.local:8080"
echo -e "Mailhog at http://devbox.local:8025"
echo -e "Mailhog SMTP at http://devbox.local:1025"
echo -e "Redis at http://devbox.local:6379"

echo -e "\nTo SSH into vagrant: vagrant ssh"
echo -e "To SSH into container: sudo docker exec -i -t CONTAINER_ID_HERE /bin/bash"
echo -e "To SSH into container by name: sudo docker exec -i -t \`sudo docker ps -aqf \"name=devbox-php-nginx\"\` /bin/bash\n"

#echo -e "Source code check in web container\n"
#sudo docker exec -t `sudo docker ps -aqf "name=devbox-php-nginx"` /scripts/container-refresh-code.sh
