#!/bin/bash

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "This script is only needed for Linux. On Windows/macOS, GPU support is handled by Docker Desktop."
    exit 0
fi

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo"
    exit 1
fi

echo "Setting up NVIDIA Container Toolkit..."

# Add NVIDIA Container Toolkit repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install the toolkit
apt update
apt install -y nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker

# Restart Docker
systemctl restart docker

echo "Testing GPU access..."
if ! docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi; then
    echo "GPU test failed. Please check your NVIDIA drivers and Docker installation."
    exit 1
fi

echo "GPU setup complete! You can now use GPU acceleration with Docker."