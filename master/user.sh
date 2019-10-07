#!/bin/bash

echo "Creating kuber group and user";
groupadd kuber
useradd -g kuber -G root -s /bin/bash -d /home/kuber kuber
mkdir -p /home/kuber
cp -r /root/.ssh /home/kuber/.ssh
chown -R kuber:kuber /home/kuber
echo "kuber ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# create .kube/config
echo "Copying kubernetes config file to 'kuber' home dir";
mkdir -p ~kuber/.kube
cp -i /etc/kubernetes/admin.conf ~kuber/.kube/config
chown kuber:kuber ~kuber/.kube/config