#!/bin/bash

swapoff -a

# echo "Removing old docker if any"
# yum remove -y docker docker-ce docker-ce-cli

echo "Installing bare minimum soft"
yum install -y firewalld httpd-tools \
    && systemctl start firewalld \
    && systemctl enable firewalld

echo "Installing docker";
yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# yum list docker-ce     --showduplicates | sort -r  <---- check the CE  versions available
# yum list docker-ce-cli --showduplicates | sort -r  <---- check the CLI versions available
# yum install -y docker-ce docker-ce-cli containerd.io  <---- for the latest versions
yum install -y docker-ce-18.09.9 docker-ce-cli-18.09.9 containerd.io

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

# Now you have to copy the `join` command from the master  node and paste it in all the nodes to join with the cluster
# If you dont remember your token you can generate a new one:
# kubeadm token create --print-join-command    <--- this will create and print a unique token valid for 24h (--ttl to change it) 
# kubeadm token list    <--- will show a list of all active tokens