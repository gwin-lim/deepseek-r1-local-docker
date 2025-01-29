# macOS Setup Guide

This guide covers setting up DeepSeek R1 Local on macOS, including both CPU and GPU (Metal) support.

## Prerequisites

- macOS 10.15 or later
- Apple Silicon (M1/M2/M3) or Intel processor

## Setup Steps

1. Install Docker Desktop for macOS:
   - Download from [Docker's official website](https://www.docker.com/products/docker-desktop)
   - For Apple Silicon Macs, ensure you download the Apple Silicon version
   - Follow the installer prompts
   - Start Docker Desktop and wait for it to complete initialization

2. Install make (if not already installed):
   - Using Homebrew (recommended):
     ```bash
     brew install make
     ```
   - Or using Xcode Command Line Tools:
     ```bash
     xcode-select --install
     ```

3. Start the service:

   For CPU-only:
   ```bash
   docker compose up -d
   ```

   For GPU (Metal) support:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.mac.yml up -d
   ```

## Performance Notes

### Apple Silicon (M1/M2/M3)
- Native arm64 support provides excellent performance
- GPU acceleration via Metal is available out of the box
- Memory usage is typically lower than on Intel Macs

### Intel Macs
- CPU-only operation
- May experience higher memory usage
- Consider resource limits in Docker Desktop settings

## Troubleshooting

1. If Docker fails to start:
   - Check Docker Desktop is running
   - Ensure you have enough memory allocated in Docker Desktop settings
   - Try restarting Docker Desktop

2. For performance issues:
   - In Docker Desktop, adjust memory and CPU allocation:
     - Go to Preferences → Resources
     - Recommended minimum: 8GB RAM, 4 CPUs
   - Check activity monitor for resource usage

3. For Metal acceleration issues (Apple Silicon):
   - Ensure macOS is updated to the latest version
   - Check Docker Desktop settings for GPU support
   - Verify Metal support:
     ```bash
     docker run --rm -it --platform linux/arm64 ubuntu:latest apt-get update && apt-get install -y clinfo && clinfo
     ```
