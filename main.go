package main

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"todo/handlers"
)

func main() {
	r := gin.Default()

	v1 := r.Group("/api/v1")
	{
		v1.GET("/health", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"status": "ok",
			})
		})

		todo := v1.Group("/todos")
		{
			todo.GET("", handlers.TodoHandler())
		}

	}
	r.Run()
}
