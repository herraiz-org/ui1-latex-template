#!/bin/bash
# Test if imgs directory exists
if [ ! -d "imgs" ]; then
    echo "TEST FAILED: imgs directory does not exist."
    exit 1
fi

# Test if images are in imgs directory
if [ -f "imgs/portada.png" ] && [ -f "imgs/interior.png" ]; then
    echo "TEST PASSED: Images are in imgs directory."
else
    echo "TEST FAILED: Images are NOT in imgs directory."
    exit 1
fi

# Test if images are removed from root
if [ -f "portada.png" ] || [ -f "interior.png" ]; then
    echo "TEST FAILED: Images still exist in root directory."
    exit 1
else
    echo "TEST PASSED: Images removed from root directory."
fi

exit 0
