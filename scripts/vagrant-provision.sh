#!/bin/bash

echo ">> Set Timezone to Europe/Berlin"
sudo timedatectl set-timezone Europe/Berlin

echo ">> Updating apt sources"
sudo apt-get update

echo ">> Installing Docker"
sudo apt-get -y install linux-image-extra-$(uname -r)
wget -qO- https://get.docker.com/ | sh

echo ">> Installing Docker Compose"
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
sudo sh -c "curl -Ls https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -Ls https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
docker-compose --version

echo ">> Creating docker-cleanup command"
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
sudo mv docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup

echo ">> Installing tools"
sudo apt-get install -y zsh htop
sudo sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo apt-get install -y net-tools nmap wget curl nano vim

sudo usermod -aG docker ${USER}
echo "cd /vagrant" > /etc/profile.d/login-directory.sh

echo -e ">> Base box set up! :) \n\n"