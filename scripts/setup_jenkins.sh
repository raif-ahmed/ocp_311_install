#!/bin/bash

# Script to setup Jenkins

# Create CICD project
if (( $(oc get projects|grep cicd|wc -l) == 0 )); then
  oc new-project cicd
  oc label namespace cicd "name=cicd"
fi

# Check if jenkins is deployed
if (( $(oc get dc -n cicd|grep jenkins|wc -l) == 0 )); then
  # Jenkins is not deployed yet
  oc new-app -f /home_ldap/btaljaard/ocp_311_install/resources/templates/jenkins.yaml \
  -p MEM_REQUESTS=1Gi -p MEM_LIMITS=2Gi -p VOLUME_CAPACITY=4G \
  -p CPU_REQUESTS=1000m -p CPU_LIMITS=1500m -p REPO=https://github.com/bentaljaard/ocp_311_install.git -n cicd
  # oc delete route jenkins
  # oc create route edge --service=jenkins
fi

# Check if Jenkins is up
while : ; do
  echo "Checking if Jenkins is Ready..."
  oc get pod -n cicd|grep -v deploy|grep -v build|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done
