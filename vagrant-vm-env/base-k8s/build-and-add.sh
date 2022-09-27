#!/bin/bash
sudo vagrant up
sudo vagrant package --base base-k8s --output base-k8s.box
sudo vagrant box add base-k8s.box --name base-k8s