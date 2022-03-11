#!/bin/bash
version="artifactory-oss-7.35.2"
path="jfrog-artifactory-oss-7.35.2-linux.tar.gz"
sudo apt install -y net-tools
sudo cp /vagrant/$path ./
sudo mkdir jfrog
sudo mv $path jfrog
cd jfrog
sudo tar -zxvf $path
sudo mv $version artifactory
export JFROG_HOME=${PWD} 
sudo $JFROG_HOME/artifactory/app/bin/installService.sh
sudo systemctl start artifactory.service