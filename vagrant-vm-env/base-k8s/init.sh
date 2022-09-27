# 内核配置
echo 'ip_vs' | sudo tee -a /etc/modules-load.d/modules.conf
echo 'br_netfilter' | sudo tee -a /etc/modules-load.d/modules.conf
modprobe ip_vs
modprobe br_netfilter
rm -rf /etc/sysctl.conf
cp /vagrant/sysctl.conf /etc/sysctl.conf
sysctl -p
# 安装containerd
tar xf /vagrant/containerd-1.6.8-linux-amd64.tar.gz
cp -r bin/* /usr/local/bin/
rm -rf bin
# 注册containerd服务
cp /vagrant/containerd.service /etc/systemd/system/
systemctl daemon-reload
mkdir /etc/containerd
# 配置镜像加速器
containerd config default > /etc/containerd/config.toml
sed -i 's|config_path = ""|config_path = "/etc/containerd/certs.d"|g' /etc/containerd/config.toml
mkdir -pv /etc/containerd/certs.d
cp -r /vagrant/docker.io /etc/containerd/certs.d
# 修改镜像地址
sed -i 's|k8s.gcr.io/pause|registry.cn-hangzhou.aliyuncs.com/google_containers/pause|g' /etc/containerd/config.toml
systemctl enable containerd --now
# 安装runc
cp /vagrant/runc.amd64 /usr/local/bin/runc
chmod +x /usr/local/bin/runc
sed -i 's|SystemdCgroup = false|SystemdCgroup = true|g' /etc/containerd/config.toml
# 安装nerdctl
tar zxvf /vagrant/nerdctl-0.23.0-linux-amd64.tar.gz -C /usr/local/bin/
rm -rf /usr/local/bin/*.sh
# 安装crictl
tar zxvf /vagrant/crictl-v1.25.0-linux-amd64.tar.gz -C /usr/local/bin
cp /vagrant/crictl.yaml /etc/
# 配置软件仓库
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.ustc.edu.cn//kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt install -y kubeadm=1.25.2-00 kubectl=1.25.2-00 kubelet=1.25.2-00
# 安装cni 网络插件
mkdir -p /opt/cni/bin
tar xf /vagrant/cni-plugins-linux-amd64-v1.1.1.tgz -C /opt/cni/bin/