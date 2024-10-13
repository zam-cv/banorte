package routes

import (
	"api_gateway/config"
	"api_gateway/middlewares"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/segmentio/kafka-go"
)

var (
	writer     *kafka.Writer
	reader     *kafka.Reader
	writerOnce sync.Once
	readerOnce sync.Once
)

func getKafkaWriter() *kafka.Writer {
	writerOnce.Do(func() {
		writer = kafka.NewWriter(kafka.WriterConfig{
			Brokers: []string{config.KafkaBroker},
			Topic:   config.ProducerTopic,
		})
	})
	return writer
}

func getKafkaReader() *kafka.Reader {
	readerOnce.Do(func() {
		reader = kafka.NewReader(kafka.ReaderConfig{
			Brokers: []string{config.KafkaBroker},
			Topic:   config.ConsumerTopic,
			GroupID: "chat-group",
		})
	})
	return reader
}

func sendKafkaMessage(ctx context.Context, message string) error {
	return getKafkaWriter().WriteMessages(ctx, kafka.Message{
		Value: []byte(message),
	})
}

func readKafkaMessage(ctx context.Context) (string, error) {
	msg, err := getKafkaReader().ReadMessage(ctx)
	if err != nil {
		return "", err
	}
	return string(msg.Value), nil
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")
	group.POST("/messages", middlewares.AuthMiddleware(), handleChatMessage)
}

func handleChatMessage(c *gin.Context) {
	var message struct {
		Content string `json:"content"`
	}
	if err := c.ShouldBindJSON(&message); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid message format"})
		return
	}

	ctx, cancel := context.WithTimeout(c.Request.Context(), 30*time.Second)
	defer cancel()

	// Send message to Kafka
	err := sendKafkaMessage(ctx, message.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		return
	}

	// Read response from Kafka
	response, err := readKafkaMessage(ctx)
	if err != nil {
		if errors.Is(err, context.DeadlineExceeded) {
			c.JSON(http.StatusRequestTimeout, gin.H{"error": "Response timeout"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to read response"})
		}
		return
	}

	var responseData map[string]interface{}
	if err := json.Unmarshal([]byte(response), &responseData); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid response format"})
		return
	}

	c.JSON(http.StatusOK, responseData)
}
