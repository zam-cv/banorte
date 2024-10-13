package main

import (
	"api_gateway/config"
	"api_gateway/routes"
	"context"
	"log"

	"cloud.google.com/go/firestore"
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

func main() {
	initFirestore()
	defer config.FirestoreClient.Close()

	// Load environment variables
	config.LoadEnvVars()

	// Auth
	routes.Run()
}
