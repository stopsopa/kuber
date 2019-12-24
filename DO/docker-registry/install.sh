#!/bin/bash

. ./Infrastructure/Registry/.env && echo ${DOCKERREGISTRY}

yum install -y httpd-tools

echo "Installing bare minimum soft"
yum install -y firewalld httpd-tools \
    && systemctl start firewalld \
    && systemctl enable firewalld \
    && service docker stop \
    && service docker start
    # restart docker after running firewall because docker might not see firewall without it

yum install -y epel-release \
    && yum install -y python-pip gcc \
    && pip install docker-compose requests urllib3 pyOpenSSL --force --upgrade
yum upgrade -y python*

docker run -it --rm --name certbot -p 80:80 \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly \
    --standalone -d ${DOCKERREGISTRY} --preferred-challenges http \
    --agree-tos -n -m ${CERTBOT_EMAIL}

htpasswd -cBb ~/.htpasswd ${PASSWD_USER} ${PASSWD_PASSWORD}

echo "Running docker registry image"
cd ./Infrastructure/Registry/ && docker-compose up -d

# Or manually using docker run
# sudo docker run -d --name registry --restart=always \
#      -p 443:5000 -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
#      -e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/letsencrypt/live/docker.domain.com/fullchain.pem \
#      -e REGISTRY_HTTP_TLS_KEY=/etc/letsencrypt/live/docker.domain.com/privkey.pem \
#      -e REGISTRY_AUTH=htpasswd \
#      -e REGISTRY_AUTH_HTPASSWD_REALM="Docker Registry Realm" \
#      -e REGISTRY_AUTH_HTPASSWD_PATH=/htpasswd \
#      -v /etc/letsencrypt:/etc/letsencrypt \
#      -v /var/lib/docker/registry:/var/lib/registry \
#      -v ~/.htpasswd:/htpasswd \
#      registry:2



# Tagging and pushing the image to the private repo
# docker login https://${DOCKERREGISTRY}
# vi ~/.docker/config.json   <--- the creds will go here
# docker tag dd156dd42341 ${DOCKERREGISTRY}/docker-image/here    <--- dd156dd42341 is an image hash
# docker push ${DOCKERREGISTRY}/docker-image/here
