#!/bin/bash

# Set DEV node labels
oc label --overwrite node lg-l-n-msa00007 DEV=true
oc label --overwrite node lg-l-n-msa00008 DEV=true
oc label --overwrite node lg-l-n-msa00009 DEV=true

# Set SIT node labels
oc label --overwrite node lg-l-n-msa00007 SIT=true
oc label --overwrite node lg-l-n-msa00008 SIT=true
oc label --overwrite node lg-l-n-msa00009 SIT=true

# Set UAT node labels
oc label --overwrite node lg-l-n-msa00010 UAT=true
oc label --overwrite node lg-l-n-msa00011 UAT=true
oc label --overwrite node lg-l-n-msa00012 UAT=true

# Set ORT node labels
oc label --overwrite node lg-l-n-msa00010 ORT=true
oc label --overwrite node lg-l-n-msa00011 ORT=true
oc label --overwrite node lg-l-n-msa00012 ORT=true