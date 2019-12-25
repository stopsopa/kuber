# create kubernetes cluster version: 1.16.2-do.1 (latest)

# cli - installing cli on dev machine and "talk" to kubernetes remotely

    # from: https://confluence.atlassian.com/bitbucketserverkb/13-permission-denied-while-connecting-to-upstream-while-configuring-ngnix-803374014.html
    cli:
        kubectl doctl:
            # first install and init doctl:
                 https://github.com/digitalocean/doctl#authenticating-with-digitalocean
             # then copy config
                 https://www.digitalocean.com/docs/kubernetes/how-to/connect-to-cluster/#generating-a-kubectl-configuration-via-command-line
                 doctl auth init   # to get token follow https://github.com/digitalocean/doctl#authenticating-with-digitalocean
                 doctl kubernetes cluster list
                 doctl kubernetes cluster kubeconfig save k8s-kubii
                     # it makes some mess here: https://cloud.digitalocean.com/account/api/tokens
             # verify:
                 kubectl get nodes

based on:
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
g(Hanif Jetha)How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes By

    * helm
        https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager#step-1-%E2%80%94-installing-helm

    * install tiller
        https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager#step-2-%E2%80%94-installing-tiller
                helm version

    * Installing Kubernetes Nginx Ingress Controller in the cluster:

        WARNING: we have updated version in link

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.1/deploy/static/mandatory.yaml

            from: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-2-%E2%80%94-setting-up-the-kubernetes-nginx-ingress-controller

    * create https certificate: https://www.digitalocean.com/docs/kubernetes/how-to/configure-load-balancers/
        doctl compute certificate list
        doctl compute certificate create --name certv002 --type lets_encrypt --dns-names httptest.phaseiilabs.com,kuber.phaseiilabs.com,kuber2.phaseiilabs.com
        doctl compute certificate get eebf2fd0-8331-4432-8d37-87ce0631869a

    * Creating loadbalancer in DO:

        WARNING: we have updated version in link

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.1/deploy/static/provider/cloud-generic.yaml
            # WARNING: for https this is not enough, see example file "loadbalancer.yaml" in this folder
            # change value under kay service.beta.kubernetes.io/do-loadbalancer-certificate-id for generated certificate id

        kubectl get services --namespace ingress-nginx
        kubectl describe services --namespace ingress-nginx

        from: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-2-%E2%80%94-setting-up-the-kubernetes-nginx-ingress-controller
            more general about creating loadbalancers in DO
                https://www.digitalocean.com/docs/kubernetes/how-to/add-load-balancers/

            more about loadbalancers:
                https://www.digitalocean.com/docs/networking/load-balancers/#plans-and-pricing
                https://www.digitalocean.com/docs/kubernetes/how-to/add-load-balancers/
                kubectl --kubeconfig=loadbalancer.yaml get services
                kubectl describe svc kube-test-loadbalancer

    * (NOT NECESSARY) installing cert-manager from:

        WARNING: we have updated version in link

            kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

            kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.12.0/deploy/manifests/00-crds.yaml
                both links from:  https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-4-%E2%80%94-installing-and-configuring-cert-manager

        kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"

        helm chart:
            helm repo add jetstack https://charts.jetstack.io

            helm install --name cert-manager --namespace kube-system jetstack/cert-manager --version v0.12.0

    * Creating docker repository/registry

        Centos installation process:
               https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository
                   g(Get Docker Engine - Community for CentOS)

            yum install -y yum-utils device-mapper-persistent-data lvm2
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

            # INSTALL DOCKER ENGINE - COMMUNITY
                yum install -y docker-ce docker-ce-cli containerd.io

                yum list docker-ce --showduplicates | sort -r     # from https://docs.docker.com/install/linux/docker-ce/centos/#install-docker-engine---community-1
                version: docker-ce.x86_64    3:19.03.5-3.el7     docker-ce-stable

                yum install -y docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
                yum install -y docker-ce-19.03.5 docker-ce-cli-19.03.5 containerd.io
                systemctl start docker
                yum install -y git

            # install docker compose  https://docs.docker.com/compose/install/
                curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod a+wx /usr/local/bin/docker-compose
                docker-compose --version

            # now install DOCKER HUB:  https://docs.docker.com/registry/deploying/
            mkdir -p /opt/docker-registry/ && echo "cd /opt/docker-registry/" > doc && chmod a+x doc && cd /opt/docker-registry/
            git clone https://github.com/tomekwlod/kuber.git && mv kuber/DO/docker-registry/* . && rm -rf kuber/
            # git clone https://github.com/stopsopa/kuber.git && mv kuber/DO/docker-registry/* . && rm -rf kuber/

            # test connectivity to domain:
                    mkdir node && cd node
                    yum -y install wget
                    sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
                    sudo firewall-cmd --reload
                    wget https://nodejs.org/download/release/v8.15.1/node-v8.15.1-linux-x64.tar.gz
                    tar --strip-components 1 -xzvf node-v* -C /usr/local
                    npx npx-server server.js controllers
                    node server.js --port 8080 & disown
                    curl -I localhost:8080
                    cd ..

            # make sure that DNS is globally propagated, uset tools like https://dnschecker.org/#A/

            # git clone https://github.com/tomekwlod/docker-registry.git .

            WARNING: edit file
                vi Infrastructure/Registry/.env

            /bin/bash install.sh
            
            # to test repository:
                
                https://docker-registry.phaseiilabs.com/v2/
                
                https://docker-registry.phaseiilabs.com/v2/_catalog
                
                https://docker-registry.phaseiilabs.com/v2/{your-repo-name-here}/tags/list
                
                https://docker-registry.phaseiilabs.com/v2/twlphaseii/node-jenkins-docker/manifests/latest
                    # to download and see the metadata for the tag

            # then try to login from cli
            docker login https://docker-registry.phaseiilabs.com
            docker login https://docker-registry.phaseiilabs.com --username=yourhubusername --password=yourpassword
            cat ~/.docker/config.json

            docker login https://docker-registry.phaseiilabs.com
            vi ~/.docker/config.json <--- the creds will go here

            # https://docs.docker.com/engine/reference/commandline/build/
            # execute it in directory https://github.com/stopsopa/kuber/tree/master/001-simple-app/docker/image
                REGISTRY="docker-registry.phaseiilabs.com"
                APP="tapp"
                VER="0.0.3"
                docker build -t $APP:$VER .
                docker tag $APP:$VER $REGISTRY/$APP:$VER
                docker push $REGISTRY/$APP:$VER

                # TAG="$(docker build -t $APP:$VER . | grep " built " | awk '{print $3}')"
                # docker history tapp:0.0.1
                # https://docker-registry.phaseiilabs.com/v2/tapp/tags/list
                # docker run -it node:10-alpine node -v   # https://hub.docker.com/_/node/

    * Using private registry from kubernetes
        # g(Pull an Image from a Private Registry)
        # https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials

        # https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-secret-by-providing-credentials-on-the-command-line

        docker run -p 8082:80 docker-registry.phaseiilabs.com/tapp:0.0.5

        kubectl delete secret regcred
        kubectl create secret docker-registry regcred \
            --docker-server=docker-registry.phaseiilabs.com \
            --docker-username=admin \
            --docker-password=password \
            --docker-email=admin@gmail.com

        kubectl get secrets
        kubectl get secret regcred --output=yaml
        kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt

Read more:
    https://www.digitalocean.com/docs/networking/dns/how-to/create-caa-records/










