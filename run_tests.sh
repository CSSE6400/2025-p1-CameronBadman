#!/bin/bash

# Setup Go environment
echo "Setting up Go environment..."
go mod tidy

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create results folder
mkdir -p test_results

# Function to run a test and report results
run_test() {
    test_name=$1
    test_script=$2
    
    echo "Running $test_name test..."
    
    # Run the test and capture output
    output=$($test_script 2>&1)
    exit_code=$?
    
    # Save output to file
    echo "$output" > "test_results/${test_name}.log"
    
    # Display result
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ $test_name passed${NC}"
        echo "$output" | tail -5
        return 0
    else
        echo -e "${RED}✗ $test_name failed${NC}"
        echo "$output" | tail -10
        return 1
    fi
}

# Ensure scripts are executable
chmod +x ./.csse6400/bin/*.sh

# Run all tests
echo "Starting tests..."

passed=0
total=4

run_test "Health Endpoint" ./.csse6400/bin/health.sh
[ $? -eq 0 ] && ((passed++))

run_test "Clean Git Repository" ./.csse6400/bin/clean_repository.sh
[ $? -eq 0 ] && ((passed++))

run_test "Todo Endpoints" ./.csse6400/bin/unittest.sh
[ $? -eq 0 ] && ((passed++))

run_test "Project Structure" ./.csse6400/bin/validate_structure.sh
[ $? -eq 0 ] && ((passed++))

# Summary
echo ""
echo "Test Summary: $passed/$total tests passed"

if [ $passed -eq $total ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. Check test_results directory for details.${NC}"
    exit 1
fi