#!/bin/bash

echo "Creating kuber group and user";
groupadd kuber
useradd -g kuber -G root -s /bin/bash -d /home/kuber kuber
mkdir -p /home/kuber
cp -r /root/.ssh /home/kuber/.ssh
chown -R kuber:kuber /home/kuber
echo "kuber ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "Copying kubernetes config file to 'kuber' home dir";
su kuber -c 'mkdir -p $HOME/.kube'
su kuber -c 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config'
su kuber -c 'sudo chown $(id -u):$(id -g) $HOME/.kube/config'

# echo "Applying CNI"
su kuber -c 'kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/canal.yaml'

# Joining example
# kubeadm join 167.99.205.1:6443 --token ctyxog.rht54wdea1cd654f \
#     --discovery-token-ca-cert-hash sha256:d6f6e92e374eee0effb677e401ac83cfdcef272035b4c31a89285f7644b398bd