it turns out that the only step that needs to be done is to generate a new certificate using the below doctl tool and attach the certificateID to the loadbalancer.yml file:

`doctl compute certificate create  --name k8s-cert-san  --type lets_encrypt --dns-names kuber.phaseiilabs.com,kuber2.phaseiilabs.com`

the output should be similar to:
```
# ID                                      Name            DNS Names                                       SHA-1 Fingerprint    Expiration Date         Created At              Type            State
# 876d5842-8e6e-4c2e-a1f2-aad78eed688e    k8s-cert-san    kuber.phaseiilabs.com,kuber2.phaseiilabs.com                         0001-01-01T00:00:00Z    2019-12-16T14:57:19Z    lets_encrypt    pending
```

If you now take the ID (which will be **876d5842-8e6e-4c2e-a1f2-aad78eed688e** in our case) and check the status of it: 
`doctl compute certificate get 876d5842-8e6e-4c2e-a1f2-aad78eed688e`
you should see that the certificate has been verified successfully:
```
ID                                      Name            DNS Names                                       SHA-1 Fingerprint                           Expiration Date         Created At              Type            State
876d5842-8e6e-4c2e-a1f2-aad78eed688e    k8s-cert-san    kuber.phaseiilabs.com,kuber2.phaseiilabs.com    ea57bcb1e39e51164363c880e2576b41cbefa421    2020-03-15T13:57:20Z    2019-12-16T14:57:19Z    lets_encrypt    verified
```

> > >

now just run:
`kubectl apply -f loadbalancer.yaml`


## Other commands
To ensure the load balancer is working as expected:
`kubectl describe svc ingress-nginx --namespace ingress-nginx`


