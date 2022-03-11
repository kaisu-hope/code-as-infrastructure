#! /bin/bash
sudo /vagrant/configs/join.sh -v

sudo apt-get install nfs-common -y

sudo mkdir -p /data/nfs/

sudo mount -t nfs -o nolock -o tcp 10.2.10.15:/data/nfs/ /data/nfs/