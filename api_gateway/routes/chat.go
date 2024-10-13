package routes

import (
	"api_gateway/config"
	"api_gateway/middlewares"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
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

		// Obtener el token del contexto (asumiendo que AuthMiddleware lo ha colocado allí)
		tokenString, exists := ctx.Get("token")
		if !exists {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Token no encontrado"})
			return
		}

		// Parsear el token
		token, err := jwt.Parse(tokenString.(string), func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return config.JwtSecret, nil
		})

		if err != nil {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Token inválido"})
			return
		}

		var userContext string
		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			// Obtener el email del usuario de las claims del token
			email, ok := claims["email"].(string)
			if !ok {
				ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Error al obtener el email del usuario"})
				return
			}

			// Obtener los datos del usuario de Firestore
			docSnap, err := config.FirestoreClient.Collection("users").Doc(email).Get(context.Background())
			if err != nil {
				log.Printf("Error al obtener datos del usuario de Firestore: %v", err)
				ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Error al obtener información del usuario"})
				return
			}

			userData := docSnap.Data()
			// Eliminar información sensible
			delete(userData, "password")

			// Crear el contexto del usuario como una cadena
			userContext = fmt.Sprintf("%s %s tiene %v años", userData["first_name"], userData["last_name"], userData["birthdate"])
			if userData["mortgage"] != nil {
				userContext += " y una hipoteca"
			}
		} else {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Token inválido"})
			return
		}

		println(userContext)
		llmReq := map[string]interface{}{
			"model": "banorte_ai",
			"values": map[string]string{
				"prompt":              req.Prompt,
				"category":            "Salud financiera",
				"information_context": "La salud financiera es ",
				"user_context":        userContext,
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
