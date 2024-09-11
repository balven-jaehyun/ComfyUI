# Stage 1: Base image with common dependencies
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libxrender1 \
    git-lfs

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /comfyui

# Change working directory to ComfyUI
WORKDIR /comfyui
ADD requirements.txt .

# Install ComfyUI dependencies
RUN pip3 install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 \
    && pip3 install --upgrade -r requirements.txt

WORKDIR /comfyui/custom_nodes
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git

RUN git clone https://github.com/chflame163/ComfyUI_LayerStyle
WORKDIR /comfyui/custom_nodes/ComfyUI_LayerStyle
RUN rm -f requirements.txt

# Go back to the root
WORKDIR /

# Start the container
CMD ["python3", "/comfyui/main.py", "--listen", "--disable-auto-launch", "--disable-metadata"]