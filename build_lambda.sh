#!/bin/bash

# Cleanup old build
rm -rf lambda_build lambda.zip
mkdir lambda_build

# Install dependencies
pip install -r requirements.txt -t lambda_build/

# Copy function code
cp lambda_function.py lambda_build/

# Zip the contents
cd lambda_build
zip -r ../lambda_function.zip .
cd ..

echo "Lambda deployment package created: lambda_function.zip"
