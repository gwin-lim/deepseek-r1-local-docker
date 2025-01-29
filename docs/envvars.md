# Environment Variables

These environment variables can be used to configure the service. You can set these in your environment, in a `.env` file, or directly in the docker compose command.

## Model Configuration
- `MODEL_SIZE`: Size of the DeepSeek model to use (default: "1.5b")
  ```bash
  MODEL_SIZE=8b docker compose up -d
  ```

  Full list of models: https://ollama.ai/models

## Container Names
- `OLLAMA_CONTAINER_NAME`: Custom name for the Ollama container (default: "deepseek-ollama")
- `WEBUI_CONTAINER_NAME`: Custom name for the Web UI container (default: "deepseek-webui")

## Port Configuration
- `OLLAMA_PORT`: Port for Ollama API (default: "11434")
- `WEBUI_PORT`: Port for the web interface (default: "8080")
  ```bash
  WEBUI_PORT=3000 OLLAMA_PORT=11435 docker compose up -d
  ```

## Web UI Settings
- `ENVIRONMENT`: Environment setting for Web UI (default: "prod")
- `OLLAMA_BASE_URL`: URL for Ollama API connection (default: "http://ollama:11434")

## Telemetry Settings
- `SCARF_NO_ANALYTICS`: Disable Scarf analytics (default: "true")
- `DO_NOT_TRACK`: Enable Do Not Track (default: "true")
- `ANONYMIZED_TELEMETRY`: Enable anonymized telemetry (default: "false")

Example using multiple variables:
```bash
MODEL_SIZE=8b WEBUI_PORT=3000 OLLAMA_CONTAINER_NAME=my-ollama docker compose up -d
```
