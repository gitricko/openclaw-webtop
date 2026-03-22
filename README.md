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

**OpenClaw-WebTop** runs OpenClaw securely with a need for a dedicate computer. When you are read, you can move to your own machine docker environment if you would like.


## Quick start (TL;DR)

1. Open this repository in a GitHub Codespace
2. In the Codespace terminal run:

```bash
make start
```

3. Wait for the OpenClaw WebTop docker to boot. When the web desktop URL appears in the Codespace `Ports` Tab, click it to open the browser desktop.

### Will be full automated

4. In the webtop, open a terminal and run `ollama serve`
5. Open another terminal and run `ollama signin`
6. Sign in or sign up for a ollama free account.. and you get some cloud LLM token for free (reset every day and week)
7. Download a cloud ollama model via `ollama pull kimi-k2.5:cloud`
8 Open another terminal and run `ollama launch openclaw --model kimi-k2.5:cloud`
9. Follow the instructions till completion
10. In the webtop, open a chromium browser and check if you can access this URI: http://localhost:127.0.0.1
11. If it does not work: run `openclaw gateway run`
12. When the URL is working, run `openclaw dashboard` it will give you to URI with a token at the end.



<!-- ## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=gitricko/openclaw-webtop&type=date&legend=top-left)](https://www.star-history.com/#gitricko/openclaw-webtop&type=date&legend=top-left) -->
