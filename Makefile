.PHONY: setup-gpu test-gpu

setup-gpu:
	@sudo ./scripts/setup-gpu.sh

install-docker:
	@sudo ./scripts/install-docker.sh

test-gpu:
	@docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi

docker-up-linux-gpu:
	@sudo docker compose -f docker-compose.yml -f docker-compose.gpu.yml up -d

docker-up-mac-gpu:
	@sudo docker compose -f docker-compose.yml -f docker-compose.mac.yml up -d

docker-up-windows-gpu:
	@sudo docker compose -f docker-compose.yml -f docker-compose.gpu.yml -f docker-compose.windows.yml up -d

docker-up-cpu-only:
	@sudo docker compose up -d

watch-gpu:
	@watch -n 0.5 nvidia-smi
