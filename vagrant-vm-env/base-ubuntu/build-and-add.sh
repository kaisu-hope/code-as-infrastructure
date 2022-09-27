#!/bin/bash
sudo vagrant up
sudo vagrant package --base base-ubuntu --output ubuntu-base.box
sudo vagrant box add ubuntu-base.box --name ubuntu-base