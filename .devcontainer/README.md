# VITA-1.5 Development Container

This development container provides a complete environment for running the VITA-1.5 multimodal AI model with web demo interface.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- NVIDIA GPU with CUDA support
- At least 16GB of available disk space for model files

### 1. Download the VITA Model
First, download the VITA-1.5 model to your host system:

```bash
cd .devcontainer
./download_model_host.sh
```

This will download the 16GB VITA-1.5 model to `../demo_VITA_ckpt/` on your host system.

### 2. Start the Development Container
```bash
docker compose up -d
```

### 3. Access the Web Demo
Open your browser and navigate to:
```
http://localhost:8081
```

## 📁 Project Structure

```
.devcontainer/
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Container build instructions
├── requirements.txt            # Python dependencies
├── start.sh                   # Container startup script
├── download_model_host.sh     # Model download script
├── download_and_install.sh    # Build-time data setup
└── README.md                  # This file

../demo_VITA_ckpt/             # VITA model files (downloaded by script)
../web_demo/                   # Web demo application
└── vllm_tools/
    ├── qwen2p5_model_weight_file/  # Model weight files
    └── vllm_file/                  # Custom vLLM integration files
```

## 🔧 Configuration

### Environment Variables
The container is configured with the following environment variables:
- `PYTHONUNBUFFERED=1` - Unbuffered Python output
- `PYTHONDONTWRITEBYTECODE=1` - Disable .pyc file generation
- `CUDA_HOME=/usr/local/cuda` - CUDA installation path
- `VLLM_USE_TRITON_FLASH_ATTN=0` - Disable Triton Flash Attention

### Volume Mounts
- `..:/workspace` - Project source code
- `../demo_VITA_ckpt:/workspace/demo_VITA_ckpt` - VITA model files

### Ports
- `8081:8081` - Web demo interface

## 🛠️ Development

### Rebuilding the Container
If you make changes to the Dockerfile or requirements:

```bash
docker compose down
docker compose up --build -d
```

### Viewing Logs
```bash
docker compose logs -f vita-web-demo
```

### Accessing the Container
```bash
docker exec -it vita-web-demo bash
```

### Stopping the Container
```bash
docker compose down
```

## 📦 What's Included

### Pre-installed Software
- **Python 3.10** with pip
- **CUDA 12.1** runtime
- **PyTorch 2.4.0** with CUDA support
- **vLLM 0.5.5** with custom multimodal support
- **Transformers 4.44.2**
- **Gradio 4.42.0** for web interface
- **OpenCV, NumPy, Pillow** for image processing
- **FFmpeg** for audio/video processing

### Custom Integrations
- **Custom vLLM Models**: Modified vLLM to support `Qwen2ForConditionalGeneration` for multimodal capabilities
- **VITA Model Support**: Pre-configured for VITA-1.5 model architecture
- **Silero VAD**: Voice Activity Detection models for audio processing

### Build-time Optimizations
- **Multi-stage build** for smaller image size
- **Layer caching** for faster rebuilds
- **Dependency conflict resolution** for stable installations
- **Custom vLLM integration** copied during build

## 🐛 Troubleshooting

### Common Issues

#### 1. Model Not Found Error
```
Demo model not found at /workspace/demo_VITA_ckpt
```
**Solution**: Run `./download_model_host.sh` to download the model first.

#### 2. CUDA Out of Memory
```
CUDA out of memory
```
**Solution**: Reduce `gpu_memory_utilization` in the server configuration or use a GPU with more memory.

#### 3. Port Already in Use
```
Port 8081 is already in use
```
**Solution**: Stop other services using port 8081 or change the port in `docker-compose.yml`.

#### 4. Permission Denied
```
Permission denied: /workspace/logs
```
**Solution**: The container will automatically create necessary directories with proper permissions.

### Debugging Commands

#### Check Container Status
```bash
docker compose ps
```

#### View Container Logs
```bash
docker compose logs vita-web-demo
```

#### Check GPU Access
```bash
docker exec vita-web-demo nvidia-smi
```

#### Test Python Environment
```bash
docker exec vita-web-demo python -c "import torch; print(torch.cuda.is_available())"
```

#### Verify vLLM Integration
```bash
docker exec vita-web-demo python -c "
import vllm.model_executor.models
print('Qwen2ForConditionalGeneration supported:', 'Qwen2ForConditionalGeneration' in vllm.model_executor.models._MULTIMODAL_MODELS)
"
```

## 🔄 Updates and Maintenance

### Updating Dependencies
1. Modify `requirements.txt` or `web_demo_requirements.txt`
2. Rebuild the container: `docker compose up --build -d`

### Updating the Model
1. Delete the old model: `rm -rf ../demo_VITA_ckpt`
2. Download the new model: `./download_model_host.sh`
3. Restart the container: `docker compose restart`

### Cleaning Up
```bash
# Remove containers and networks
docker compose down

# Remove images (optional)
docker rmi $(docker images -q vita-web-demo)

# Remove volumes (optional - will require re-downloading models)
docker volume prune
```

## 📚 Additional Resources

- [VITA-1.5 Model Documentation](https://huggingface.co/VITA-MLLM/VITA-1.5)
- [vLLM Documentation](https://docs.vllm.ai/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [CUDA Installation Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)

## 🤝 Contributing

When making changes to the development environment:

1. Test your changes locally
2. Update this README if needed
3. Ensure all scripts are executable
4. Verify the container builds and runs successfully

## 📄 License

This development container setup is part of the VITA-1.5 project. Please refer to the main project license for usage terms.
