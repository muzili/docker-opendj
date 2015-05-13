#!/bin/bash

# Stop on error
set -e

myip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
node=$(echo $myip|sed -e's/\./_/g')

etcdctl -C $ETCD_NODE set "/haproxy-discover/tcp-services/opendj/ports" "*:389"
etcdctl -C $ETCD_NODE set "/haproxy-discover/tcp-services/opendj/upstreams/$node" "${myip}:389"

if [[ -e /first_run ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

pre_start_action
post_start_action

echo "Starting slapd..."
/opt/opendj/bin/start-ds --nodetach
