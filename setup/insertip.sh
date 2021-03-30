#!/bin/bash
# $1 image value you want to replace
# $2 is the file you want to edit
IP_ADR=$(curl ifconfig.me)
sed -i "s/IPADR/$IP_ADR/" ./jenkins-katas/setup/casc-config/jenkins.yaml