package model

import (
	"errors"
	"time"

	"todo/types"
)

type TodoRepository interface {
	GetAll() ([]types.Todo, error)
	GetByID(id int) (types.Todo, error)
	Create(postReq types.PostTodoReq) (types.Todo, error)
	Update(id int, updates types.PutTodoReq) (types.Todo, error)
	Delete(id int) (types.Todo, error)
}

var _ TodoRepository = (*StaticTodoRepository)(nil)

type StaticTodoRepository struct {
	todos []types.Todo
}

func NewStaticTodoRepository() *StaticTodoRepository {
	return &StaticTodoRepository{
		todos: []types.Todo{
			{
				ID:          1,
				Title:       "Task 1",
				Description: "Description for task 1",
				Completed:   true,
				DeadlineAt:  time.Now().AddDate(0, 0, 1),
				CreatedAt:   time.Now(),
				UpdatedAt:   time.Now(),
			},
			{
				ID:          2,
				Title:       "Task 2",
				Description: "Description for task 2",
				Completed:   false,
				DeadlineAt:  time.Now().AddDate(0, 0, 3),
				CreatedAt:   time.Now(),
				UpdatedAt:   time.Now(),
			},
			{
				ID:          3,
				Title:       "Task 3",
				Description: "Description for task 3",
				Completed:   false,
				DeadlineAt:  time.Now().AddDate(0, 0, 5),
				CreatedAt:   time.Now(),
				UpdatedAt:   time.Now(),
			},
		},
	}
}

func (r *StaticTodoRepository) GetAll() ([]types.Todo, error) {
	return r.todos, nil
}

func (r *StaticTodoRepository) GetByID(id int) (types.Todo, error) {
	for _, todo := range r.todos {
		if todo.ID == id {
			return todo, nil
		}
	}

	return types.Todo{}, errors.New("todo ID not found")
}

func (r *StaticTodoRepository) Create(postReq types.PostTodoReq) (types.Todo, error) {
	maxID := 0
	for _, t := range r.todos {
		if t.ID > maxID {
			maxID = t.ID
		}
	}

	now := time.Now()
	newTodo := types.Todo{
		ID:          maxID + 1,
		Title:       postReq.Title,
		Description: postReq.Description,
		Completed:   postReq.Completed,
		DeadlineAt:  postReq.DeadlineAt,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	r.todos = append(r.todos, newTodo)
	return newTodo, nil
}

func (r *StaticTodoRepository) Update(id int, updates types.PutTodoReq) (types.Todo, error) {
	for i, todo := range r.todos {
		if todo.ID == id {
			if updates.ID != nil {
				r.todos[i].ID = *updates.ID
			}

			if updates.Description != nil {
				r.todos[i].Description = *updates.Description
			}

			if updates.Completed != nil {
				r.todos[i].Completed = *updates.Completed
			}

			if updates.DeadlineAt != nil {
				r.todos[i].DeadlineAt = *updates.DeadlineAt
			}

			r.todos[i].UpdatedAt = time.Now()

			return r.todos[i], nil
		}
	}
	return types.Todo{}, errors.New("ID not found")
}

func (r *StaticTodoRepository) Delete(id int) (types.Todo, error) {
	for i, todo := range r.todos {
		if todo.ID == id {
			deleted := r.todos[i]
			r.todos = append(r.todos[:i], r.todos[i+1:]...)
			return deleted, nil
		}
	}

	return types.Todo{}, errors.New("todo not found")
}
