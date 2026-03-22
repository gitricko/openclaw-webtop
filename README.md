# 🦞 OpenClaw — Web Top

<p align="center">
    <picture>
        <img width="703" height="344" alt="openclaw-webtop-title-logo" src="./docs/openclaw-webtop-title-logo.png" />
    </picture>
</p>

<p align="center">
  <strong>Brew your lobster securely without breaking your bank</strong>
</p>

<p align="center">
[![Last Docker Image Push](https://github.com/gitricko/openclaw-webtop/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/gitricko/openclaw-webtop/actions/workflows/docker-publish.yml)
[![License](https://img.shields.io/github/license/gitricko/openclaw-webtop)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/gitricko/openclaw-webtop)](https://github.com/gitricko/openclaw-webtop/issues)
</p>

**OpenClaw-WebTop** runs OpenClaw securely with a need for a dedicate computer. When you are ready, you can move to your own machine docker environment if you would like.

## Prequisite
- Account with [Ollama](https://signin.ollama.com/) so that you can use an cloud based model for free with your daily free credits
- Account with [NVIDIA Build](https://build.nvidia.com/) so that you can switch NVDIA free API as backup

## Quick start (TL;DR)

- Open this repository in a GitHub Codespace
- In the Codespace terminal run: `make start`. This will start a webtop OS that is accessible in the browser with ollama and openclaw pre-installed
- Wait for the OpenClaw WebTop docker to boot. When the web desktop URL appears in the Codespace `Ports` Tab, click it to open the webtop in a new browser.
<img width="703" alt="launch-webtop-via-ports" src="./docs/launch-webtop-via-ports.png" />

- In the webtop, open a terminal, run `ollama signin` and sign in via the chrome browser
<img width="703" alt="ollama-signin" src="./docs/ollama-signin.png" />

- Test connectivity via `ollama pull kimi-k2.5:cloud`
- Open another terminal and run `ollama launch openclaw --model kimi-k2.5:cloud`
- Follow the instructions till completion
- In the webtop, open a chromium browser and check if you can access this URI: http://localhost:127.0.0.1
- If it does not work: run `openclaw gateway run`
- When the URL is working, run `openclaw dashboard` it will give you to URI with a token at the end.

<!--
## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=gitricko/openclaw-webtop&type=date&legend=top-left)](https://www.star-history.com/#gitricko/openclaw-webtop&type=date&legend=top-left)
-->
