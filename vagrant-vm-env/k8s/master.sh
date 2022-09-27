#! /bin/bash
MASTER_IP=192.168.31.88
NETWORK_SEGMENT=192.168.31
# 设置ip
sudo echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=`ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g' | grep $NETWORK_SEGMENT`\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet
# 初始化集群
kubeadm reset -f
kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-bind-port=6443  --kubernetes-version=v1.25.2 --pod-network-cidr=10.100.0.0/16 --service-cidr=10.200.0.0/16 --service-dns-domain=cluster.local --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --ignore-preflight-errors=swap
# 配置kubectl的config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:root /home/vagrant/.kube/config
# 导出join脚本
config_path="/vagrant/configs"
if [ -d $config_path ]; then
   sudo rm -f $config_path/*
else
   sudo mkdir -p /vagrant/configs
fi
sudo touch /vagrant/configs/join.sh
sudo chmod +x /vagrant/configs/join.sh       
sudo kubeadm token create --print-join-command > /vagrant/configs/join.sh
# 安装calico
kubectl apply -f /vagrant/calico.yaml

#sudo apt install nfs-kernel-server -y
#
#sudo mkdir -p /data/nfs/
#
#sudo chmod 777 /data/nfs/
#
#sudo sed -i "$ a /data/nfs/ *(rw,sync,no_subtree_check,no_root_squash)" /etc/exports
#
#sudo exportfs -ra
#
#sudo systemctl restart nfs-kernel-server