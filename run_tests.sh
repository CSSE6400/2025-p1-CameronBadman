#!/bin/bash
# Test runner script for API testing

set -e  # Exit immediately if a command exits with a non-zero status

echo "🚀 Starting test environment..."

# Start the services using docker-compose
echo "📦 Starting services with Docker Compose..."
docker-compose -f docker-compose.yml up -d --build

# Wait for services to be ready
echo "⏳ Waiting for API to be ready..."
timeout 30 bash -c 'until curl -s http://localhost:8080/api/v1/health > /dev/null; do sleep 1; echo -n "."; done' || (docker-compose -f docker-compose.test.yml logs api && exit 1)
echo "✅ API is ready!"

# Run the tests inside the test container
echo "🧪 Running tests..."
docker-compose -f docker-compose.yml exec test go test -v ./tests/...

# Capture the exit code
TEST_EXIT_CODE=$?

# Always clean up
echo "🧹 Cleaning up containers..."
docker-compose -f docker-compose.yml down

# Exit with the test exit code
echo "🏁 Test completed with exit code: $TEST_EXIT_CODE"
exit $TEST_EXIT_CODE
