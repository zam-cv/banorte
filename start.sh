#!/bin/bash

if [ -z "$ROOT_PASSWORD" ]; then
    echo "ROOT_PASSWORD is not set. Using default password 'password'"
    ROOT_PASSWORD='password'
fi

echo "root:$ROOT_PASSWORD" | chpasswd

service ssh start

/opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties

/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

echo "Waiting for Kafka to be ready..."
until /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092 &>/dev/null; do
  sleep 1
done
echo "Kafka is ready!"

/opt/kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

echo "Test topic 'test-topic' created"

tail -f /dev/null