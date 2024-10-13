package routes

import (
	"api_gateway/middlewares"

	"github.com/gin-gonic/gin"
)

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")

	group.POST("/message", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
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
