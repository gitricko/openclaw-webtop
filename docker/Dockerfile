ARG OPENCLAW_VERSION=2026.4.21
ARG OLLAMA_VERSION=0.21.0
ARG NODE_VERSION=24

# Use the official Ollama image to get the binary
FROM ollama/ollama:${OLLAMA_VERSION} AS ollama-bin

# Get the binaries from official Node image
FROM node:${NODE_VERSION}-slim AS node-bin

# Use your preferred Webtop flavor as the base (e.g., Ubuntu, Alpine)
FROM lscr.io/linuxserver/webtop:ubuntu-mate

# Copy Node.js binaries and libraries
COPY --from=node-bin --chown=abc:abc /usr/local/bin/node /usr/local/bin/
COPY --from=node-bin --chown=abc:abc /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Copy the Ollama binary from the official image
COPY --from=ollama-bin --chown=abc:abc /usr/bin/ollama /usr/local/bin/ollama

RUN npm install -g openclaw@${OPENCLAW_VERSION} && \
    chown -R abc:abc /usr/local/lib/node_modules/openclaw /usr/local/bin/openclaw
COPY --chown=abc:abc OpenClaw.desktop /custom-cont-init.d/OpenClaw.desktop
COPY --chown=abc:abc init-openclaw.sh /custom-cont-init.d/init-openclaw.sh

# Install ModelRelay and start automatically when desktop loads
RUN npm install -g modelrelay@${MODELRELAY_VERSION} && \
    chown -R abc:abc /usr/local/lib/node_modules/modelrelay /usr/local/bin/modelrelay
COPY --chown=abc:abc ModelRelay.desktop /custom-cont-init.d/ModelRelay.desktop
COPY --chown=abc:abc init-modelrelay.sh /custom-cont-init.d/init-modelrelay.sh
COPY --chown=abc:abc common.sh /custom-cont-init.d/common.sh

# Start Ollama to start automatically when the desktop loads,
RUN mkdir -p /custom-cont-init.d
RUN echo "runuser -l abc -c 'ollama serve &'" > /custom-cont-init.d/start-ollama.sh && \
   chmod +x /custom-cont-init.d/start-ollama.sh

COPY --chown=abc:abc init-openclaw.sh /custom-cont-init.d/init-openclaw.sh
