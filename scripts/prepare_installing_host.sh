#!/bin/bash

# This script needs to be run as root
# Setup installation host (this can be the first node or a bastion host)

# Configure proxy
export http_proxy=http://172.23.29.156:3128
export https_proxy=http://172.23.29.156:3128


# Enable required repositories
subscription-manager repos --enable rhel-7-server-ose-3.11-rpms
subscription-manager repos --enable rhel-7-server-ansible-2.6-rpms


# Install openshift ansible + playbooks
yum install openshift-ansible -y
yum install atomic-openshift-clients -y

