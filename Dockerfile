FROM golang:1.23.6-alpine

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Add testify for testing
RUN go get github.com/stretchr/testify

# Copy source code
COPY . .

# Build the application
RUN go build -o app .

# Set environment variables
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./app"]
