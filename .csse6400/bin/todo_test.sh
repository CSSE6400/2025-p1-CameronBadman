#!/bin/bash

# Script to test the Todo CRUD operations of the Todo API
# Location: .CSSE6400/bin/todo_test.sh

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create test results directory if it doesn't exist
mkdir -p test-results

echo -e "${YELLOW}Testing Todo CRUD Operations...${NC}"

# Check if container is running, start if needed
if ! docker ps | grep todo-api-test > /dev/null; then
  echo -e "${YELLOW}Starting container...${NC}"
  docker run -d -p 6400:6400 --name todo-api-test todo-api:test
  echo -e "${YELLOW}Waiting for API to start...${NC}"
  sleep 5
fi

# Create a new todo
echo -e "${YELLOW}Testing POST /api/todos (Create)...${NC}"
CREATE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Todo","description":"Testing the API","completed":false,"deadline":"2023-12-31"}' \
  http://localhost:6400/api/todos)

CREATE_BODY=$(echo "$CREATE_RESPONSE" | head -n 1)
CREATE_CODE=$(echo "$CREATE_RESPONSE" | tail -n 1)

echo -e "${YELLOW}Create response: $CREATE_BODY${NC}"
echo -e "${YELLOW}Create status code: $CREATE_CODE${NC}"

# Extract the todo ID if possible
TODO_ID=$(echo $CREATE_BODY | grep -o '"id":[0-9]*' | grep -o '[0-9]*' || echo "")
if [[ -n "$TODO_ID" ]]; then
  echo -e "${YELLOW}Created Todo ID: $TODO_ID${NC}"
else
  echo -e "${RED}Could not extract Todo ID from response${NC}"
fi

# Get all todos
echo -e "${YELLOW}Testing GET /api/todos (List)...${NC}"
GET_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:6400/api/todos)
GET_BODY=$(echo "$GET_RESPONSE" | head -n 1)
GET_CODE=$(echo "$GET_RESPONSE" | tail -n 1)

echo -e "${YELLOW}Get all response: $GET_BODY${NC}"
echo -e "${YELLOW}Get all status code: $GET_CODE${NC}"

# Test Get single todo if we have an ID
if [[ -n "$TODO_ID" ]]; then
  echo -e "${YELLOW}Testing GET /api/todos/$TODO_ID (Get One)...${NC}"
  GET_ONE_RESPONSE=$(curl -s -w "\n%{http_code}" http://localhost:6400/api/todos/$TODO_ID)
  GET_ONE_BODY=$(echo "$GET_ONE_RESPONSE" | head -n 1)
  GET_ONE_CODE=$(echo "$GET_ONE_RESPONSE" | tail -n 1)
  
  echo -e "${YELLOW}Get one response: $GET_ONE_BODY${NC}"
  echo -e "${YELLOW}Get one status code: $GET_ONE_CODE${NC}"
else
  GET_ONE_CODE="N/A"
fi

# Determine if the test passed
if [[ "$CREATE_CODE" == "2"* ]] && [[ "$GET_CODE" == "200" ]] && 
   [[ -n "$TODO_ID" ]] && [[ "$GET_ONE_CODE" == "200" || "$GET_ONE_CODE" == "N/A" ]]; then
  echo -e "${GREEN}✓ Todo CRUD test passed!${NC}"
  echo "PASS" > test-results/todo.txt
  exit 0
else
  echo -e "${RED}✗ Todo CRUD test failed!${NC}"
  echo "FAIL" > test-results/todo.txt
  exit 1
fi