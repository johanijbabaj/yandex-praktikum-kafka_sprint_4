from confluent_kafka import Consumer

if __name__ == "__main__":
   config = {
       "bootstrap.servers": "localhost:19093",
       "group.id": "consumer-ssl-group",

       "security.protocol": "SASL_PLAINTEXT",
       "ssl.ca.location": "ca.crt",  
       "ssl.certificate.location": "kafka-1-creds/kafka-1.crt",
       "ssl.key.location": "kafka-1-creds/kafka-1.key",

       "sasl.mechanism": "PLAIN",
       "sasl.username": "admin",
       "sasl.password": "admin-secret",
   }
   consumer = Consumer(config)
   consumer.subscribe(["sasl-plain-topic"])

   try:
       while True:
           message = consumer.poll(0.1)

           if message is None:
               continue
           if message.error():
               print(f"Error: {message.error()}")
               continue

           key = message.key().decode("utf-8")
           value = message.value().decode("utf-8")
           print(f"Received message: {key=}, {value=}, offset={message.offset()}")
   finally:
       consumer.close()