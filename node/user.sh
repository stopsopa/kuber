#!/bin/bash

echo "Creating kuber group and user";
groupadd kuber
useradd -g kuber -G root -s /bin/bash -d /home/kuber kuber
mkdir -p /home/kuber
cp -r /root/.ssh /home/kuber/.ssh
chown -R kuber:kuber /home/kuber
echo "kuber ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

