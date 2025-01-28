#!/bin/bash

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo"
    exit 1
fi

# Detect environment
IS_WSL=false
if grep -q "microsoft" /proc/version; then
    IS_WSL=true
    echo "WSL2 environment detected"
else
    echo "Native Linux environment detected"
fi

echo "Setting up NVIDIA Container Toolkit..."

# Install NVIDIA drivers and CUDA toolkit
apt update
if [ "$IS_WSL" = true ]; then
    apt install -y nvidia-cuda-toolkit
else
    # For native Linux, install nvidia-driver and cuda
    apt install -y nvidia-driver-535 nvidia-cuda-toolkit
fi

# Add NVIDIA Container Toolkit repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install the toolkit
apt update
apt install -y nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker

# Start/restart Docker service based on environment
if [ "$IS_WSL" = true ]; then
    service docker start || true
else
    systemctl restart docker
fi

echo "Testing GPU access..."
if ! docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi; then
    echo "GPU test failed. Please ensure:"
    if [ "$IS_WSL" = true ]; then
        echo "For WSL2:"
        echo "1. NVIDIA drivers are installed on Windows host"
        echo "2. WSL2 GPU support is enabled in Windows"
        echo "3. You've installed NVIDIA CUDA on Windows"
        echo "4. You've restarted your WSL2 instance"
    else
        echo "For Linux:"
        echo "1. NVIDIA drivers are properly installed"
        echo "2. NVIDIA modules are loaded (run 'nvidia-smi' to test)"
        echo "3. Docker service is running"
        echo "4. You may need to reboot your system"
    fi
    exit 1
fi

echo "GPU setup complete! You can now use GPU acceleration with Docker."