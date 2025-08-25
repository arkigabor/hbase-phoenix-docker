#!/bin/bash
set -e

trap "echo 'Stopping HBase due to SIGTERM or SIGINT'; /opt/hbase/bin/stop-hbase.sh; exit 0" SIGTERM SIGINT

JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export JAVA_HOME

echo "export JAVA_HOME=${JAVA_HOME}" >> /root/.bashrc

/opt/hbase/bin/start-hbase.sh

tail -F /opt/hbase/logs/hbase-*.log &

while true; do sleep 10; done
