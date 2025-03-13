package types

import (
	"time"
)

type GetoTodosReq struct {
	Completed *bool `form:"completed" binding:"omitempty"`
	Window    *int  `form:"window" binding:"omitempty,gte=0"`
}

type Todo struct {
	ID          int       `bson:"_id" json:"id"`
	Title       string    `bson:"title" json:"title" binding:"required"`
	Description string    `bson:"description" json:"description" binding:"required"`
	Completed   bool      `bson:"completed" json:"completed" binding:"required"`
	DeadlineAt  time.Time `bson:"deadline_at" json:"deadline_at" binding:"required" time_format:"2006-01-02T15:04:05"`
	CreatedAt   time.Time `bson:"created_at" json:"created_at" binding:"required"`
	UpdatedAt   time.Time `bson:"updated_at" json:"updated_at" binding:"required"`
}

type PostTodoReq struct {
	Title       string    `json:"title" binding:"required"`
	Description string    `json:"description" binding:"required"`
	Completed   *bool     `json:"completed" binding:"required"`
	DeadlineAt  time.Time `json:"deadline_at" binding:"required" time_format:"2006-01-02T15:04:05"`
}

type PutTodoReq struct {
	ID          *int       `json:"id,omitempty"`
	Title       *string    `json:"title,omitempty"`
	Description *string    `json:"description,omitempty"`
	Completed   *bool      `json:"completed,omitempty"`
	DeadlineAt  *time.Time `json:"deadline_at,omitempty" time_format:"2006-01-02T15:04:05"`
}
