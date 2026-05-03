#!/bin/bash
# Test if imgs directory exists
if [ -d "imgs" ]; then
    echo "TEST PASSED: imgs directory exists."
    exit 0
else
    echo "TEST FAILED: imgs directory does not exist."
    exit 1
fi
