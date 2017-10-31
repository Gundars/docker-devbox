```

   Devbox
   
   Host: Windows/Linux/Mac
   Guest: Vagrant (Ubuntu 16:04 x64)
   Features: PHP 7.1 fpm with Nginx 1.10.3 :80 AND Apache 2.4 :8080 on Ubuntu, Redis, Mail server, Blackfire profiler
   
   Docker Containers:
   NAMES                  CONTAINER ID    CREATED AT                       CREATED        SIZE                 
   devbox-redis           21cef0e80862    2017-10-12 16:47:49 +0200 CEST   31 hours ago   0B (virtual 107MB)
   devbox-blackfire       6036ab2d0053    2017-10-12 16:47:49 +0200 CEST   31 hours ago   0B (virtual 21.6MB)
   devbox-php-nginx       c1ef009da069    2017-10-12 16:47:49 +0200 CEST   31 hours ago   83.8kB (virtual 710MB)
   devbox-php-apache      6ab2d09af114    2017-10-12 16:47:49 +0200 CEST   31 hours ago   83.8kB (virtual 670MB)
   devbox-mailserver      ea620ae114ca    2017-10-12 14:08:13 +0200 CEST   34 hours ago   0B (virtual 19.3MB)
  
   PHP + Nginx   at http://devbox.local
   PHP + Apache2 at http://devbox.local:8080
   Mailhog       at http://devbox.local:8025
   Mailhog SMTP  at http://devbox.local:1025
   Redis         at http://devbox.local:6379
   
```

Intitial Setup
- Install Virtualbox, Vagrant, Git Bash
- Add `192.168.66.66 devbox.local` to hosts file
- Git clone this repo
- copy `example.env` to `.env`
- execute `vagrant up --provision`
- Check if `http://devbox.local` and `http://devbox.local:8080` works 
- Create project in PHPStorm or worse IDE, source is ./www directory on Windows PC
- ./www, ./logs, ./ as /vagrant dirs 3-way sync to the Docker containers

Daily Usage
- `vagrant up` - boots box, creates Docker containers
- PHP APIs Nginx at http://devbox.local
- PHP APIs Apache2 at http://devbox.local:8080
- Mailhog at http://devbox.local:8025
- Mailhog SMTP at http://devbox.local:1025
- Redis at http://devbox.local:6379

Additional Daily Usage
- `vagrant reload` - restarts box, re-creates Docker containers
- `vagrant suspend` - copies box to memory and suspends
- `vagrant halt` - shuts down box
- `vagrant halt` + `vagrant destroy devbox` + `vagrant up` - hard-reset everything
- `sudo docker-cleanup && cd /vagrant && sudo docker-compose up -d` in guest box, to fully reset docker containers

Notes:
- www, logs, scripts 3-way sync: ./www directory rsyncs to /var/www of vagrant box, which rsyncs to /var/www in web container
- Pass files to container with ./www directory or /vagrant directory
- use `docker-cleanup` command to find and destroy everything Docker related within the vagrant box
- access console of vagrant box via putty (ubuntu:ubuntu) or `vagrant ssh` cli command
- once in Vagrant's console, access console of a single container:
  - `sudo docker ps` will output details including ID of f.i. web container
  - `sudo docker exec -i -t CONTAINER_ID_HERE /bin/bash` will ssh into container
  - OR by name directly: ```sudo docker exec -i -t `sudo docker ps -aqf "name=devbox-php-nginx"` /bin/bash```
  - to execute command not shell, remove `-i` option from previous command
- mailserver accepts any values, such as: `<?php mail("recipient", "subject", "message", "From: Sender");`
- if `vagrant up` fails with "Can't locate /vagrant dir in guest box." exec `vagrant reload`
- if `vagrant up` fails with "The machine is in the 'unknown' state. " exec `vagrant halt`
- if `vagrant up` fails with "Temporary failure resolving 'archive.ubuntu.com'" disable and enable network adapters in Windows host settings
