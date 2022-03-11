#!/bin/bash
vagrant up
vagrant package --base base-k8s --output base-k8s.box
vagrant box add base-k8s.box --name base-k8s