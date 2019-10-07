#!/bin/bash

swapoff -a

# echo "Removing old docker if any";
# yum remove -y docker \
#     docker-client \
#     docker-client-latest \
#     docker-common \
#     docker-latest \
#     docker-latest-logrotate \
#     docker-logrotate \
#     docker-engine

echo "Installing docker";
yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

systemctl start docker
systemctl enable docker

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

lsmod | grep br_netfilter && modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "Deploying kubernetes (with Canal CNI)"
# if kubeadm is running and we re-run this install.sh then here it will throw fatal error
# do kubeadm reset - to use this command again
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU # add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP
export KUBECONFIG=/etc/kubernetes/admin.conf

echo "Applying CNI"
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/canal.yaml
