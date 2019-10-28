#!/bin/bash

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# echo "Removing old docker if any"
# yum remove -y docker docker-ce docker-ce-cli

echo "Installing bare minimum soft"
yum install -y firewalld httpd-tools \
    && systemctl start firewalld \
    && systemctl enable firewalld

# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker vvv
echo "Installing docker";
yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# yum list docker-ce     --showduplicates | sort -r  <---- check the CE  versions available
# yum list docker-ce-cli --showduplicates | sort -r  <---- check the CLI versions available
# yum install -y docker-ce docker-ce-cli containerd.io
yum install -y docker-ce-18.09.9 docker-ce-cli-18.09.9 containerd.io
# proper version of docker for this kuber version https://kubernetes.io/docs/setup/release/notes/#unchanged

systemctl start docker
systemctl enable docker
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker ^^^

# https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/#does-the-service-work-by-dns
# install nslookup https://unix.stackexchange.com/a/164212
yum install -y bind-utils

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl vvv
echo "Installing kubernetes"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

# Make sure that the br_netfilter module is loaded before this step. This can be done by running lsmod | grep br_netfilter. To load it explicitly call modprobe br_netfilter
lsmod | grep br_netfilter && modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl ^^^

echo "Deploying kubernetes"
# if kubeadm is running and we re-run this install.sh then here it will throw fatal error
# do kubeadm reset - to use this command again
res=$(kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU 2>&1) # add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP

echo $res;

ports=$(echo $res | egrep "firewalld is active, please ensure ports \[[0-9 ]+\] are open " | egrep -oh "(\[[0-9 ]+\])" | egrep -oh "[0-9 ]+")
portsarray=($ports)

# echo "..........";
# echo ${portsarray}

if (( ${#portsarray[@]} )); then
    for i in "${portsarray[@]}"
    do
    echo "Opening port $i"
    firewall-cmd --zone=public --add-port=$i/tcp --permanent

    done

    sudo firewall-cmd --reload
fi;



# echo "Applying CNI"
# kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/canal.yaml


# some clue:
  # https://github.com/ubuntu/microk8s/issues/536#issuecomment-509663386
