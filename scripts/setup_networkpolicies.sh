#!/bin/bash

# Prepares a multitenant cluster for running the networkpolicy plugin by
#
#   1) creating NetworkPolicy objects (and Namespace labels) that
#      implement the same isolation/sharing as had been configured in
#      the multitenant cluster via "oc adm pod-network".


set -o errexit
set -o nounset
set -o pipefail

plugin="$(oc get clusternetwork default --template='{{.pluginName}}')"
if [[ "${plugin}" != "redhat/openshift-ovs-networkpolicy" ]]; then
   echo "Script must be run while running networkpolicy plugin"
   exit 1
fi 

function default-deny() {
    oc apply --namespace "$1" -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny
spec:
  podSelector:
EOF
}

function allow-from-self() {
    oc apply --namespace "$1" -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-from-self
spec:
  podSelector:
  ingress:
  - from:
    - podSelector: {}
EOF
}

function allow-from-other() {
    oc apply --namespace "$1" -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: $2
spec:
  podSelector:
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: "$3"
EOF
}


# Create policies and labels
for netns in $(oc get netnamespaces --output=jsonpath='{range .items[*]}{.netname}:{.netid} {end}'); do
    name="${netns%:*}"
    id="${netns#*:}"
    echo ""
    echo "NAMESPACE: ${name}"

    if [[ "${id}" == "0" ]]; then
    	echo "Namespace is global: adding label name=default"
    	oc label namespace "${name}" "name=default" --overwrite >/dev/null

    else
    	# All other Namespaces get isolated, but allow traffic from themselves and global
    	# namespaces. We define these as separate policies so the allow-from-global-namespaces
    	# policy can be deleted if it is not needed.

    	default-deny "${name}"
    	allow-from-self "${name}"
    	allow-from-other "${name}" allow-from-global-namespaces default
    fi
done

