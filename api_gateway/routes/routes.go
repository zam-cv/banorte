package routes

import (
	"api_gateway/config"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func Run() *gin.Engine {
	var router = gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:8080", "http://172.31.98.243:8080"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		AllowCredentials: true,
		ExposeHeaders:    []string{"Content-Length"},
		MaxAge:           12 * time.Hour,
	}))

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
