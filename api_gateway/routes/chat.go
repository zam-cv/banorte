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

type Result struct {
	Response string `json:"response"`
}

func addChatRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/chat")
	llmUrl := "http://" + config.LLMHost + ":" + config.LLMPort

	group.GET("/message/:category", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		llmReq := map[string]string{
			"category": ctx.Param("category"),
		}

		jsonData, err := json.Marshal(llmReq)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error preparing the request"})
			return
		}

		resp, err := http.Post(llmUrl+"/model/selection/questions", "application/json", bytes.NewBuffer(jsonData))
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

		var response ChatResponse
		if err := json.Unmarshal(body, &response); err != nil {
			ctx.JSON(500, gin.H{"error": "Error processing response from external service"})
			return
		}

		ctx.JSON(200, response)
	})

	group.GET("/practice", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		resp, err := http.Get(llmUrl + "/model/selection/questions/situation")
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

		var response ChatResponse
		if err := json.Unmarshal(body, &response); err != nil {
			ctx.JSON(500, gin.H{"error": "Error processing response from external service"})
			return
		}

		ctx.JSON(200, response)
	})

	group.POST("/learn", middlewares.AuthMiddleware(), func(ctx *gin.Context) {
		var req MessageRequest
		if err := ctx.ShouldBindJSON(&req); err != nil {
			ctx.JSON(400, gin.H{"error": err.Error()})
			return
		}

		llmReq := map[string]interface{}{
			"model": "banorte_ai",
			"values": map[string]string{
				"prompt":              req.Prompt,
				"category":            "Salud financiera",
				"information_context": "La salud financiera es ",
				"user_context":        "Eduardo chavez tiene 25 años y uan hipoteca",
			},
		}

		jsonData, err := json.Marshal(llmReq)
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error preparing the request"})
			return
		}
		resp, err := http.Post(llmUrl+"/model/selection", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			ctx.JSON(500, gin.H{"error": "Error making request to external service"})
			return
		}
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

		var response Result
		if err := json.Unmarshal(body, &response); err != nil {
			ctx.JSON(500, gin.H{"error": "Error processing response from external service"})
			return
		}

		ctx.JSON(200, response)
	})
}
