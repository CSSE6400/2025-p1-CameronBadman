#!/bin/bash
#
# Check that the health endpoint is returning 200

echo "Starting Go application..."

# Build and start Go app in the background with PORT environment variable
go build -o app
PORT=6400 ./app &
pid=$!

# Check for errors in the build/start process
if [[ $? -ne 0 ]]; then
    echo "Failed to build or start Go application"
    exit 1
fi

echo "Go application started with PID: $pid"

# Wait for the application to initialize
echo "Waiting for application to start..."
sleep 5

# Check that the health endpoint is returning 200
echo "Testing health endpoint..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:6400/api/v1/health)
if [[ $response -ne 200 ]]; then
    echo "Failed to get 200 from health endpoint (got $response)"
    # Kill Go app before exiting
    kill $pid
    exit 1
fi

echo "Health endpoint responded with 200 OK"

# Kill Go app
echo "Stopping Go application..."
kill $pid

echo "Test passed successfully"
exit 0