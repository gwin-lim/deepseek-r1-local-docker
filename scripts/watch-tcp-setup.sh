#!/bin/bash

# Create the logging chain if it doesn't exist
if ! sudo iptables -L DOCKER_LOGGING >/dev/null 2>&1; then
    sudo iptables -N DOCKER_LOGGING
    sudo iptables -A DOCKER_LOGGING -j LOG --log-prefix "Model Container: "
    sudo iptables -A DOCKER_LOGGING -j RETURN
fi

# Get container IPs
ollama_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' deepseek-ollama)
webui_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' deepseek-webui)

# Add logging rules for both containers
sudo iptables -I DOCKER-USER -s $ollama_ip -j DOCKER_LOGGING
sudo iptables -I DOCKER-USER -s $webui_ip -j DOCKER_LOGGING

echo "TCP monitoring configured for:"
echo "Ollama container IP: $ollama_ip"
echo "WebUI container IP: $webui_ip"

