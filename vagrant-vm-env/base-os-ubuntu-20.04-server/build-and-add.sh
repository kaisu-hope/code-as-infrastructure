#!/bin/bash
vagrant up
vagrant package --base ubuntu-base --output ubuntu-base.box
vagrant box add ubuntu-base.box --name base-docker