NAMESPACES=${1:-kube-system}
hours=24
minutes=60
seconds=60

for namespace in $NAMESPACES; do
  pods=$(kubectl get pods -o=name -n $namespace);
  for pod in $pods; do
    initialized=$(kubectl get $pod -n $namespace -o jsonpath='{.status.conditions[0].lastTransitionTime}')
    ready=$(kubectl get $pod -n $namespace -o jsonpath='{.status.conditions[1].lastTransitionTime}')
    init_h=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f1 | sed 's/^0*//')
    init_m=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f2 | sed 's/^0*//')
    init_s=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f3 | sed 's/^0*//')

    ready_h=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f1 | sed 's/^0*//')
    ready_m=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f2 | sed 's/^0*//')
    ready_s=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f3 | sed 's/^0*//')
      
    total_h=$((ready_h - init_h))
    total_m=$((ready_m - init_m))
    if [[ "$total_m" < 0 ]];then
        total_m=$((minutes - init_m + total_m))
	total_h=$((total_h - 1))
    fi
    total_s=$((ready_s - init_s))
    if [[ "$total_s" < 0 ]]; then
	total_s=$((seconds - init_s + ready_s))
	total_m=$((total_m - 1))
    fi
    if [[ "$total_h" > 0 ]]; then
    	echo "Pod $pod became state Running in "$total_h"H:"$total_m"M:"$total_s"S"
    elif [[ "$total_m" > 0 ]];then
	echo "Pod $pod became state Running in "$total_m"M:"$total_s"S"
    else
	echo "Pod $pod became state Running in "$total_s"S"
    fi
  done
done
