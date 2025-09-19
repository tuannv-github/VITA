# Use NVIDIA CUDA base image with Python 3.10
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Set environment variables for VITA model and vLLM
ENV VLLM_USE_TRITON_FLASH_ATTN=0
ENV VLLM_ATTENTION_BACKEND=XFORMERS
ENV CUDA_VISIBLE_DEVICES="0"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3-pip \
    python3-setuptools \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    vim \
    nano \
    htop \
    tree \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    ffmpeg \
    libsndfile1 \
    libsndfile1-dev \
    portaudio19-dev \
    libasound2-dev \
    libpulse-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgcc-s1 \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python
RUN ln -s /usr/bin/python3.10 /usr/bin/python || ln -s /usr/bin/python3.10 /usr/bin/python3 || true

# Upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel

# Install PyTorch with CUDA support first (this is critical for proper CUDA detection)
# Use consistent versions with web_demo_requirements.txt
RUN pip install torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu121

# Install other core dependencies
RUN pip install \
    numpy==1.26.4 \
    pillow \
    tqdm \
    Jinja2 \
    ninja \
    accelerate \
    deepspeed \
    transformers==4.44.2 \
    decord==0.6.0 \
    xformers==0.0.27.post2

# Install flash-attn (this needs to be done separately due to compilation requirements)
RUN pip install flash-attn --no-build-isolation

# Install additional system packages that might be needed
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Set the default user
USER $USERNAME

# Set working directory
WORKDIR /workspace

# Set environment variables for the user
ENV HOME=/home/$USERNAME
ENV USER=$USERNAME

# Install setuptools first to fix pyairports deprecation warning
RUN pip install "setuptools<81"

# Install pyairports and outlines first to resolve vllm dependencies
RUN pip install "git+https://github.com/NICTA/pyairports.git#egg=pyairports"
RUN pip install "outlines>=0.0.43,<0.1"

# Copy the web demo requirements file
COPY web_demo/web_demo_requirements.txt /tmp/web_demo_requirements.txt

# Install additional Python requirements for the web demo with conflict resolution
RUN pip install -r /tmp/web_demo_requirements.txt

# Install local requirements with conflict resolution
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Set the default command
CMD ["/bin/bash"]
