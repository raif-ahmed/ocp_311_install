#!/bin/bash
# Create CICD project
if (( $(oc get projects|grep cicd|wc -l) == 0 )); then
  oc new-project cicd
  oc label namespace cicd "name=cicd"
fi
# Call template to provision nexus objects


oc new-app -f /home_ldap/btaljaard/ocp_311_install/resources/templates/sonarqube.yaml \
  -n cicd \
	-p SONARQUBE_CPU_LIMITS=2000m -p DB_CPU_LIMITS=1000m \
	-p SONARQUBE_MEM_REQUESTS=3Gi -p SONARQUBE_MEM_LIMITS=3Gi

while : ; do
  echo "Checking if Sonarqube is Ready..."
  oc get pod -n cicd|grep sonarqube|grep -v deploy|grep -v postgresql|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done

echo "************************"
echo "SonarQube setup complete"
echo "************************"

exit 0
