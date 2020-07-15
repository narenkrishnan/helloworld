
ibmcloud ks cluster get --cluster cluster1
ibmcloud ks cluster config --cluster cluster1
set CLUSTER="cluster1"
kubectl config set-context $(kubectl config current-context) --namespace default

# do not do the istoictl as the addon will be enabled
#istioctl install --set meshConfig.outboundTrafficPolicy.mode=ALLOW_ANY --set profile=demo 
#------
# requires 3 worker nodes
ibmcloud ks cluster addon enable debug-tool --cluster cluster1
ibmcloud ks cluster addon enable istio --cluster cluster1
#
#list the addon
ibmcloud ks cluster addon ls --cluster $CLUSTER
#
kubectl label namespace default ns-naren  istio-injection=enabled --overwrite

# Now make sure they are righ
kubectl get namespace -L istio-injection


#check if the outboundtraffic policy has been installed
kubectl get configmap istio -n istio-system -o yaml | grep -o "mode: REGISTRY_ONLY"
#
kubectl -n istio-system get configmap istio -o jsonpath="{.data.mesh}" 

# you can also get the configmap in yaml format

kubectl -n istio-system get configmap istio -o yaml
# add default namespace
kubectl label namespace default istio-injection=enabled

#install bookinfo application
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
#
f

#
export SOURCE_POD=$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})

#

kubectl get configmap istio -n istio-system -o yaml | sed 's/mode: ALLOW_ANY/mode: REGISTRY_ONLY/g' | kubectl replace -n istio-system -f -




kubectl exec -it $SOURCE_POD -c sleep -- sh

curl -I https://www.google.com 
curl -I -L https://www.ibm.com

kubectl logs $SOURCE_POD -c istio-proxy

------------
# how to setup namespace
kubectl get namespaces
naren@naren-S400CA:~$ kubectl get namespaces
NAME              STATUS   AGE
default           Active   22h
ibm-cert-store    Active   22h
ibm-operators     Active   22h
ibm-system        Active   22h
istio-system      Active   21h
kube-node-lease   Active   22h
kube-public       Active   22h
kube-system       Active   22h


# get more info on namespaces
kubectl describe namespaces istio-system

kubectl logs $SOURCE_POD --all-containers=true




# get health of cluster
ibmcloud ks cluster get --cluster cluster1
# set cluster context
ibmcloud ks cluster config --cluster cluster1

# get services
kubectl get svc -n istio-system
kubectl get svc istio-ingressgateway -n istio-system


# try  to install niginx in a different name space and then check if the egress serviceentry 
# applies to that also or not
naren@naren-S400CA:~/cloud$ kubectl get pods -n default
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-78db589446-v9flb       2/2     Running   0          23h
productpage-v1-7f4cc988c6-wrmxj   2/2     Running   0          23h
ratings-v1-756b788d54-dhcrh       2/2     Running   0          23h
reviews-v1-849fcdfd8b-zrjlx       2/2     Running   0          23h
reviews-v2-5b6fb6c4fb-f5pc8       2/2     Running   0          23h
reviews-v3-7d94d58566-8ghdm       2/2     Running   0          23h
sleep-f8cbf5b76-r4hp2             2/2     Running   0          22h

kubectl apply -f nginx.yaml --namespace ns-naren
#Nyw try to connect to the pod
# the service entry does not seem to affect 
# Now let us apply the 

kubectl delete serviceentry abr -n ns-naren
 kubectl delete serviceentry abr -n default





----
# How to set service entry in one name space and see if it works on other name space



