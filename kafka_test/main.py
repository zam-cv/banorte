from kafka import KafkaConsumer, KafkaProducer
import json
import time
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

KAFKA_BROKER = 'localhost:9092'
CONSUMER_TOPIC = 'chat-messages'
PRODUCER_TOPIC = 'chat-responses'
GROUP_ID = 'chat-group'

def get_kafka_consumer():
    return KafkaConsumer(
        CONSUMER_TOPIC,
        bootstrap_servers=[KAFKA_BROKER],
        group_id=GROUP_ID,
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        value_deserializer=lambda x: x.decode('utf-8')
    )

def get_kafka_producer():
    return KafkaProducer(
        bootstrap_servers=[KAFKA_BROKER],
        value_serializer=lambda x: json.dumps(x).encode('utf-8')
    )

def process_message(message):
    return f"Processed: {message}"

def main():
    consumer = get_kafka_consumer()
    producer = get_kafka_producer()

    logging.info("Waiting for messages...")

    try:
        for message in consumer:
            logging.info(f"Received raw message: {message.value}")
            
            try:
                # Intentar decodificar como JSON
                json_message = json.loads(message.value)
                content = json_message.get('content', message.value)
            except json.JSONDecodeError:
                # Si no es JSON, usar el valor tal cual
                content = message.value
            
            logging.info(f"Processing content: {content}")
            
            response = process_message(content)
            
            # Send the response back to Kafka
            producer.send(PRODUCER_TOPIC, {'message': response})
            producer.flush()

            logging.info(f"Sent response: {response}")
    except KeyboardInterrupt:
        logging.info("Shutting down...")
    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
    finally:
        consumer.close()
        producer.close()

if __name__ == "__main__":
    main()