#!/bin/bash

# Kill any existing web_demo and multiprocessing processes
echo "Killing existing web_demo and multiprocessing processes..."
pkill -f "web_demo" || true
pkill -f "multiprocessing" || true
sleep 1

# Verify all processes are killed
echo "Checking for remaining processes..."
if ps -ef | grep -E "(web_demo|multiprocessing)" | grep -v grep; then
    echo "Warning: Some processes still running, force killing..."
    pkill -9 -f "web_demo" || true
    pkill -9 -f "multiprocessing" || true
    sleep 2
fi
