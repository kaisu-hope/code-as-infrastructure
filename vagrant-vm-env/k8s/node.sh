#! /bin/bash
sudo sed -i "$ a Environment=\"KUBELET_EXTRA_ARGS=--node-ip=`ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g' | grep 192`\"" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo /vagrant/configs/join.sh -v


sudo apt-get install nfs-common -y

sudo mkdir -p /data/nfs/

sudo mount -t nfs -o nolock -o tcp 192.168.1.110:/data/nfs/ /data/nfs/