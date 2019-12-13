based on:
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
g(Hanif Jetha)How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes By

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
