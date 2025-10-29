#!/bin/bash
echo "Building Study Buddy Docker image..."
docker build -t study-buddy:latest .
if [ $? -eq 0 ]; then
    echo "Build complete!"
else
    echo "Build failed!"
fi
