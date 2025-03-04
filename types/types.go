package types

import "time"

type GetoTodosReq struct {
	Completed *bool `form:"completed" binding:"required"`
	Window    *int  `form:"window" binding:"required,gte=0"`
}

type Todo struct {
	ID          int       `json:"id" binding:"required"`
	Title       string    `json:"title" binding:"required"`
	Description string    `json:"description" binding:"required"`
	Completed   bool      `json:"completed" binding:"required"`
	DeadlineAt  time.Time `json:"deadline_at" binding:"required" time_format:"2006-01-02T15:04:05"`
	CreatedAt   time.Time `json:"created_at" binding:"required"`
	UpdatedAt   time.Time `json:"updated_at" binding:"required"`
}

type PostTodoReq struct {
	ID          int       `json:"id" binding:"required"`
	Title       string    `json:"title" binding:"required"`
	Description string    `json:"description" binding:"required"`
	Completed   bool      `json:"completed" binding:"required"`
	DeadlineAt  time.Time `json:"deadline_at" binding:"required" time_format:"2006-01-02T15:04:05"`
}

type PutTodoReq struct {
	ID          *int       `json:"id,omitempty"`
	Title       *string    `json:"title,omitempty"`
	Description *string    `json:"description,omitempty"`
	Completed   *bool      `json:"completed,omitempty"`
	DeadlineAt  *time.Time `json:"deadline_at,omitempty" time_format:"2006-01-02T15:04:05"`
}
