package routes

import (
	"api_gateway/config"

	"github.com/gin-gonic/gin"
)

func Run() *gin.Engine {
	var router = gin.Default()

	GetRoutes(router)
	router.Run(":" + config.Port)

	return router
}

func GetRoutes(router *gin.Engine) {
	api := router.Group("/api")

	addAuthRoutes(api)
	addChatRoutes(api)
	addNoticesRoutes(api)
}
