# 关闭交换空间
sudo swapoff -a
# 关闭防火墙
sudo ufw disable
# 更改时区
sudo timedatectl set-timezone Asia/Shanghai
# 更换源
sudo rm -rf /etc/apt/sources.list
sudo cp /vagrant/sources.list /etc/apt/sources.list
# 更新仓库
sudo apt update
# 时间同步
sudo apt-get install -y ntpdate
sudo ntpdate cn.pool.ntp.org
sudo hwclock --systohc
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
# 设置root密码
sudo sh /vagrant/changeRootPasswd.sh
# 设置root ssh 远程
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#LoginGraceTime 2m/LoginGraceTime 2m/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#StrictModes yes/StrictModes yes/g' /etc/ssh/sshd_config
