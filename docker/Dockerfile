ARG OPENCLAW_VERSION=2026.4.26
ARG OMNIROUTE_VERSION=3.6.9
ARG MODELRELAY_VERSION=1.16.0
ARG OLLAMA_VERSION=0.21.0
ARG NODE_VERSION=24
ARG CODE_SERVER_VERSION=4.117.0

# Use the official Ollama image to get the binary
FROM ollama/ollama:${OLLAMA_VERSION} AS ollama-bin

# Get the binaries from official Node image
FROM node:${NODE_VERSION}-slim AS node-bin

# Use your preferred Webtop flavor as the base (e.g., Ubuntu, Alpine)
FROM lscr.io/linuxserver/webtop:ubuntu-mate

# Install help utilities and clean up apt cache to reduce image size
RUN apt-get update && apt-get install -y htop zsh && rm -rf /var/lib/apt/lists/*

# Copy Node.js binaries and libraries
COPY --from=node-bin --chown=abc:abc /usr/local/bin/node /usr/local/bin/
COPY --from=node-bin --chown=abc:abc /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Copy the Ollama binary from the official image
COPY --from=ollama-bin --chown=abc:abc /usr/bin/ollama /usr/local/bin/ollama

RUN mkdir -p /custom-cont-init.d
COPY --chown=abc:abc *.desktop /custom-cont-init.d
COPY --chown=abc:abc *.sh /custom-cont-init.d

ARG OPENCLAW_VERSION
RUN npm install -g openclaw@${OPENCLAW_VERSION} && \
    npm cache clean --force && \
    chown -R abc:abc /usr/local/lib/node_modules/openclaw /usr/local/bin/openclaw

# Install ModelRelay and start automatically when desktop loads
ARG MODELRELAY_VERSION
RUN npm install -g modelrelay@${MODELRELAY_VERSION} && \
    npm cache clean --force && \
    chown -R abc:abc /usr/local/lib/node_modules/modelrelay /usr/local/bin/modelrelay

# Install OmniRoute and start automatically when desktop loads
ARG OMNIROUTE_VERSION
RUN npm install -g omniroute@${OMNIROUTE_VERSION} && \
    npm cache clean --force && \
    chown -R abc:abc /usr/local/lib/node_modules/omniroute /usr/local/bin/omniroute

# Start Ollama to start automatically when the desktop loads,
RUN echo "runuser -l abc -c 'ollama serve &'" > /custom-cont-init.d/start-ollama.sh && \
   chmod +x /custom-cont-init.d/start-ollama.sh

# Empty folders with incorrect permissions
RUN rm -rf ~/.npm ~/.openclaw

# Install code-server (standalone) and set up shell
ARG CODE_SERVER_VERSION
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=${CODE_SERVER_VERSION} --method=standalone --prefix=/usr/local && \
    ln -fs /usr/local/lib/code-server-${CODE_SERVER_VERSION} /usr/local/lib/code-server && \
    ln -fs /usr/local/lib/code-server/bin/code-server /usr/local/bin/code-server && \
    rm -rf ~/.cache
COPY default.conf /defaults/default.conf

# Switch default shell to zsh for root and abc
RUN usermod -s $(which zsh) root; usermod -s $(which zsh) abc

EXPOSE 18789 20128 7352 8888
