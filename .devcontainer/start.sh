#!/bin/bash

./stop.sh

# Start the server
cd /workspace/
echo "Starting VITA-1.5 web demo server..."

python -m web_demo.server --port 8081 --ip 0.0.0.0 --model_path /workspace/demo_VITA_ckpt > logs/web_demo.log 2>&1
