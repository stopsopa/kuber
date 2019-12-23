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

    * create https certificate:
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


Read more:
    https://www.digitalocean.com/docs/networking/dns/how-to/create-caa-records/










