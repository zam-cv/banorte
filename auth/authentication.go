package main

import (
	"context"
	"log"
	"net/http"

	"firebase.google.com/go/v4/auth"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/option"
)

func main() {
	// Initialize Firebase app
	opt := option.WithCredentialsFile("path/to/serviceAccountKey.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	client, err := app.Auth(context.Background())
	if err != nil {
		log.Fatalf("error getting Auth client: %v\n", err)
	}

	// Set up Gin router
	r := gin.Default()
	r.Use(AuthMiddleware(client))

	// Secure endpoint
	r.GET("/secure-endpoint", func(c *gin.Context) {
		uid := c.MustGet("uid").(string)
		c.JSON(http.StatusOK, gin.H{"message": "Hello, " + uid})
	})

	r.Run()
}

// AuthMiddleware verifies the ID token and extracts the UID
func AuthMiddleware(client *auth.Client) gin.HandlerFunc {
	return func(c *gin.Context) {
		idToken := c.GetHeader("Authorization")
		token, err := client.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			return
		}
		c.Set("uid", token.UID)
		c.Next()
	}
}
