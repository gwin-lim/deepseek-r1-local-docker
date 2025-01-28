#!/bin/bash

# Start Ollama service
ollama serve &

# Wait for Ollama to start
sleep 5

MODEL="deepseek-r1:${MODEL_SIZE}"

# Check if model exists in volume before pulling
if ! ollama list | grep -q "$MODEL"; then
    echo "Model not found, pulling $MODEL..."
    ollama pull "$MODEL"
else
    echo "Model already exists in volume, skipping pull"
fi

# Keep container running
tail -f /dev/null