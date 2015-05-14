#!/bin/bash

# Stop on error
set -e


# Loop until confd has updated the haproxy config
for n in `seq 10`; do
    echo "waiting for network ready $n"
    myip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
    node=$(echo $myip|sed -e's/\./_/g')
    if [ "$myip" != "" ]; then
        break;
    fi
    sleep $n
done

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
