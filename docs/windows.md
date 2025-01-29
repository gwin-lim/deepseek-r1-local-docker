# Windows Setup Guide

This guide covers setting up DeepSeek R1 Local on Windows, both with and without GPU support.

**Note:** Commands may need to be run with `sudo` if you are not in the docker group.

## Setup Options

### Option 1: CPU-Only (Native Windows)

1. Install Docker Desktop for Windows:
   - Download from [Docker's official website](https://www.docker.com/products/docker-desktop)
   - Run the installer and follow the prompts
   - You do not need to enable WSL2 integration for CPU-only usage

2. Start the containers:
```bash
docker compose up -d
```

### Option 2: GPU Support (WSL2)

#### Prerequisites
- NVIDIA GPU with updated drivers
- Windows 10/11 with WSL2 enabled
- Ubuntu installed in WSL2

#### Setup Steps

1. Enable WSL2:
```powershell
wsl --install
```

2. Install Make utility:
```bash
sudo apt-get install make
```

3. Install Docker and Docker Compose in WSL2:
```bash
make install-docker
```

4. Install NVIDIA Container Toolkit in WSL2:
```bash
make setup-gpu
```
    If successful, you should see something like the following, if not, see [Troubleshooting](#troubleshooting):
    ![GPU Test](../images/gpu-test.png)

5. Start the containers with GPU support:
```bash
docker compose -f docker-compose.yml -f docker-compose.gpu.yml -f docker-compose.windows.yml up -d
```

## Troubleshooting

### CPU-Only (Docker Desktop)
1. If containers fail to start:
   - Check Docker Desktop is running
   - Ensure you have enough memory allocated in Docker Desktop settings
   - Try restarting Docker Desktop

### GPU Support (WSL2)
1. If GPU is not detected:
   - Ensure you have the latest NVIDIA drivers installed in Windows
   - Check if WSL2 can see the GPU:
     ```bash
     nvidia-smi
     ```
   - If nvidia-smi fails, try updating WSL2:
     ```powershell
     wsl --update
     ```

2. If Docker can't access the GPU:
   - Check if the Docker daemon is running:
     ```bash
     sudo systemctl status docker
     ```
   - Verify NVIDIA Container Toolkit installation:
     ```bash
     nvidia-ctk --version
     ```
   - Restart the Docker daemon:
     ```bash
     sudo systemctl restart docker
     ```

## Performance Notes

- WSL2 generally provides better performance than native Windows, even for CPU-only workloads
- The first startup will be slower due to model download (1.1GB for default model)
- Models are stored in the `ollama-models` Docker volume and persist between restarts