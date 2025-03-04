package handlers

import (
	"net/http"
	"strconv"

	"todo/model"
	"todo/types"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	repo model.TodoRepository
}

func NewHandlerFunc(repo model.TodoRepository) *Handler {
	return &Handler{
		repo: repo,
	}
}

func (h *Handler) GetTodo() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var req types.GetoTodosReq

		if err := ctx.ShouldBind(&req); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		todos, err := h.repo.GetAll()
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		ctx.JSON(http.StatusOK, todos)
	}
}

func (h *Handler) GetTodoByID() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		id := ctx.Param("id")

		todoID, err := strconv.Atoi(id)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"status": "Invalid ID format"})
			return
		}

		todo, err := h.repo.GetByID(todoID)
		if err != nil {
			ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		}

		ctx.JSON(http.StatusOK, todo)
	}
}

func (h *Handler) PostTodo() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		var PostTodo types.PostTodoReq

		if err := ctx.ShouldBind(&PostTodo); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		newTodo, err := h.repo.Create(PostTodo)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, err.Error())
		}

		ctx.JSON(http.StatusOK, newTodo)
	}
}

func (h *Handler) PutTodo() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		id := ctx.Param("id")
		todoID, err := strconv.Atoi(id)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID format"})
			return
		}

		var putTodo types.PutTodoReq
		if err := ctx.ShouldBind(&putTodo); err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		updatedTodo, err := h.repo.Update(todoID, putTodo)
		if err != nil {
			ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}

		ctx.JSON(http.StatusOK, updatedTodo)
	}
}

func (h *Handler) DeleteTodo() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		// Parse the ID from URL parameter
		id := ctx.Param("id")
		todoID, err := strconv.Atoi(id)
		if err != nil {
			ctx.JSON(http.StatusBadRequest, gin.H{"status": "Invalid ID format"})
			return
		}

		deletedTodo, err := h.repo.Delete(todoID)
		if err != nil {
			ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		ctx.JSON(http.StatusOK, gin.H{
			"status":  "todo deleted",
			"deleted": deletedTodo,
		})
	}
}
