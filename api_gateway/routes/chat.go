package routes

import (
	"api_gateway/middlewares"

	"github.com/gin-gonic/gin"
)

type ChatMessage struct {
	Prompt   string  `json:"prompt" binding:"required"`
	Category *string `json:"category"`
}

type ChatResponse struct {
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")

	group.POST("/message", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var message ChatMessage
		if err := ctx.ShouldBindJSON(&message); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		ctx.JSON(200, gin.H{
			"message": "Mensaje enviado",
		})
	})

	group.POST("/practice", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"message": "Mensaje enviado",
		})
	})

	group.POST("/learn", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"message": "Mensaje enviado",
		})
	})
}
