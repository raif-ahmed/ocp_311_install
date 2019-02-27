#!/bin/bash

# Script to fix host configuration :-(


# Add proxy config
echo "Adding proxy configuration"
echo "export https_proxy=http://172.23.29.156:3128" > /etc/profile.d/proxy.sh
echo "export http_proxy=http://172.23.29.156:3128" >> /etc/profile.d/proxy.sh
chmod +x /etc/profile.d/proxy.sh
echo "[DONE]"

# Enable RHN repos
echo "Enable RHN repos"
subscription-manager repos --enable rhel-7-server-ose-3.11-rpms
subscription-manager repos --enable rhel-7-server-ansible-2.6-rpms
echo "[DONE]"

# Set FQ hostname
# echo "Set hostname"
# HOSTNAME_SUFFIX=-svc.cpn.lgi.inf.libgbl.biz
# CURRENT_HOSTNAME=$(hostname)

# if [[ $CURRENT_HOSTNAME == *"$HOSTNAME_SUFFIX"* ]]; then
#   	echo "Hostname set correctly"
# else
# 	hostnamectl set-hostname $CURRENT_HOSTNAME$HOSTNAME_SUFFIX
# fi
# echo "[DONE]"

# Fix log and var disk sizes
echo "Fix log and var disk sizes"
lvresize --size 10G /dev/vgroot/lv_log -r
lvresize --size 8G /dev/vgroot/lv_var -r

# Fix apps disk