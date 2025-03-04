#!/bin/bash

# Script to generate a test report
# Location: .CSSE6400/bin/generate_report.sh

# Set text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Generating Test Report...${NC}"

# Check if test results directory exists
if [ ! -d "test-results" ]; then
  echo -e "${RED}Test results directory not found${NC}"
  exit 1
fi

# Initialize the test report
echo "# API Test Report" > test-report.md
echo "" >> test-report.md
echo "Generated on: $(date)" >> test-report.md
echo "" >> test-report.md

# Add health test results
echo "## Health Endpoint Test" >> test-report.md
if [ -f "test-results/health.txt" ]; then
  HEALTH_RESULT=$(cat test-results/health.txt)
  if [ "$HEALTH_RESULT" == "PASS" ]; then
    echo "**Status: PASS** ✅" >> test-report.md
    HEALTH_SCORE=30
  else
    echo "**Status: FAIL** ❌" >> test-report.md
    HEALTH_SCORE=0
  fi
else
  echo "**Status: NOT RUN** ⚠️" >> test-report.md
  HEALTH_SCORE=0
fi
echo "" >> test-report.md

# Add todo test results
echo "## Todo CRUD Test" >> test-report.md
if [ -f "test-results/todo.txt" ]; then
  TODO_RESULT=$(cat test-results/todo.txt)
  if [ "$TODO_RESULT" == "PASS" ]; then
    echo "**Status: PASS** ✅" >> test-report.md
    TODO_SCORE=40
  else
    echo "**Status: FAIL** ❌" >> test-report.md
    TODO_SCORE=0
  fi
else
  echo "**Status: NOT RUN** ⚠️" >> test-report.md
  TODO_SCORE=0
fi
echo "" >> test-report.md

# Add structure test results
echo "## Project Structure Test" >> test-report.md
if [ -f "test-results/structure.txt" ]; then
  STRUCTURE_RESULT=$(cat test-results/structure.txt)
  if [ "$STRUCTURE_RESULT" == "PASS" ]; then
    echo "**Status: PASS** ✅" >> test-report.md
    STRUCTURE_SCORE=30
  else
    echo "**Status: FAIL** ❌" >> test-report.md
    STRUCTURE_SCORE=0
  fi
else
  echo "**Status: NOT RUN** ⚠️" >> test-report.md
  STRUCTURE_SCORE=0
fi
echo "" >> test-report.md

# Calculate total score
TOTAL_SCORE=$((HEALTH_SCORE + TODO_SCORE + STRUCTURE_SCORE))

# Add summary
echo "## Summary" >> test-report.md
echo "" >> test-report.md
echo "| Test | Status | Score |" >> test-report.md
echo "|------|--------|-------|" >> test-report.md
echo "| Health Endpoint | $HEALTH_RESULT | $HEALTH_SCORE/30 |" >> test-report.md
echo "| Todo CRUD | $TODO_RESULT | $TODO_SCORE/40 |" >> test-report.md
echo "| Project Structure | $STRUCTURE_RESULT | $STRUCTURE_SCORE/30 |" >> test-report.md
echo "| **Total** | | **$TOTAL_SCORE/100** |" >> test-report.md
echo "" >> test-report.md

# Add pass/fail status
if [ $TOTAL_SCORE -ge 70 ]; then
  echo "**Overall Status: PASS** ✅" >> test-report.md
  echo -e "${GREEN}Overall test status: PASS ($TOTAL_SCORE/100)${NC}"
else
  echo "**Overall Status: FAIL** ❌" >> test-report.md
  echo -e "${RED}Overall test status: FAIL ($TOTAL_SCORE/100)${NC}"
fi

# Clean up container if it exists
if docker ps -a | grep todo-api-test > /dev/null; then
  echo -e "${YELLOW}Cleaning up test container...${NC}"
  docker stop todo-api-test > /dev/null 2>&1
  docker rm todo-api-test > /dev/null 2>&1
fi

echo -e "${GREEN}Test report generated: test-report.md${NC}"

# Return appropriate exit code based on total score
if [ $TOTAL_SCORE -ge 70 ]; then
  exit 0
else
  exit 1
fi