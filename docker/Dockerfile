ARG OPENCLAW_VERSION=2026.3.13
ARG OLLAMA_VERSION=0.18.2
ARG NODE_VERSION=22

# Use the official Ollama image to get the binary
FROM ollama/ollama:${OLLAMA_VERSION} AS ollama-bin

# Get the binaries from official Node image
FROM node:${NODE_VERSION}-slim AS node-bin

# Use your preferred Webtop flavor as the base (e.g., Ubuntu, Alpine)
FROM lscr.io/linuxserver/webtop:ubuntu-mate

# Copy Node.js binaries and libraries
COPY --from=node-bin /usr/local/bin/node /usr/local/bin/
COPY --from=node-bin /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN chmod +rw /usr/local/lib/node_modules -R
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Copy the Ollama binary from the official image
COPY --from=ollama-bin /usr/bin/ollama /usr/local/bin/ollama

# Start Ollama to start automatically when the desktop loads,
RUN mkdir -p /custom-cont-init.d
RUN echo 'ollama serve &' > /custom-cont-init.d/start-ollama.sh && \
   chmod +x /custom-cont-init.d/start-ollama.sh

RUN npm install -g openclaw@${OPENCLAW_VERSION}

EXPOSE 11434

