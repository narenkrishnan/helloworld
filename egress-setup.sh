#!/bin/bash
echo "egress setup to ensure only certain hostnames are allowed"
#
CLUSTER_NAME="cluster1"
#
# verify context 
# kubectl config current-context
# set context
ibmcloud ks cluster config --cluster $CLUSTER_NAME
# verify context
kubectl config current-context

#
# Create egress Service entry
#
# Step 1. Ensure REGISTER_ONLY 
#check if the outboundtraffic policy has been installed
kubectl get configmap istio -n istio-system -o yaml | grep -o "mode: REGISTRY_ONLY"

# do not do the istoictl as the addon will be enabled
#istioctl install --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY --set profile=demo 
#------
# requires 3 worker nodes
ibmcloud ks cluster addon enable debug-tool --cluster cluster1
ibmcloud ks cluster addon enable istio --cluster cluster1
#
#list the addon
ibmcloud ks cluster addon ls --cluster $CLUSTER

#
kubectl -n istio-system get configmap istio -o jsonpath="{.data.mesh}" 

#
kubectl label namespace default ns-naren  istio-injection=enabled --overwrite

# Now make sure they are righ
kubectl get namespace -L istio-injection




