CMDS=$1
NAMESPACES=${2:-kube-system}
for namespace in $NAMESPACES; do
	pods=$(kubectl get pods -n $namespace | grep -v NAME | awk '{print $1}')

	for pod in $pods; do
		containers=$(kubectl get pod $pod -n $namespace -o jsonpath='{.spec.containers[*].name}');
        	for container in $containers; do
			echo "Executing $CMDS in pod $pod inside container $container"
			kubectl exec -ti $pod -c $container -n $namespace -- $CMDS;
			echo "------------------ executed --------------------------"
			echo ""
		done
	done
done
