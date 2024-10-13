package routes

import (
	"api_gateway/middlewares"
	"net/http"

	"github.com/gin-gonic/gin"
)

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")

	group.GET("/messages", middlewares.AuthMiddleware(), func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Lista de mensajes",
		})
	})
}
