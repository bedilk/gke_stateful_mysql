#!/bin/bash
# Copyright 2022 Google LLC
#

NAMESPACE=${1:+"-n ${1}"}
shift
APP_SELECTOR=${1:+"--selector=app=${1}"}
shift

# jsonpath will iterate through each of the pods 
# and output Pod name and node name
for EACH_POD_NODE in `kubectl \
                       --field-selector status.phase!=Pending \
                       ${NAMESPACE} get pods ${APP_SELECTOR} \
                       -o=jsonpath='{range .items[*]}{.metadata.name}{","}{.spec.nodeName}{"\n"}{end}' `
do
  # for each Pod/Node line item, obtain Cloud Zone for Node
  IFS=","; POD_NODE=($EACH_POD_NODE)
  kubectl get node ${POD_NODE[1]} \
     -o jsonpath='{.metadata.name} {.metadata.labels.topology\.kubernetes\.io\/zone} {"'${POD_NODE[0]}'"}{"\n"}'
done
# [END gke_stateful_mysql_main_body]