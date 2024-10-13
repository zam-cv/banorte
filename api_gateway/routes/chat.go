package routes

import (
	"api_gateway/middlewares"
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ChatMessage struct {
	Prompt   string  `json:"prompt" binding:"required"`
	Category *string `json:"category"`
}

type ChatResponse struct {
	Question      string   `json:"question" binding:"required"`
	Options       []string `json:"options" binding:"required"`
	CorrectAnswer string   `json:"correct_answer" binding:"required"`
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")

	group.POST("/message", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var message ChatMessage
		if err := ctx.ShouldBindJSON(&message); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		jsonData, err := json.Marshal(message)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al preparar la solicitud"})
			return
		}

		resp, err := http.Post("http://127.0.0.1:8000/model/selection/", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al realizar la solicitud al servicio externo"})
			return
		}
		defer resp.Body.Close()

		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al leer la respuesta del servicio externo"})
			return
		}

		var chatResponse ChatResponse
		if err := json.Unmarshal(body, &chatResponse); err != nil {
			ctx.JSON(500, gin.H{"error": "Error al procesar la respuesta del servicio externo"})
			return
		}

		ctx.JSON(200, chatResponse)
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
