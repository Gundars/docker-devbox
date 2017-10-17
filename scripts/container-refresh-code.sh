#!/usr/bin/env bash

cd /var

if [ -d "www" ] && [ -z "$(ls -A www)" ] && [ -d "/vagrant" ]; then

    if [ -f "/vagrant/.env" ]; then
        # load env vars from repo root
        echo -e "\nReloading web containers ENV VARS from /vagrant/.env\n"
        echo $(sed 's/^/export /' /vagrant/.env) >> ~/.profile && source ~/.profile
    else
        echo -e "\nNo .env file detected, must not have synced from vagrantfile or dockerfile.\nABORTING!\n"
        exit
    fi

    echo -e "\n\n>>WWW dir is empty, pulling code from Gitlab"
    echo -e ">> You have 5sec to ABORT by pressing CTRL+C"

    sleep 7

    echo -e "Refreshing code from ${GITLAB_HOST} project ${GITLAB_PROJECT}"

    for repo in $(echo ${GITLAB_REPOS} | sed "s/,/ /g")
    do
        echo -e "Cloning git ${repo}"
        git clone --quiet ${GITLAB_PROTOCOL}://${GITLAB_USER}:${GITLAB_TOKEN}@${GITLAB_HOST}/${GITLAB_PROJECT}/$repo.git "www/$repo"

        # disabled until git cred transfer to container is in place
        # Composer? Composer!
        #if [ -d "www/$repo/approot" ]; then
        #    if [ -f "www/$repo/approot/composer.lock" ]; then
        #        echo -e "Composer.lock file detected, doing install..."
        #        composer --working-dir="www/$repo/approot" install --no-progress --optimize-autoloader
        #    elif [ -f "www/$repo/approot/composer.json" ]; then
        #        echo -e "Composer.json file detected, doing update..."
        #        composer --working-dir="www/$repo/approot" update --no-progress --optimize-autoloader
        #    else
        #        echo -e "Neither composer.json nor composer.lock found in approot. Skipping composer updates"
        #    fi
        #fi
    done
else
    echo -e "OK"
fi