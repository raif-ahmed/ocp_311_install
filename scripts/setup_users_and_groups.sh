#!/bin/sh

# Setup users and groups

# Create cluster admin group
if (( $(oc get groups ocp-platform 2>&1 |grep NotFound|wc -l) == 1 )); then
	oc adm groups new ocp-platform
	oc adm policy add-cluster-role-to-group cluster-admin ocp-platform
	oc adm groups add-users ocp-platform ocpadmin
fi


# # Create developer group
# if (( $(oc get groups ocp-developer 2>&1 |grep NotFound|wc -l) == 1 )); then
# 	oc adm groups new beta
# 	oc policy add-role-to-group edit beta -n beta-project
# 	oc adm groups add-users beta brian betty
# fi


# # Create groups
# if (( $(oc get groups alpha 2>&1 |grep NotFound|wc -l) == 1 )); then
# 	oc adm groups new alpha
# 	oc policy add-role-to-group edit alpha -n alpha-project
# 	oc adm groups add-users alpha amy andrew
# fi

# if (( $(oc get groups beta 2>&1 |grep NotFound|wc -l) == 1 )); then
# 	oc adm groups new beta
# 	oc policy add-role-to-group edit beta -n beta-project
# 	oc adm groups add-users beta brian betty
# fi

# # Create common group 
# if (( $(oc get groups common 2>&1 |grep NotFound|wc -l) == 1 )); then
# 	oc adm groups new common
# fi

# # Create cluster admin group
# if (( $(oc get groups ocp-platform 2>&1 |grep NotFound|wc -l) == 1 )); then
# 	oc adm groups new ocp-platform
# 	oc adm policy add-cluster-role-to-group cluster-admin ocp-platform
# 	# oc adm groups add-users ocp-platform bob
# fi

# Remove ability to create projects for all users
if (( $(oc describe clusterrolebinding.rbac -n default self-provisioner |grep system:authenticated|wc -l) != 0 )); then
	oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated
fi

if (( $(oc describe clusterrolebinding.rbac -n default self-provisioner |grep system:authenticated:oauth|wc -l) != 0 )); then
	oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
fi


# Add ability for users in the common group to create their own projects
# oc adm policy add-cluster-role-to-group self-provisioner common

