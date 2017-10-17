# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
##### CONF
os: ubuntu/xenial64
ip: 192.168.66.66
=end

ENV['LANG']="en_US.UTF-8"
ENV['LANGUAGE']="en_US:en"
ENV['LC_CTYPE']="de_DE.UTF-8"
ENV['LC_NUMERIC']="de_DE.UTF-8"
ENV['LC_TIME']="de_DE.UTF-8"
ENV['LC_COLLATE']="de_DE.UTF-8"
ENV['LC_MONETARY']="de_DE.UTF-8"
ENV['LC_MESSAGES']="de_DE.UTF-8"
ENV['LC_PAPER']="de_DE.UTF-8"
ENV['LC_NAME']="de_DE.UTF-8"
ENV['LC_ADDRESS']="de_DE.UTF-8"
ENV['LC_TELEPHONE']="de_DE.UTF-8"
ENV['LC_MEASUREMENT']="de_DE.UTF-8"
ENV['LC_IDENTIFICATION']="de_DE.UTF-8"

required_plugins = %w( vagrant-timezone vagrant-vbguest vagrant-env vagrant-triggers)
required_plugins.each do |plugin|
  unless Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
  end
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.env.enable

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = "Europe/Berlin"
  end

  config.vm.network "private_network", ip: "192.168.66.66"
  config.vm.hostname = "devbox.local"
  config.vm.synced_folder "www", "/var/www", create: true
  config.vm.synced_folder "logs", "/logs", create: true
  config.vm.synced_folder "scripts", "/scripts", create: true

  config.vm.define "devbox" do |host|
  end

  config.vm.provider :virtualbox do |vb|
    vb.name = "devbox"
    vb.memory = "1024"
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  # setup ENV VARS on guest before anything else, for Ubuntu user only
  config.vm.provision "shell", inline: "echo $(sed 's/^/export /' .env) >> ~/.profile && . ~/.profile", run: 'always'

  # setup box only when provisioning
  config.vm.provision "shell", path: "scripts/vagrant-provision.sh"

  # setup docker each time vagrant starts
  config.vm.provision "shell", path: "scripts/vagrant-upstart.sh", run: 'always'

  # enabling this will pull data in guest box, there is more flexible script enabled to pull directly in container
  # config.vm.provision :shell, path: "scripts/vagrant-refresh-code.sh", run: 'always'

 config.vm.provision "shell", inline: <<-SHELL
   echo "ubuntu:ubuntu" | sudo chpasswd
 SHELL

end
