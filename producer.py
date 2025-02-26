import uuid

from confluent_kafka import Producer


if __name__ == "__main__":
   config = {
       "bootstrap.servers": "127.0.0.1:19093",

       "security.protocol": "SASL_PLAINTEXT",
       "ssl.ca.location": "ca.crt",
       "ssl.certificate.location": "kafka-1-creds/kafka-1.crt",
       "ssl.key.location": "kafka-1-creds/kafka-1.key",

       "sasl.mechanism": "PLAIN",
       "sasl.username": "admin",
       "sasl.password": "admin-secret",
       # "debug": "all",
   }
  
   producer = Producer(config)

   key = f"key-{uuid.uuid4()}"
   value = f"SASL/PLAIN {key}"
   print(f"Prepair message: {key=}, {value=}")
   producer.produce(
       "sasl-plain-topic",
       key=key,
       value=value,
   )
   producer.flush(timeout=10)
   print(f"Message was sent: {key=}, {value=}")