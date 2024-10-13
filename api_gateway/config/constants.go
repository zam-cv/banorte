package config

import (
	"os"

	"cloud.google.com/go/firestore"
	"github.com/joho/godotenv"
)

var (
	Port            string
	SecretKey       string
	FirestoreClient *firestore.Client
	JwtSecret       = []byte("")
)

func LoadEnvVars() {
	if err := godotenv.Load(); err != nil {
		panic(err)
	}

	Port = os.Getenv("PORT")
	SecretKey = os.Getenv("SECRET_KEY")
	JwtSecret = []byte(SecretKey)
}
