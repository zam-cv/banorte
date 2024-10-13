package routes

import (
	"api_gateway/config"
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

type ChatRequest struct {
	Model  string `json:"model" binding:"required"`
	Values Values `json:"values" binding:"required"`
}

type Values struct {
	Prompt             string `json:"prompt" binding:"required"`
	Category           string `json:"category" binding:"required"`
	InformationContext string `json:"information_context" binding:"required"`
	UserContext        string `json:"user_context" binding:"required"`
}

type ChatResponse struct {
	Question      string   `json:"question" binding:"required"`
	Options       []string `json:"options" binding:"required"`
	CorrectAnswer string   `json:"correct_answer" binding:"required"`
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")
	llmUrl := "http://" + config.LLMHost + ":" + config.LLMPort

	group.POST("/message", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var message ChatMessage
		if err := ctx.ShouldBindJSON(&message); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		var request ChatRequest
		request.Model = "game_banorte_ai_question"
		request.Values.Prompt = message.Prompt
		request.Values.Category = *message.Category
		request.Values.InformationContext = "La salud financiera es felicidad"
		request.Values.UserContext = "El usuario se llama eduardo y tiene 20 años. Quiere ahorrar dinero"

		jsonData, err := json.Marshal(request)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al preparar la solicitud"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/", "application/json", bytes.NewBuffer(jsonData))
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
		var message ChatMessage
		if err := ctx.ShouldBindJSON(&message); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		var request ChatRequest
		request.Model = "game_banorte_ai_question"
		request.Values.Prompt = message.Prompt
		request.Values.Category = *message.Category
		request.Values.InformationContext = "La salud financiera es felicidad"
		request.Values.UserContext = "El usuario se llama eduardo y tiene 20 años. Quiere ahorrar dinero"

		jsonData, err := json.Marshal(request)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al preparar la solicitud"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/", "application/json", bytes.NewBuffer(jsonData))
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

	group.POST("/learn", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var message ChatMessage
		if err := ctx.ShouldBindJSON(&message); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		var request ChatRequest
		request.Model = "banorte_ai"
		request.Values.Prompt = message.Prompt
		request.Values.Category = *message.Category
		request.Values.InformationContext = "La salud financiera es felicidad"
		request.Values.UserContext = "El usuario se llama eduardo y tiene 20 años. Quiere ahorrar dinero"

		jsonData, err := json.Marshal(request)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error al preparar la solicitud"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/", "application/json", bytes.NewBuffer(jsonData))
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
}
