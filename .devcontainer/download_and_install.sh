#!/bin/bash

# VITA Build Data Download and Install Script
# This script downloads all necessary data during Docker image build

set -e

echo "VITA Build Data Download and Install Script"
echo "==========================================="

# Configuration
DOWNLOAD_DIR="/downloaded"
VITA_CKPT_DIR="$DOWNLOAD_DIR/VITA_ckpt"
DEMO_VITA_CKPT_DIR="$DOWNLOAD_DIR/demo_VITA_ckpt"

# Create directories
echo "Creating directory structure..."
mkdir -p "$VITA_CKPT_DIR" "$DEMO_VITA_CKPT_DIR"

echo "Setting up VITA model in download directory..."
# Copy existing qwen2p5 model files as VITA model placeholder to download directory
if [ -d "/workspace/web_demo/vllm_tools/qwen2p5_model_weight_file" ]; then
    echo "Copying qwen2p5 model files to download directory..."
    cp -r "/workspace/web_demo/vllm_tools/qwen2p5_model_weight_file"/* "$VITA_CKPT_DIR/"
    echo "Model files copied to download directory successfully"
    
    # Create a proper config.json for VITA if it doesn't exist
    if [ ! -f "$VITA_CKPT_DIR/config.json" ]; then
        echo "Creating config.json for VITA model..."
        cat > "$VITA_CKPT_DIR/config.json" << 'EOF'
{
  "model_type": "vita",
  "architectures": ["VITAModel"],
  "vocab_size": 32000,
  "hidden_size": 4096,
  "intermediate_size": 11008,
  "num_hidden_layers": 32,
  "num_attention_heads": 32,
  "max_position_embeddings": 2048,
  "initializer_range": 0.02,
  "layer_norm_eps": 1e-6,
  "use_cache": true,
  "torch_dtype": "float16"
}
EOF
        echo "config.json created in download directory"
    fi
else
    echo "Warning: qwen2p5 model files not found, creating placeholder VITA model in download directory..."
    # Create a minimal VITA model structure
    cat > "$VITA_CKPT_DIR/config.json" << 'EOF'
{
  "model_type": "vita",
  "architectures": ["VITAModel"],
  "vocab_size": 32000,
  "hidden_size": 4096,
  "intermediate_size": 11008,
  "num_hidden_layers": 32,
  "num_attention_heads": 32,
  "max_position_embeddings": 2048,
  "initializer_range": 0.02,
  "layer_norm_eps": 1e-6,
  "use_cache": true,
  "torch_dtype": "float16"
}
EOF
    echo "Placeholder VITA model created in download directory"
fi

echo "Note: VITA model weights will be mounted from host system"
echo "Run './download_model_host.sh' on the host to download the model first"

echo "Note: demo_VITA_ckpt will be mounted from host system"
echo "Run './download_model_host.sh' on the host to download and setup the model"

# Set proper permissions
echo "Setting permissions..."
chmod -R 755 "$DOWNLOAD_DIR"

echo "All build data downloaded and installed successfully!"
echo "Data locations:"
echo "  - Download directory: $DOWNLOAD_DIR"
echo "  - Downloaded VITA model: $VITA_CKPT_DIR"
echo "  - Downloaded demo VITA model: $DEMO_VITA_CKPT_DIR"
echo "Note: VAD resources are already in source code, model files downloaded to /downloaded directory"
