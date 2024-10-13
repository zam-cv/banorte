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

type Message struct {
	Prompt string `json:"prompt"`
}

type MessageRequest struct {
	Prompt string `json:"prompt" binding:"required"`
}

type PracticeLearnRequest struct {
	Category string `json:"category" binding:"required"`
}

type ChatResponse struct {
	Question      string   `json:"question"`
	Options       []string `json:"options"`
	CorrectAnswer string   `json:"correct_answer"`
}

type LLMRequest struct {
	Model  string      `json:"model"`
	Values interface{} `json:"values"`
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")
	llmUrl := "http://" + config.LLMHost + ":" + config.LLMPort

	group.POST("/message", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var req Message
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		llmReq := LLMRequest{
			Model: "banorte_ai",
			Values: map[string]string{
				"prompt":              req.Prompt,
				"category":            "chat",
				"information_context": "Eres un usuario de Banorte",
				"user_context":        "Eres un usuario de Banorte",
			},
		}

		jsonData, err := json.Marshal(llmReq)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error preparing the request"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error making request to external service"})
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			body, _ := ioutil.ReadAll(resp.Body)
			ctx.JSON(resp.StatusCode, gin.H{"error": string(body)})
			return
		}

		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error reading response from external service"})
			return
		}

		var response struct {
			Response string `json:"response"`
		}
		if err := json.Unmarshal(body, &response); err != nil {
			ctx.JSON(500, gin.H{"error": "Error processing response from external service"})
			return
		}

		ctx.String(200, response.Response)
	})

	group.POST("/practice", middlewares.AuthMiddleware(), handlePracticeLearn("game_banorte_ai_question", llmUrl))
	group.POST("/learn", middlewares.AuthMiddleware(), handlePracticeLearn("game_banorte_ai", llmUrl))
}

func handlePracticeLearn(model string, llmUrl string) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req PracticeLearnRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		llmReq := LLMRequest{
			Model: model,
			Values: map[string]string{
				"category": req.Category,
			},
		}

		jsonData, err := json.Marshal(llmReq)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error preparing the request"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error making request to external service"})
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			body, _ := ioutil.ReadAll(resp.Body)
			ctx.JSON(resp.StatusCode, gin.H{"error": string(body)})
			return
		}

		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error reading response from external service"})
			return
		}

		var chatResponse ChatResponse
		if err := json.Unmarshal(body, &chatResponse); err != nil {
			ctx.JSON(500, gin.H{"error": "Error processing response from external service"})
			return
		}

		ctx.JSON(200, chatResponse)
	}
}
