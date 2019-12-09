#!/bin/bash

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# echo "Removing old docker if any"
# yum remove -y docker docker-ce docker-ce-cli

#echo "Installing bare minimum soft"
#yum install -y firewalld httpd-tools \
#    && systemctl start firewalld \
#    && systemctl enable firewalld

yum install -y httpd-tools iptables-services

systemctl start iptables
systemctl enable iptables

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

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#worker-node-s
# https://github.com/coreos/coreos-kubernetes/blob/master/Documentation/kubernetes-networking.md#port-allocation
firewall-cmd --zone=public --add-port=10250/tcp --permanent
firewall-cmd --zone=public --add-port=4149/tcp --permanent
firewall-cmd --zone=public --add-port=10255/tcp --permanent
firewall-cmd --zone=public --add-port=2379/tcp --permanent
firewall-cmd --zone=public --add-port=2380/tcp --permanent
firewall-cmd --zone=public --add-port=10256/tcp --permanent
firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --zone=public --add-port=9099/tcp --permanent
firewall-cmd --zone=public --add-port=30000-32767/tcp --permanent
firewall-cmd --reload


# iptables vvv
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
update-alternatives --set iptables /usr/sbin/iptables-legacy

# example
#  [root@kuber-node3 test]# iptables -I INPUT -p tcp -m tcp --dport 10250 -j ACCEPT
#  [root@kuber-node3 test]#
#  [root@kuber-node3 test]# service iptables save
#  iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
#  [root@kuber-node3 test]# iptables -L > start10250open.log
#  [root@kuber-node3 test]# diff start.log start10250open.log
#  2a3
#  > ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:10250
#  [root@kuber-node3 test]#


#[root@kuber-node3 test]# iptables -I INPUT -p tcp --match multiport --dports 30000:32767 -j ACCEPT
#[root@kuber-node3 test]# iptables -L > startrangeopen.log
#[root@kuber-node3 test]# diff start.log startrangeopen.log
#2a3,4
#> ACCEPT     tcp  --  anywhere             anywhere             multiport dports ndmps:filenet-powsrm
#> ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:10250
#[root@kuber-node3 test]#

# https://linuxize.com/post/how-to-install-iptables-on-centos-7/
#systemctl stop firewalld
#systemctl disable firewalld
#systemctl status firewalld


systemctl stop iptables
systemctl start iptables
systemctl enable iptables
systemctl status iptables
iptables -A INPUT -p tcp -m tcp --dport 10250 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10255 -j ACCEPT
iptables -A INPUT -p tcp -m multiport  --dport 10250,10255 -j ACCEPT

iptables -A INPUT -p tcp --dport 30000:32767 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 4149 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 2379 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 2380 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 6443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 9099 -j ACCEPT
service iptables save




# iptables ^^^

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes  g(Joining your nodes)
# Now you have to copy the `join` command from the master  node and paste it in all the nodes to join with the cluster
# If you dont remember your token you can generate a new one:
# kubeadm token create --print-join-command    <--- this will create and print a unique token valid for 24h (--ttl to change it)
# will generare
#    kubeadm join 178.xxx.xx.xxx:6443 --token tokent.tokentokentokenn     --discovery-token-ca-cert-hash sha256:53fcc402ad19a3b786e38975849384937b897897897b78970e24e2c23e340b88
# kubeadm token list    <--- will show a list of all active tokens

# configuring kubectl https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#optional-controlling-your-cluster-from-machines-other-than-the-control-plane-node
# g((Optional) Controlling your cluster from machines other than the control-plane node)
# scp root@<control-plane-host>:/etc/kubernetes/admin.conf .
# kubectl --kubeconfig ./admin.conf get nodes

# delete, shutdown node, draing node https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down

# upgrades: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#lifecycle
