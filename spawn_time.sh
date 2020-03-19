NAMESPACES=${1:-kube-system}

for namespace in $NAMESPACES; do
  pods=$(kubectl get pods -o=name -n $namespace);
  for pod in $pods; do
    initialized=$(kubectl get $pod -n $namespace -o jsonpath='{.status.conditions[0].lastTransitionTime}')
    ready=$(kubectl get $pod -n $namespace -o jsonpath='{.status.conditions[1].lastTransitionTime}')
    init_h=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f1)
    init_m=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f2)
    init_s=$(echo $initialized | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f3)

    ready_h=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f1)
    ready_m=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f2)
    ready_s=$(echo $ready | cut -d "T" -f2 | cut -d "Z" -f1 | cut -d ":" -f3)
      
    total_h=$((ready_h - init_h))
    total_m=$((ready_m - init_m))
    total_s=$((ready_s - init_s))
    echo "Pod $pod became state Running in $total_hH:$total_mM:$total_s:S"
  done
done
