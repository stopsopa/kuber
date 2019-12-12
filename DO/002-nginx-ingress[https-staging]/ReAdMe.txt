https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
g(How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes By Hanif Jetha)

WARNING: DO installation process seems to be wrong

follow:
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml
    # from : https://cert-manager.io/docs/installation/kubernetes/
    # to verify:
        kubectl get pods --namespace cert-manager
        kubectl logs cert-manager-XXX -n cert-manager

    # might be necessary:
        helm ls --all cert-manager
        # if there will be listed any version of cert manager installed wrom helm then:
        helm del --purge cert-manager

        kubectl get pods --namespace cert-manager
        kubectl get deployment --namespace cert-manager
        kubectl delete  deployment cert-manager  cert-manager-cainjector  cert-manager-webhook  --namespace cert-manager
