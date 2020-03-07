# create kubernetes cluster version: 1.16.2-do.1 (latest)
# create kubernetes cluster version: 1.16.6-do.0 (latest) 2020-03-07

# cli - installing cli on dev machine and "talk" to kubernetes remotely

    cli:
        kubectl doctl:
            # first install and init doctl:
                 https://github.com/digitalocean/doctl#authenticating-with-digitalocean
             # then copy config
                 https://www.digitalocean.com/docs/kubernetes/how-to/connect-to-cluster/#generating-a-kubectl-configuration-via-command-line
                 doctl auth init   # to get token follow https://github.com/digitalocean/doctl#authenticating-with-digitalocean
                    https://cloud.digitalocean.com/account/api/tokens

                 doctl kubernetes cluster list
                 doctl kubernetes cluster kubeconfig save k8s-kubii
                     # it makes some mess here: https://cloud.digitalocean.com/account/api/tokens
        install kubectl
            # https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
            # verify:
                kubectl get nodes

based on:
https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
g(Hanif Jetha)How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes By

    ** helm
    -------------------------------
        https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager#step-1-%E2%80%94-installing-helm
        helm version
            (latest) 2020-03-07
                Client: &version.Version{SemVer:"v2.16.1", GitCommit:"bbdfe5e7803a12bbdf97e94cd847859890cf4050", GitTreeState:"clean"}
                Server: &version.Version{SemVer:"v2.16.1", GitCommit:"bbdfe5e7803a12bbdf97e94cd847859890cf4050", GitTreeState:"clean"}

    ** install tiller
    -------------------------------
        https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager#step-2-%E2%80%94-installing-tiller
                helm version

    ** Installing Kubernetes Nginx Ingress Controller in the cluster:
    -------------------------------

        WARNING: CHECK LATEST: https://github.com/kubernetes/ingress-nginx/releases
            also here: https://kubernetes.github.io/ingress-nginx/deploy/#prerequisite-generic-deployment-command
            kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
                0.30.0 (latest) 2020-03-07

            from: https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-2-%E2%80%94-setting-up-the-kubernetes-nginx-ingress-controller

    ** create https certificate: https://www.digitalocean.com/docs/kubernetes/how-to/configure-load-balancers/
    -------------------------------
        doctl compute certificate list
        doctl compute certificate create --name certv001 --type lets_encrypt --dns-names aml.kub.phaseiilabs.com,www.aml.kub.phaseiilabs.com,lh.kub.phaseiilabs.com,www.lh.kub.phaseiilabs.com
        doctl compute certificate get eebf2fd0-8331-4432-8d37-87ce0631869a

        kubectl get -f loadbalancer.yaml -o jsonpath="{.metadata}"

    ** Creating loadbalancer in DO:
    -------------------------------

        WARNING: we have updated version in link

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml
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
    -------------------------------

        WARNING: we have updated version in link

            kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

            kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.12.0/deploy/manifests/00-crds.yaml
                both links from:  https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-4-%E2%80%94-installing-and-configuring-cert-manager

        kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"

        helm chart:
            helm repo add jetstack https://charts.jetstack.io

            helm install --name cert-manager --namespace kube-system jetstack/cert-manager --version v0.12.0

    * Creating docker repository/registry
    -------------------------------

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
                systemctl enable docker
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
                    sleep 5
                    curl -I localhost:8080
                    cd ..

            # make sure that DNS is globally propagated, use tools like https://dnschecker.org/#A/

            # git clone https://github.com/tomekwlod/docker-registry.git .

            WARNING: edit file
                vi image/.env

            /bin/bash install.sh
            
            # to test repository: https://docs.docker.com/registry/spec/api/#detail
                
                https://docker-registry.phaseiilabs.com/v2/
                
                https://docker-registry.phaseiilabs.com/v2/_catalog
                
                https://docker-registry.phaseiilabs.com/v2/{your-repo-name-here}/tags/list
                
                https://docker-registry.phaseiilabs.com/v2/twlphaseii/node-jenkins-docker/manifests/latest
                    # to download and see the metadata for the tag

                curl -H "authorization: Basic ...=" https://docker-registry.phaseiilabs.com/v2/tapp/manifests/0.0.2

            # then try to login from cli
            docker login https://docker-registry.phaseiilabs.com
            docker login https://docker-registry.phaseiilabs.com --username=yourhubusername --password=yourpassword
            cat ~/.docker/config.json

            vi ~/.docker/config.json <--- the creds will go here

            # https://docs.docker.com/engine/reference/commandline/build/
            # execute it in directory https://github.com/stopsopa/kuber/tree/master/001-simple-app/docker/image
                DOCKER_REGISTRY="docker-registry.phaseiilabs.com"
                APP="tapp"
                VER="0.0.3"
                docker build -t $APP:$VER .
                docker tag $APP:$VER $DOCKER_REGISTRY/$APP:$VER
                docker push $DOCKER_REGISTRY/$APP:$VER

                # TAG="$(docker build -t $APP:$VER . | grep " built " | awk '{print $3}')"
                # docker history tapp:0.0.1
                # https://docker-registry.phaseiilabs.com/v2/tapp/tags/list
                # docker run -it node:10-alpine node -v   # https://hub.docker.com/_/node/

        # install kubectl:
            https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-using-native-package-management

        # install doctl
            # from: https://computingforgeeks.com/install-snapd-snap-applications-centos-7/
            yum -y install epel-release
            yum -y install yum-plugin-copr
            yum -y install snapd
            systemctl enable --now snapd.socket

            # wait here
            snap find doctl

            snap install doctl
            snap connect doctl:kube-config

            # close terminal & open terminal to reload bash session
            doctl auth init # go to the top of this page, from this point it's just the same
            # there is a seciton that describes process further configuration on mac
            # generate token and so on...


    * Using private registry from kubernetes
    -------------------------------
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

    * Garbage collecting Docker Registry
    -------------------------------

        https://docker-registry.phaseiilabs.com/v2/tapp/tags/list
        curl -H "authorization: Basic ..." https://docker-registry.phaseiilabs.com/v2/tatapppp/tags/list

        # https://stackoverflow.com/a/43786939/5560682
        # I've added -i to grep because I've noticed that not always returned http headers are lowercase
        # I've also changed method
        curl -v --silent -H "authorization: Basic ..." -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X HEAD https://docker-registry.phaseiilabs.com/v2/tapp/manifests/0.0.5 2>&1 | grep -i Docker-Content-Digest | awk '{print ($3)}'

        # https://docs.docker.com/registry/spec/api/#detail
        curl -v --silent -H "authorization: Basic ..." -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE https://docker-registry.phaseiilabs.com/v2/tapp/manifests/sha256:eb3e420f67b79a6e8f58c219ed92d31087b73e325f9a4b684db04094c2d54dfc

        # on registry machine
        docker exec -it docker-registry sh
        /bin/registry garbage-collect /etc/docker/registry/config.yml

        #or as a oneliner
        docker exec -it docker-registry /bin/registry garbage-collect /etc/docker/registry/config.yml

        # read more:
            https://quaintous.com/2017/05/19/docker-registry-housekeeping/
            https://linuxize.com/post/how-to-remove-docker-images-containers-volumes-and-networks/
                from: g(clean all unused docker images)

    * volumes:
    -------------------------------
        # problems in DO [table]:
            https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes
            [table] https://kubernetes.io/docs/concepts/storage/storage-classes/#provisioner
            # removing demaged namespace:
                https://medium.com/@clouddev.guru/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e
                g(How to fix — Kubernetes namespace deleting stuck in Terminating state)
            # volumen state pending forever:
                kubectl get PersistentVolumeClaim
                g(Ceph RBD PVC Pending forever #2922 rook)

        # Reasearch:
            # maybe create our own storage?
                # https://www.youtube.com/watch?v=hqE5c5pyfrk
                    On prem options:
                        - GlusterFS https://www.gluster.org/
                        - Ceph https://www.reddit.com/r/sysadmin/comments/9onemk/ceph_vs_glusterfs/
                    Backups:
                        - https://aws.amazon.com/glacier/ - VERY CHEAP RELIABLE
                    PostgresDB:
                        - https://aws.amazon.com/ebs/
                            DOWNSIDE OF EBS IS ATTACHING AND DETACHING FROM K8S NODE - FROM 40 SEC TO AN HOUR !!! https://youtu.be/hqE5c5pyfrk?t=1068
                            might be ok if you will keep deployment on the same nodes
                            more: https://docs.docker.com/ee/ucp/kubernetes/storage/configure-aws-storage/
                        - on prem - storageos
                    https://i.imgur.com/zHqhMGj.png
                    https://i.imgur.com/MbOPngz.png
                    Cloud Native Storage
                    CNCF [Cloud Native Computing Foundation]
                    https://storageos.com/
                    iscsi
                    persistant volume claim
                https://www.digitalocean.com/community/tutorials/object-storage-vs-block-storage-services#what-is-block-storage

            # try then glusterFS
                sudo yum install ansible
                    from: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node
                # naaa, not good
            # rook from:
                kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/common.yaml
                kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/operator.yaml
                kubectl apply -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/toolbox.yaml

                kubectl delete -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/common.yaml
                kubectl delete -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/operator.yaml
                kubectl delete -f https://raw.githubusercontent.com/rook/rook/v1.2.0/cluster/examples/kubernetes/ceph/toolbox.yaml

                    kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash
                        # from : https://rook.io/docs/rook/v1.2/ceph-toolbox.html
                    ceph status
                    ceph osd status
                    ceph df
                    rados df   from: https://rook.io/docs/rook/v1.2/ceph-toolbox.html#running-the-toolbox-in-kubernetes

    GlusterFS
    ---------------
        # installing gluster on bare machines:

            from: https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/#step-3-installing-glusterfs
            it didn't worked so I found this: here: https://lists.gluster.org/pipermail/gluster-users/2016-November/029044.html

                yum install -y centos-release-gluster
                yum install -y glusterfs-server

                    from: https://wiki.centos.org/SpecialInterestGroup/Storage#User_Documentation
            # then:
                service glusterd status
                service glusterd start
                systemctl enable glusterd.service
                service glusterd status

                gluster --version # -> glusterfs 7.2

            # firewall: from: https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/#step-4-configure-the-firewall
                run on each gluster nodes:
                    iptables -I INPUT -p all -s xxx.xxx.xxx.xxx -j ACCEPT
                    iptables -I INPUT -p all -s xxx.xxx.xxx.xxx -j ACCEPT
                    iptables -I INPUT -p all -s xxx.xxx.xxx.xxx -j ACCEPT

                    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 24007:24008 -j ACCEPT
                    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 49152:49156 -j ACCEPT
                        # for external connectivity: from: https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Setting%20Up%20Clients/#installing-on-red-hat-package-manager-rpm-distributions

                    iptables -S
                    iptables --list

cat <<EOF >> /etc/hosts
xxx.xxx.xxx.xxx glus1
xxx.xxx.xxx.xxx glus2
xxx.xxx.xxx.xxx glus3
EOF

            # GO THROUGH PROCESS OF CONNECTING EVERYTHING TOGETHER:
                https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/#step-5-configure-the-trusted-pool
                then run:
                    gluster peer status

                    gluster pool list
                    gluster volume info

                    gluster volume profile gv0 start
                    gluster volume profile gv0 info
                    gluster volume profile gv0 stop

                    gluster volume status gv0
                    gluster volume status gv0 mem

                        # from: https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Monitoring%20Workload/#start-profiling

            # try to run on all nodes:
                mkdir -p /var/glusterfs/gv0

            # create glusterfs server and volume
                gluster volume create gv0 disperse glus1:/var/glusterfs/gv0 glus2:/var/glusterfs/gv0 glus3:/var/glusterfs/gv0 force
                    # alternatively you can create replicated volume - not optimal
                        # gluster volume create gv0 replica 3 glus1:/var/glusterfs/gv0 glus2:/var/glusterfs/gv0 glus3:/var/glusterfs/gv0 force

                    # types of volumes:
                        https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Setting%20Up%20Volumes/#creating-dispersed-volumes
                        g(Setting up GlusterFS Volumes Creating Dispersed Volumes)

                # should see:
                    volume create: gv0: success: please start the volume to access data

                gluster volume start gv0
                gluster volume info

                # testing volume  from: https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/#step-7-testing-the-glusterfs-volume
                    mount -t glusterfs glus1:/gv0 /mnt
                    for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done
                    ls -lA /mnt/copy* | wc -l

                    # testing from other machine:
                        run on each gluster nodes:
                            iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 24007:24008 -j ACCEPT
                            iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 49152:49156 -j ACCEPT
                                from: https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Setting%20Up%20Clients/#installing-on-red-hat-package-manager-rpm-distributions

                        run on client (another) machine where you would mount glusterfs colume
                            from: http://mirror.centos.org/centos/7/storage/x86_64/
                                wget http://mirror.centos.org/centos/7/storage/x86_64/gluster-7/glusterfs-7.1-1.el7.x86_64.rpm
                                wget http://mirror.centos.org/centos/7/storage/x86_64/gluster-7/glusterfs-fuse-7.1-1.el7.x86_64.rpm
                                wget http://mirror.centos.org/centos/7/storage/x86_64/gluster-7/glusterfs-rdma-7.1-1.el7.x86_64.rpm


                            yum install glusterfs glusterfs-fuse attr -y
                            mount -t glusterfs glus1:/gv0 /mnt/
                            mount -t firewall-cmd glus1:/gv0 /mnt/
                                # in case of problems: vi /var/log/glusterfs/mnt.log


                # run on other nodes:
                    ls -la /var/glusterfs/gv0/copy-test-*

        # using from Kubernetes     from: https://kubernetes.io/docs/concepts/storage/volumes/#glusterfs
            https://github.com/kubernetes/examples/tree/master/volumes/glusterfs
    OpenEBS
    ---------------
        # installation/configuration (DigitalOcean):
            step 1:
                kubectl apply -f https://openebs.github.io/charts/openebs-operator-1.7.0.yaml
                    from: https://docs.openebs.io/docs/next/installation.html#installation-through-kubectl
            step 2:
                add volume to each cluster, don't mount those voulumes, let openebs to mount and format them:
                    https://i.imgur.com/TxM7sHs.png
            step 3 (verify):
                from: https://docs.openebs.io/docs/next/installation.html#verifying-openebs-installation
                    kubectl get pods -n openebs
                    kubectl get sc
                    kubectl get blockdevice -n openebs
                    kubectl get sp
            step 4:
                follow instructions in order:
                    https://github.com/stopsopa/kuber/tree/master/DO/openebsexampleyamlfiles
                WARNING: after executing:
                    helm install stable/nfs-server-provisioner --namespace=nfs --name=nfs-helm-install-name --set=persistence.enabled=true,persistence.storageClass=openebs-sc-statefulset,persistence.size=250Gi,storageClass.name=nfs-sc-for-cluster,storageClass.provisionerName=openebs.io/nfs
                        better wait until pod will rise (should take around 2 minutes - roughly):
                            kubectl get pod -n nfs
                        to debug run:
                            kubectl describe pod nfs-helm-install-name-nfs-server-provisioner-0 -n nfs


        # Get all the blockdevices attached in the cluster https://docs.openebs.io/docs/next/ugcstor.html#manual-mode
            kubectl get blockdevice -n openebs
            kubectl describe blockdevice blockdevice-3457b40abd4d04dbeaa4ae2fdaf3b4a2 -n openebs


kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt

Read more:
    https://www.digitalocean.com/docs/networking/dns/how-to/create-caa-records/

rook ceph glusterfs:
    https://medium.com/faun/what-is-rook-ceph-storage-integration-on-kubernetes-with-rook-9fa3f3487b90
    https://blog.kasten.io/posts/rook-ceph-csi-kubernetes-and-k10-an-all-in-one-stateful-experience/?utm_term=&utm_campaign=Dynamic+search&utm_source=adwords&utm_medium=ppc&hsa_acc=3144319558&hsa_cam=6485702571&hsa_grp=78501076235&hsa_ad=381272204052&hsa_src=g&hsa_tgt=dsa-19959388920&hsa_kw=&hsa_mt=b&hsa_net=adwords&hsa_ver=3&gclid=Cj0KCQiApaXxBRDNARIsAGFdaB_L9MszQWis8j1mFuYETjpI-yj_zRFmrdXIRqUCf1CZ1OircrJgzlkaArMREALw_wcB
    https://hub.docker.com/u/gluster
        from: https://github.com/gluster/gluster-containers/
    https://github.com/gluster/gluster-kubernetes
    http://mirror.centos.org/centos/7/storage/x86_64/gluster-7/
    https://docs.openshift.com/container-platform/3.9/install_config/storage_examples/gluster_example.html

    https://github.com/gluster/glusterdocs/issues/526












