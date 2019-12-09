
apt-get update
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update && apt-get install -y kubelet kubeadm kubectl docker.io

# run:
#    kubeadm join 178.xxx.xx.xxx:6443 --token tokent.tokentokentokenn     --discovery-token-ca-cert-hash sha256:53fcc402ad19a3b786e38975849384937b897897897b78970e24e2c23e340b88

# now run script to add user


apt-get install iptables-persistent

# /etc/iptables/rules.v4

