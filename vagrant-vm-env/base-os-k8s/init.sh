sudo apt update  
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add
sudo cat << EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
sudo apt update
sudo apt install -y kubelet kubeadm kubectl