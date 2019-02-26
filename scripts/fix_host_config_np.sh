#!/bin/bash

# Script to fix host configuration :-(


# Add network routes (might need to do this manually)


# Add proxy config
echo "export https_proxy=http://172.23.29.156:3128" > /etc/profile.d/proxy.sh
echo "export http_proxy=http://172.23.29.156:3128" >> /etc/profile.d/proxy.sh
chmod +x /etc/profile.d/proxy.sh

# Enable RHN repos
subscription-manager repos --enable rhel-7-server-ose-3.11-rpms
subscription-manager repos --enable rhel-7-server-ansible-2.6-rpms

# Set FQ hostname
HOSTNAME_SUFFIX=-svc.cpn.lgi.inf.libgbl.biz
CURRENT_HOSTNAME=$(hostname)

if [[ $CURRENT_HOSTNAME == *"$HOSTNAME_SUFFIX"* ]]; then
  	echo "Hostname set correctly"
else
	hostnamectl set-hostname $CURRENT_HOSTNAME$HOSTNAME_SUFFIX
fi


# Fix log and var disk sizes
lvresize --size 10G /dev/vgroot/lv_log -r
lvresize --size 8G /dev/vgroot/lv_var -r

# Fix apps disk