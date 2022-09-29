#! /bin/bash
MASTER_IP=192.168.1.88
NETWORK_SEGMENT=192.1.1
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
# 安装nfs
apt install nfs-kernel-server -y
mkdir -p /data/nfs/
chmod 777 /data/nfs/
sed -i "$ a /data/nfs/ *(rw,sync,no_subtree_check,no_root_squash)" /etc/exports
exportfs -ra
systemctl restart nfs-kernel-server
# 安装storageClass
kubectl apply -f /vagrant/nfs
# 安装istio
tar zxvf /vagrant/istio/istio-1.15.1-linux-amd64.tar.gz -C /opt
mv /opt/istio-* /opt/istio
tar zxvf /vagrant/istio/istioctl-1.15.1-linux-amd64.tar.gz -C /usr/local/bin/
chmod +x /usr/local/bin/istioctl
export PATH=/opt/istio/bin:$PATH
ctr -n=k8s.io i pull docker.io/istio/proxyv2:1.15.1
ctr -n=k8s.io i pull docker.io/istio/pilot:1.15.1
istioctl install --set profile=default -y
# 安装helm
tar -zxvf /vagrant/helm-v3.10.0-linux-amd64.tar.gz
mv /vagrant/linux-amd64/helm /usr/local/bin/helm
rm -rf /vagrant/linux-amd64