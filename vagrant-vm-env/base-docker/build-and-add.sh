#!/bin/bash
sudo vagrant up
sudo vagrant package --base ubuntu-base --output ubuntu-base.box
sudo vagrant box add ubuntu-base.box --name base-docker