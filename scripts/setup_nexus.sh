#!/bin/bash
# Create CICD project
if (( $(oc get projects|grep cicd|wc -l) == 0 )); then
  oc new-project cicd
  oc label namespace cicd "name=cicd"
fi



if (( $(oc get dc -n cicd|grep nexus|wc -l) == 0 )); then
	# Call template to provision nexus objects
	oc new-app -f /home_ldap/btaljaard/ocp_311_install/resources/templates/nexus3.yaml \
		-p CPU_LIMITS=1000m -p MEM_REQUESTS=1Gi \
		-p MEM_LIMITS=2Gi -p VOLUME_CAPACITY=2G -n cicd
fi

# Wait for nexus to start before we configure it
while : ; do
  echo "Checking if Nexus is Ready..."
  oc get pod -n cicd|grep nexus|grep -v deploy|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done

#Make sure that route has started routing traffic, so sleep a little longer
sleep 5

# Run configuration script to configure redhat maven repos, create release repo, configure proxy for maven, setup docker registry repo
curl -o config_nexus_tmp.sh -s https://raw.githubusercontent.com/bentaljaard/ocp_311_install/master/scripts/config_nexus3.sh
chmod +x config_nexus_tmp.sh
./config_nexus_tmp.sh admin admin123 https://$(oc get route nexus3 --template='{{ .spec.host }}' -n cicd)
rm config_nexus_tmp.sh

echo "************************"
echo "Nexus setup complete"
echo "************************"

exit 0



