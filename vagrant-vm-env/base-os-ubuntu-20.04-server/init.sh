# 关闭交换空间
sudo swapoff -a
# 关闭防火墙
sudo ufw disable
# 更改时区
sudo timedatectl set-timezone Asia/Shanghai
# 替换为阿里源
sudo cat <<EOF > /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF

# 安装docker
sudo apt update
sudo apt install -y docker.io

# 时间同步
sudo apt-get install -y ntpdate
sudo ntpdate cn.pool.ntp.org
sudo hwclock --systohc
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
# 配置docker源代码
if [ ! -d /etc/docker ];then
    mkdir /etc/docker
fi
cat <<EOF > /etc/docker/daemon.json 
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "registry-mirrors": [
    "https://lr5l2mfx.mirror.aliyuncs.com",
    "https://dockerhub.azk8s.cn"
  ],
  "storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
systemctl restart docker