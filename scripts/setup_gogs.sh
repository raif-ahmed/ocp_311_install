#!/bin/bash
# Create CICD project
if (( $(oc get projects|grep cicd|wc -l) == 0 )); then
  oc new-project cicd
  oc label namespace cicd "name=cicd"
fi



if (( $(oc get dc -n cicd|grep gogs|wc -l) == 0 )); then
	# Call template to provision nexus objects
	oc new-app -f /home_ldap/btaljaard/ocp_311_install/resources/templates/gogs.yaml \
		-p APPS_DOMAIN=apps.npd.msa.libgbl.biz \
		-p NAMESPACE=cicd \
		-p GOGS_CPU_REQUESTS=1000m -p GOGS_CPU_LIMITS=2000m \
		-p GOGS_MEM_REQUESTS=1Gi -p GOGS_MEM_LIMITS=2Gi \
		-p GOGS_VOLUME_CAPACITY=40G \
		-p POSTGRES_CPU_REQUESTS=512m -p POSTGRES_CPU_LIMITS=1000m \
		-p POSTGRES_MEM_REQUESTS=512Mi -p POSTGRES_MEM_LIMITS=1Gi \
		-p POSTGRES_VOLUME_CAPACITY=10G \
		-n cicd
fi

# Wait for gogs to start before we configure it
while : ; do
  echo "Checking if Gogs is Ready..."
  oc get pod -n cicd|grep gogs|grep -v deploy|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done

echo "************************"
echo "Gogs setup complete"
echo "************************"

exit 0



