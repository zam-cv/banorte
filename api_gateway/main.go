package main

import (
	"api_gateway/config"
	"api_gateway/routes"
	"context"
	"fmt"
	"log"
	"net"
	"strconv"

	"cloud.google.com/go/firestore"
	"github.com/segmentio/kafka-go"
)

func initFirestore() {
	ctx := context.Background()
	projectID := "gcp-banorte-hackaton-team-5"
	dbName := "hack-banorte"

	client, err := firestore.NewClientWithDatabase(ctx, projectID, dbName)
	if err != nil {
		log.Fatalf("Error al crear el cliente de Firestore: %v", err)
	}
	config.FirestoreClient = client
}

func createTopic(brokerAddress, topicName string, numPartitions, replicationFactor int) error {
	// Connect to the broker
	conn, err := kafka.Dial("tcp", brokerAddress)
	if err != nil {
		return fmt.Errorf("failed to connect to broker: %v", err)
	}
	defer conn.Close()

	// Get the controller
	controller, err := conn.Controller()
	if err != nil {
		return fmt.Errorf("failed to get controller: %v", err)
	}

	// Connect to the controller
	controllerAddress := net.JoinHostPort(controller.Host, strconv.Itoa(controller.Port))
	controllerConn, err := kafka.Dial("tcp", controllerAddress)
	if err != nil {
		return fmt.Errorf("failed to connect to controller: %v", err)
	}
	defer controllerConn.Close()

	// Create the topic
	topicConfigs := []kafka.TopicConfig{
		{
			Topic:             topicName,
			NumPartitions:     numPartitions,
			ReplicationFactor: replicationFactor,
		},
	}

	err = controllerConn.CreateTopics(topicConfigs...)
	if err != nil {
		return fmt.Errorf("failed to create topic: %v", err)
	}

	return nil
}

func main() {
	err := createTopic("localhost:9092", "chat-messages", 1, 1)
	if err != nil {
		fmt.Printf("Error creating topic: %v\n", err)
		return
	}
	fmt.Println("Topic created successfully")

	err = createTopic("localhost:9092", "chat-responses", 1, 1)
	if err != nil {
		fmt.Printf("Error creating topic: %v\n", err)
		return
	}
	fmt.Println("Topic created successfully")

	initFirestore()
	defer config.FirestoreClient.Close()

	// Load environment variables
	config.LoadEnvVars()

	// Auth
	routes.Run()
}
