package routes

import (
	"api_gateway/middlewares"

	"github.com/gin-gonic/gin"
)

func addNoticesRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/notices")

	group.POST("/all", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"message": "Mensaje enviado",
		})
	})
}
