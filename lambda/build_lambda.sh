#!/bin/bash
set -e  # Exit on error

# Change to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "Current working directory: $PWD"

# Cleanup
rm -rf lambda/lambda_build
mkdir -p lambda/lambda_build

# Install dependencies to build dir
pip install -r lambda/requirements.txt -t lambda/lambda_build/

# Copy source file
cp lambda/lambda_function.py lambda/lambda_build/

# Zip contents INTO the build folder
cd lambda/lambda_build
zip -r ../lambda_function.zip .
cd "$PROJECT_ROOT"

echo "Lambda deployment package created at lambda/lambda_build/lambda_function.zip"

