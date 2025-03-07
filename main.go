package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"todo/handlers"
	"todo/model"
)

func main() {
	r := gin.Default()

	todoRepo, err := model.NewMongoTodoReposity()
	if err != nil {
		log.Fatalf("Model had a fatal error %d", err)
	}

	todoHandler := handlers.NewHandlerFunc(todoRepo)

	v1 := r.Group("/api/v1")
	{
		v1.GET("/health", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"status": "ok",
			})
		})
		todos := v1.Group("todos")
		{
			todos.GET("", todoHandler.GetTodo())
			todos.GET("/:id", todoHandler.GetTodoByID())
			todos.POST("", todoHandler.PostTodo())
			todos.PUT("/:id", todoHandler.PutTodo())
		}

	}
	r.Run(":6400") // Specify port 6400 here
}
