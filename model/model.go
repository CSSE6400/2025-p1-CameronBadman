package model

import (
	"context"
	"fmt"
	"os"
	"time"

	"todo/types"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type TodoRepository interface {
	GetAll() ([]types.Todo, error)
	GetByID(id int) (types.Todo, error)
	Create(postReq types.PostTodoReq) (types.Todo, error)
	Update(id int, updates types.PutTodoReq) (types.Todo, error)
	Delete(id int) (types.Todo, error)
}

var _ TodoRepository = (*MongoTodoReposity)(nil)

type MongoTodoReposity struct {
	client *mongo.Client
}

func NewMongoTodoReposity() (*MongoTodoReposity, error) {
	// Get MongoDB URI from environment variable, with fallback to localhost
	mongoURI := os.Getenv("MONGO_URI")
	if mongoURI == "" {
		mongoURI = "mongodb://localhost:27017"
	}

	// Connect to MongoDB using the URI from environment
	client, err := mongo.Connect(context.Background(), options.Client().ApplyURI(mongoURI))
	if err != nil {
		return nil, err
	}

	// Validate connection with ping
	err = client.Ping(context.Background(), nil)
	if err != nil {
		return nil, err
	}

	return &MongoTodoReposity{
		client: client,
	}, nil
}

func (r *MongoTodoReposity) GetAll() ([]types.Todo, error) {
	collection := r.client.Database("todoDB").Collection("todos")
	ctx := context.Background()

	cursor, err := collection.Find(ctx, bson.M{})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var todos []types.Todo
	if err := cursor.All(ctx, &todos); err != nil {
		return nil, err
	}

	return todos, nil
}

func (r *MongoTodoReposity) GetByID(id int) (types.Todo, error) {
	collection := r.client.Database("todoDB").Collection("todos")
	ctx := context.Background()
	filter := bson.M{"_id": id}

	var todo types.Todo
	err := collection.FindOne(ctx, filter).Decode(&todo)
	if err != nil {
		return types.Todo{}, err
	}

	return todo, nil
}

func (r *MongoTodoReposity) Create(postReq types.PostTodoReq) (types.Todo, error) {
	collection := r.client.Database("todoDB").Collection("todos")
	ctx := context.Background()

	// Find the highest ID
	var highestTodo types.Todo
	opts := options.FindOne().SetSort(bson.D{{Key: "_id", Value: -1}})

	err := collection.FindOne(ctx, bson.D{}, opts).Decode(&highestTodo)

	nextID := 1
	if err == nil {
		nextID = highestTodo.ID + 1
	} else if err != mongo.ErrNoDocuments {
		return types.Todo{}, err
	}

	now := time.Now()
	newTodo := types.Todo{
		ID:          nextID,
		Title:       postReq.Title,
		Description: postReq.Description,
		Completed:   *postReq.Completed,
		DeadlineAt:  postReq.DeadlineAt,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	_, err = collection.InsertOne(ctx, newTodo)
	if err != nil {
		return types.Todo{}, err
	}

	return newTodo, nil
}

func (r *MongoTodoReposity) Update(id int, updates types.PutTodoReq) (types.Todo, error) {
	collection := r.client.Database("todoDB").Collection("todos")
	updateDoc := bson.M{}

	if updates.Title != nil {
		updateDoc["title"] = *updates.Title
	}

	if updates.Description != nil {
		updateDoc["description"] = *updates.Description
	}

	if updates.Completed != nil {
		updateDoc["completed"] = *updates.Completed
	}

	if updates.DeadlineAt != nil {
		updateDoc["deadlint_at"] = *updates.DeadlineAt
	}

	update := bson.M{"$set": updateDoc}

	opts := options.FindOneAndUpdate().SetReturnDocument(options.After)

	var updatedTodo types.Todo
	err := collection.FindOneAndUpdate(
		context.Background(),
		bson.M{"_id": id},
		update,
		opts,
	).Decode(&updatedTodo)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return types.Todo{}, fmt.Errorf("todo with id %d not found", id)
		}
		return types.Todo{}, err
	}

	return updatedTodo, nil
}

func (r *MongoTodoReposity) Delete(id int) (types.Todo, error) {
	collection := r.client.Database("todoDB").Collection("todos")
	ctx := context.Background()
	filter := bson.M{"_id": id}

	var deletedTodo types.Todo
	result := collection.FindOneAndDelete(ctx, filter)
	if err := result.Err(); err != nil {
		if err == mongo.ErrNoDocuments {
			return types.Todo{}, err
		}
		return types.Todo{}, err
	}

	if err := result.Decode(&deletedTodo); err != nil {
		return types.Todo{}, err
	}

	return deletedTodo, nil
}
