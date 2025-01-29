FROM ollama/ollama:0.5.7

# Create app directory
WORKDIR /app

# Copy entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]