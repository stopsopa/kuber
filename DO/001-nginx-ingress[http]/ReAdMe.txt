based on:
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
g(Hanif Jetha)How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes By


    * helm

        https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager

    * Creating loadbalancer in DO:

        WARNING: we have updated version in link

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.1/deploy/static/provider/cloud-generic.yaml

        kubectl get services --namespace ingress-nginx
        kubectl describe services --namespace ingress-nginx

        from: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-2-%E2%80%94-setting-up-the-kubernetes-nginx-ingress-controller
            more general about creating loadbalancers in DO
                https://www.digitalocean.com/docs/kubernetes/how-to/add-load-balancers/

    * Installing Kubernetes Nginx Ingress Controller in the cluster:

        WARNING: we have updated version in link

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.1/deploy/static/mandatory.yaml

            from: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-2-%E2%80%94-setting-up-the-kubernetes-nginx-ingress-controller


    * installing cert-manager from:

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










