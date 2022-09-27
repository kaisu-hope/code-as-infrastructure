#! /bin/bash
# 设置ip
NETWORK_SEGMENT=192.168.31
sudo echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=`ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g' | grep $NETWORK_SEGMENT`\"" | sudo tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet
# 加入集群
sudo /vagrant/configs/join.sh -v