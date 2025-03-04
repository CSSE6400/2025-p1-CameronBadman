#!/bin/bash
#
# Validate the structure of the Go repository

# Flag to track if any errors were found
errors=0

# Check for required Go files and directories
check_file() {
    if [ ! -f "$1" ] && [ ! -d "$1" ]; then
        echo "FAIL: Missing $1"
        errors=1
    fi
}

# Check for Go module files
check_file "go.mod"
check_file "go.sum"

# Check for main.go
check_file "main.go"

# Check for handlers directory
check_file "handlers"

# Check for model directory
check_file "model"

# Return success or failure
if [ $errors -eq 0 ]; then
    echo "Repository structure is valid."
    exit 0
else
    echo "Repository structure is not valid. Please fix the errors above."
    exit 1
fi