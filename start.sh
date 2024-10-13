#!/bin/bash

if [ -z "$ROOT_PASSWORD" ]; then
    echo "ROOT_PASSWORD is not set. Using default password 'password'"
    ROOT_PASSWORD='password'
fi

echo "root:$ROOT_PASSWORD" | chpasswd

service ssh start

/opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties

/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

tail -f /dev/null