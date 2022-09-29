#! /bin/bash
# 设置ip
NETWORK_SEGMENT=192.168.1
MASTER_IP=192.168.2.88
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=`ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g' | grep $NETWORK_SEGMENT`\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
# 加入集群
/vagrant/configs/join.sh -v
# nfs配置
apt-get install nfs-common -y
mkdir -p /data/nfs/
mount -t nfs -o nolock -o tcp $MASTER_IP:/data/nfs/ /data/nfs/
ctr -n=k8s.io i pull docker.io/istio/proxyv2:1.15.1
ctr -n=k8s.io i pull docker.io/istio/pilot:1.15.1