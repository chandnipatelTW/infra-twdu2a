#!/bin/bash

sudo su

# 1. Stop Kafka and zookeeper and clear data directory of kafka
systemctl stop confluent-kafka
systemctl stop confluent-zookeeper

rm -rf /var/lib/kafka/*

# 2. Create myid file for zookeeper
echo ${index} > /var/lib/zookeeper/myid

# 3. Change zookeeper configuration
> /etc/kafka/zookeeper.properties
cat | tee -a /etc/kafka/zookeeper.properties > /dev/null << EOF
tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
initLimit=15
syncLimit=2
server.1=kafka-1.${cohort}.training:2888:3888
server.2=kafka-2.${cohort}.training:2888:3888
server.3=kafka-3.${cohort}.training:2888:3888
EOF


# TODO parameterize training cohort
# 4. Set kafka server.properties broker.id, zookeeper.connect, default.replication.factor, offsetreplication factor
sed -i 's/broker.id=0/broker.id=${index}/g' /etc/kafka/server.properties
sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=kafka-1.${cohort}.training:2181,kafka-2.${cohort}.training:2181,kafka-3.${cohort}.training:2181/g' /etc/kafka/server.properties
echo -e "\ndefault.replication.factor=3\n"
sed -i 's/offsets.topic.replication.factor=1/offsets.topic.replication.factor=3/g' /etc/kafka/server.properties
echo -e "\nmin.insync.replicas=2\n" >> /etc/kafka/server.properties

# 5. Start zookeeper
systemctl start confluent-zookeeper

# 6. Start Kafka
systemctl start confluent-kafka


