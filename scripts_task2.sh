docker exec -it kafka-1 bash 

/usr/bin/kafka-topics --create \
--bootstrap-server localhost:9092 \
--replication-factor 2 \
--partitions 3 \
--topic sasl-plain-topic

/usr/bin/kafka-topics --list --bootstrap-server localhost:9092

/usr/bin/kafka-topics --bootstrap-server localhost:9092 --describe --topic sasl-plain-topic

/usr/bin/kafka-topics --bootstrap-server localhost:9092 --delete --topic sasl-plain-topic

/usr/bin/kafka-console-consumer \
  --bootstrap-server localhost:9093 \
  --topic sasl-plain-topic \
  --from-beginning \
  --consumer.config /etc/kafka/secrets/kafka-1.sasl.jaas.conf

/usr/bin/kafka-console-producer \
  --bootstrap-server localhost:9093 \
  --topic sasl-plain-topic \
  --producer.config /etc/kafka/secrets/kafka-1.sasl.jaas.conf

echo '
bootstrap.servers=localhost:9093
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="admin-secret";
' > client.properties


/usr/bin/kafka-console-producer \
  --broker-list localhost:9093 \
  --topic sasl-plain-topic \
  --producer.config /etc/kafka/secrets/client.properties

/usr/bin/kafka-console-consumer \
  --bootstrap-server localhost:9093 \
  --topic sasl-plain-topic \
  --from-beginning \
  --consumer.config /etc/kafka/secrets/client.properties

/usr/bin/kafka-topics  \
  --create   \
  --bootstrap-server localhost:9093 \
  --replication-factor 3 \
  --partitions 3   \
  --topic topic-1   \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-topics  \
  --create   \
  --bootstrap-server localhost:9093 \
  --replication-factor 3 \
  --partitions 3   \
  --topic topic-2   \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-topics --list --bootstrap-server localhost:9093 \
      --command-config /etc/kafka/secrets/client.properties


/usr/bin/kafka-topics --bootstrap-server localhost:9093 --describe --topic topic-1 \
      --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-topics --bootstrap-server localhost:9093 --delete --topic topic-2 \
      --command-config /etc/kafka/secrets/client.properties


/usr/bin/kafka-acls \
  --bootstrap-server localhost:9093 \
  --add --allow-principal "User:producer" \
  --operation Write \
  --topic topic-1 \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-acls \
  --bootstrap-server localhost:9093 \
  --add --allow-principal "User:consumer" \
  --operation Read \
  --topic topic-1 \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-acls --bootstrap-server localhost:9093 \
  --add --allow-principal User:consumer \
  --operation Read --group '*' \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-acls --bootstrap-server localhost:9093 \
  --add --allow-principal User:producer \
  --operation Write --topic topic-2 \
  --command-config /etc/kafka/secrets/client.properties


/usr/bin/kafka-acls \
  --bootstrap-server localhost:9093 \
  --list \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-acls \
  --bootstrap-server localhost:9093 \
  --list \
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-acls --bootstrap-server localhost:9093 \
  --remove --allow-principal User:consumer \
  --operation Read --group '*'\
  --command-config /etc/kafka/secrets/client.properties

/usr/bin/kafka-console-producer --bootstrap-server localhost:9093 \
  --topic topic-1 \
  --producer.config /etc/kafka/secrets/client.properties

/usr/bin/kafka-console-producer --bootstrap-server localhost:9093 \
  --topic topic-2 \
  --producer.config /etc/kafka/secrets/consumer.properties

/usr/bin/kafka-console-consumer --bootstrap-server localhost:9093 \
  --topic topic-2 \
  --consumer.config /etc/kafka/secrets/consumer.properties



/usr/bin/kafka-acls \
  --bootstrap-server localhost:9093 \
  --command-config /etc/kafka/secrets/client.properties \
  --add \
  --allow-principal "User:admin" \
  --operation Write \
  --topic topic-1


  /usr/bin/kafka-acls --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal "User:producer_user" \
  --operation Write --topic topic-1

/usr/bin/kafka-topics --bootstrap-server localhost:9092 \
  --create --topic topic-1 --partitions 3 --replication-factor 2

/usr/bin/kafka-topics --bootstrap-server localhost:9092 \
  --create --topic topic-2 --partitions 3 --replication-factor 2

  /usr/bin/kafka-acls --bootstrap-server localhost:9092  \
  --command-config /etc/kafka/secrets/client.properties \
  --add --allow-principal "User:user" \
  --operation Alter \
  --topic topic-1

  /usr/bin/kafka-configs --bootstrap-server localhost:9092 \
  --describe --entity-type brokers