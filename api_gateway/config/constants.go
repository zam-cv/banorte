package config

import (
	"os"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/joho/godotenv"
)

var (
	Port             string
	SecretKey        string
	FirestoreClient  *firestore.Client
	JwtSecret        = []byte("")
	KafkaBroker      = "0.0.0.0:9092"
	ProducerTopic    = "chat-messages"
	ConsumerTopic    = "chat-responses"
	KafkaReadTimeout = 10 * time.Second
)

func LoadEnvVars() {
	if err := godotenv.Load(); err != nil {
		panic(err)
	}

	Port = os.Getenv("PORT")
	SecretKey = os.Getenv("SECRET_KEY")
	JwtSecret = []byte(SecretKey)
}
