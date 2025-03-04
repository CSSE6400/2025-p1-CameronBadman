package main

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"todo/handlers"
	"todo/model"
)

func main() {
	r := gin.Default()

	todoRepo := model.NewStaticTodoRepository()

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
			todos.GET("/", todoHandler.GetTodo())
			todos.GET("/:id", todoHandler.GetTodoByID())
			todos.POST("/", todoHandler.PostTodo())
			todos.PUT("/:id", todoHandler.PutTodo())
		}

	}
	r.Run()
}
