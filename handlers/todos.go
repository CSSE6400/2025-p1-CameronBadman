package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func TodoHandler() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"status": "ok",
		})
	}
}
