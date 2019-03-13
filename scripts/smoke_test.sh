#!/bin/bash

# Run smoke test on Openshift to verify persistence is working

oc new-project smoke-test
oc new-app nodejs-mongo-persistent -n smoke-test
oc delete route nodejs-mongo-persistent
oc create route edge --service=nodejs-mongo-persistent

# Wait for both pods to be running (ignore build and deploy pods)
while (( $(oc get pod -n smoke-test|grep -e mongodb -e nodejs-mongo-persistent |grep -v build|grep -v deploy|grep 1/1|wc -l) != 2 )); do 
	echo "Not running yet, going to sleep..."
	sleep 10
done 

# Wait short while to ensure route is working
sleep 5

# Run integration test
curl -k https://$(oc -n smoke-test get route nodejs-mongo-persistent --template='{{ .spec.host }}')|grep "Welcome to your Node.js application on OpenShift"

# Check exit code and fail if we did not get the expected result
if (( $? != 0 )); then
	# Cleanup
	oc delete project smoke-test
	# Throw error code
	exit 1
fi

# Cleanup
oc delete project smoke-test
