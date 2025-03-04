#!/bin/bash

# Script to validate the project structure
# Location: .CSSE6400/bin/structure_test.sh

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create test results directory if it doesn't exist
mkdir -p test-results

echo -e "${YELLOW}Testing Project Structure...${NC}"

# Required files
REQUIRED_FILES=(
  "Dockerfile"
  "go.mod"
  "go.sum"
  "main.go"
)

# Required directories
REQUIRED_DIRS=(
  "types"
  "handlers"
  "model"
)

# Check for required files
MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo -e "${RED}✗ Missing required file: $file${NC}"
    MISSING_FILES=$((MISSING_FILES + 1))
  else
    echo -e "${GREEN}✓ Found required file: $file${NC}"
  fi
done

# Check for required directories
MISSING_DIRS=0
for dir in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    echo -e "${RED}✗ Missing required directory: $dir${NC}"
    MISSING_DIRS=$((MISSING_DIRS + 1))
  else
    echo -e "${GREEN}✓ Found required directory: $dir${NC}"
  fi
done

# Check for Dockerfile configuration
if [ -f "Dockerfile" ]; then
  # Check if Dockerfile exposes port 6400
  if grep -q "EXPOSE 6400" Dockerfile; then
    echo -e "${GREEN}✓ Dockerfile exposes port 6400${NC}"
  else
    echo -e "${RED}✗ Dockerfile does not expose port 6400${NC}"
    MISSING_FILES=$((MISSING_FILES + 1))
  fi
fi

# Determine if the test passed
if [ $MISSING_FILES -eq 0 ] && [ $MISSING_DIRS -eq 0 ]; then
  echo -e "${GREEN}✓ Project structure test passed!${NC}"
  echo "PASS" > test-results/structure.txt
  exit 0
else
  echo -e "${RED}✗ Project structure test failed!${NC}"
  echo -e "${RED}Missing $MISSING_FILES files and $MISSING_DIRS directories${NC}"
  echo "FAIL" > test-results/structure.txt
  exit 1
fi