package routes

import (
	"api_gateway/config"
	"context"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	FirstName string `json:"first_name" binding:"required"`
	LastName  string `json:"last_name" binding:"required"`
	RFC       string `json:"rfc"`
	Email     string `json:"email" binding:"required,email"`
	Birthdate string `json:"birthdate" binding:"required"`
	Password  string `json:"password" binding:"required,min=6"`
}

func addAuthRoutes(rg *gin.RouterGroup) {
	group := rg.Group("/auth")

	group.POST("/register", func(c *gin.Context) {
		var user User
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		docSnap, err := config.FirestoreClient.Collection("users").Doc(user.Email).Get(context.Background())
		if err == nil && docSnap.Exists() {
			c.JSON(http.StatusConflict, gin.H{"error": "El usuario ya está registrado"})
			return
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error al procesar la contraseña"})
			return
		}

		_, err = config.FirestoreClient.Collection("users").Doc(user.Email).Set(context.Background(), map[string]interface{}{
			"first_name": user.FirstName,
			"last_name":  user.LastName,
			"rfc":        user.RFC,
			"email":      user.Email,
			"birthdate":  user.Birthdate,
			"password":   string(hashedPassword),
		})
		if err != nil {
			log.Printf("Error al guardar datos del usuario en Firestore: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error al registrar el usuario"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{
			"message": "Usuario registrado exitosamente",
			"email":   user.Email,
		})
	})

	group.POST("/login", func(c *gin.Context) {
		var loginData struct {
			Email    string `json:"email" binding:"required,email"`
			Password string `json:"password" binding:"required"`
		}

		if err := c.ShouldBindJSON(&loginData); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		docSnap, err := config.FirestoreClient.Collection("users").Doc(loginData.Email).Get(context.Background())
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Credenciales inválidas"})
			return
		}
		userData := docSnap.Data()
		hashedPassword := userData["password"].(string)

		err = bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(loginData.Password))
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Credenciales inválidas"})
			return
		}

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"email": loginData.Email,
			"exp":   time.Now().Add(time.Hour * 72).Unix(),
		})
		tokenString, err := token.SignedString(config.JwtSecret)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error al crear el token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"message": "Inicio de sesión exitoso",
			"token":   tokenString,
		})
	})

	group.GET("/verify", func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token no proporcionado"})
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return config.JwtSecret, nil
		})

		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token inválido"})
			return
		}

		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			c.JSON(http.StatusOK, gin.H{
				"message": "Token válido",
				"email":   claims["email"],
			})
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token inválido"})
		}
	})
}
