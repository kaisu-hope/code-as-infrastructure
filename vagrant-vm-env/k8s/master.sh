#! /bin/bash

MASTER_IP="10.2.10.15"
POD_CIDR="172.172.0.0/16"

sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --image-repository registry.aliyuncs.com/google_containers --ignore-preflight-errors Swap

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:root /home/vagrant/.kube/config

config_path="/vagrant/configs"

if [ -d $config_path ]; then
   sudo rm -f $config_path/*
else
   sudo mkdir -p /vagrant/configs
fi

sudo touch /vagrant/configs/join.sh
sudo chmod +x /vagrant/configs/join.sh       

sudo kubeadm token create --print-join-command > /vagrant/configs/join.sh

sudo curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml

sudo apt install nfs-kernel-server -y

sudo mkdir -p /data/nfs/

sudo chmod 777 /data/nfs/

sudo sed -i "$ a /data/nfs/ *(rw,sync,no_subtree_check,no_root_squash)" /etc/exports

sudo exportfs -ra

sudo systemctl restart nfs-kernel-server