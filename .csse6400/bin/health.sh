#!/bin/bash

# Script to test the health endpoint of the Todo API
# Location: .CSSE6400/bin/health.sh

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create test results directory if it doesn't exist
mkdir -p test-results

echo -e "${YELLOW}Testing API Health Endpoint...${NC}"

# Start the container
echo -e "${YELLOW}Starting container...${NC}"
docker run -d -p 6400:6400 --name todo-api-test todo-api:test

# Wait for the API to start
echo -e "${YELLOW}Waiting for API to start...${NC}"
sleep 5

# Test the health endpoint
echo -e "${YELLOW}Testing /api/health endpoint...${NC}"
HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:6400/api/health)
HTTP_BODY=$(echo "$HEALTH_RESPONSE" | head -n 1)
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -n 1)

# Output result
echo -e "${YELLOW}Health endpoint response: $HTTP_BODY${NC}"
echo -e "${YELLOW}HTTP status code: $HTTP_CODE${NC}"

# Check if the test passed
if [[ "$HTTP_BODY" == *"ok"* ]] && [[ "$HTTP_CODE" == "200" ]]; then
  echo -e "${GREEN}✓ Health endpoint test passed!${NC}"
  echo "PASS" > test-results/health.txt
  exit 0
else
  echo -e "${RED}✗ Health endpoint test failed!${NC}"
  echo -e "${RED}Expected response containing 'ok' with status code 200${NC}"
  echo "FAIL" > test-results/health.txt
  
  # Don't stop the container yet, other tests will use it
  exit 1
fi