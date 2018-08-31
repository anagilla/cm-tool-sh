#!/bin/bash

# This script helps to enable TLS for:
# - CM Admin Console
# - CM Management Services
# _ CM Agents
# Steps followed from below official doc:
# https://www.cloudera.com/documentation/enterprise/latest/topics/how_to_configure_cm_tls.html

set -e

CM_HOST=$1
TLS_ENABLED=$2

BASE_DIR=$(dirname $0)

# Update CM Configurations to enable TLS for CM, CM Management Services and CM Agents
sh $BASE_DIR/update-cm-config.sh $CM_HOST $TLS_ENABLED

echo ""
echo "Please make sure that above commands returned correctly and confirm \"yes\" to continue restarting CM server and agents"
read response

if [ $response == "yes" ]; then
  sh $BASE_DIR/enable-agent.sh $CM_HOST $TLS_ENABLED

  echo ""
  echo "Restarting CM server on host: $CM_HOST"
  ssh root@$CM_HOST 'service cloudera-scm-server restart'
  echo ""
  echo "After CM restarted, please log into CM and restart Cloudera Management services"
  echo ""
fi

