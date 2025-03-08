FROM golang:1.23.6-alpine AS build

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# Use a small alpine image for the final container
FROM alpine:3.18

WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /app/app .

# Set environment variables
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./app"]
