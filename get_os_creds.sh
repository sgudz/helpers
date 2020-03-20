kubectl exec -ti $(kubectl get pods -n openstack | grep 'keystone-client' | awk '{print $1}') -n openstack -- env | grep -E "OS_USERNAME|OS_PASSWORD|OS_.*_DOMAIN"
