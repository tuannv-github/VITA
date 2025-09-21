#!/bin/bash

# Stop any existing processes (ignore if stop.sh doesn't exist)
./stop.sh 2>/dev/null || true

# Start the server
cd /workspace/
echo "Starting VITA-1.5 web demo server..."

echo "Starting VITA web demo server..."
python -m web_demo.server --port 8081 --ip 0.0.0.0 --model_path /workspace/demo_VITA_ckpt 2>&1 | tee logs/web_demo.log 
