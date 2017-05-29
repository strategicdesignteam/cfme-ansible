#!/bin/sh

oc project openshift-infra

oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API

oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer

oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster

oc new-app \
    -f /usr/share/openshift/hosted/metrics-deployer.yaml \
    -p HAWKULAR_METRICS_HOSTNAME=openshift-master.strategicdesign.io \
    -p USE_PERSISTENT_STORAGE=false
