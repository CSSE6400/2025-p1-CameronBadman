package types

type TodoRequest struct {
	completed bool `field:"completed"`
	window    int  `field:"window"`
}

type TodoResponse struct{}
