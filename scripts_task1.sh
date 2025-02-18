docker exec -it kafka-0 bash
kafka-topics.sh --bootstrap-server localhost:9092 --topic balanced_topic --create --partitions 8 --replication-factor 3
kafka-topics.sh --bootstrap-server localhost:9092 --list
kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic balanced_topic

echo '{
    "version": 1,
    "partitions": [
      {"topic": "balanced_topic", "partition": 0, "replicas": [0, 1, 2], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 1, "replicas": [1, 2, 0], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 2, "replicas": [2, 0, 1], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 3, "replicas": [1, 0, 2], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 4, "replicas": [0, 2, 1], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 5, "replicas": [1, 2, 0], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 6, "replicas": [2, 0, 1], "log_dirs": ["any", "any", "any"]},
      {"topic": "balanced_topic", "partition": 7, "replicas": [2, 1, 0], "log_dirs": ["any", "any", "any"]}
    ]
}' > reassignment.json

kafka-reassign-partitions.sh \
--bootstrap-server localhost:9092 \
--broker-list "1,2,3,4" \
--topics-to-move-json-file "/tmp/reassignment.json" \
--generate

kafka-reassign-partitions.sh --bootstrap-server localhost:9092 --reassignment-json-file reassignment.json --execute