#!/bin/bash
#
# Run tests against the Go API using a Python virtual environment

echo "Setting up test environment..."

# Copy test files
cp -r .csse6400/tests .

# Start the Go API in the background
echo "Building and starting Go API..."
go build -o app
PORT=6400 ./app &
api_pid=$!

# Check for errors
if [[ $? -ne 0 ]]; then
    echo "Failed to build or start Go API"
    exit 1
fi

# Wait for API to initialize
echo "Waiting for API to start..."
sleep 5

# Set up Python environment and run tests
echo "Setting up Python environment..."

# Install requests library directly
echo "Installing requests library..."
pip3 install requests || pip install requests

# If that fails, try with --user flag
if [ $? -ne 0 ]; then
    echo "Installing requests library with --user flag..."
    pip3 install --user requests || pip install --user requests
    
    # If that still fails, provide an error message
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install the requests library. Tests cannot run without it."
        kill $api_pid
        exit 1
    fi
fi

echo "Successfully installed requests library."

# Run tests with the system Python
echo "Running tests against Go API..."
if command -v python3 &> /dev/null; then
    python3 -m unittest discover -s tests
elif command -v python &> /dev/null; then
    python -m unittest discover -s tests
else
    echo "Python not found. Please install Python to run tests."
    kill $api_pid
    exit 1
fi
test_result=$?

# Kill Go API regardless of test result
echo "Stopping Go API..."
kill $api_pid

# Return the test result
if [[ $test_result -ne 0 ]]; then
    echo "Tests failed"
    exit 1
else
    echo "All tests passed"
    exit 0
fi