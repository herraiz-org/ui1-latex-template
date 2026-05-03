#!/bin/bash
# Test if plantilla.tex uses imgs/portada and imgs/interior
if grep -q "{imgs/portada}" plantilla.tex && grep -q "{imgs/interior}" plantilla.tex; then
    echo "TEST PASSED: plantilla.tex updated."
else
    echo "TEST FAILED: plantilla.tex NOT updated."
    exit 1
fi

# Test if Makefile uses imgs/portada.png and imgs/interior.png
if grep -q "imgs/portada.png" Makefile && grep -q "imgs/interior.png" Makefile; then
    echo "TEST PASSED: Makefile updated."
else
    echo "TEST FAILED: Makefile NOT updated."
    exit 1
fi

exit 0
