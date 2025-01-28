.PHONY: setup-gpu test-gpu

setup-gpu:
	@chmod +x scripts/setup_gpu.sh
	@sudo ./scripts/setup_gpu.sh

test-gpu:
	@docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
