# Integrate WebAPI-to-API as fallback

```
Hey, i want you to add another provider called webai-api which is a proxy to Gemini-Web. Here are the set of APIs. Please configure the provider and the set of models it supports. The details of the API is below.

To query the models it supports: http://webai-api:6969/v1/models

And example of calling it:
curl http://webai-api:6969/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3.0-flash",
    "messages": [{ "role": "user", "content": "Hello!" }]
  }'

For full api spec, you can look at. http://webai-api:6969/openapi.json

I want you test API to ensure it works as well as all the models it supports too
Note: like ollama, there is no API Key needed for webai-api, so configure it accordingly
```



## Example of WebAI-API config

Here is the **webai-api provider config** I added to `models.providers` in your `openclaw.json`:

```json
"webai-api": {
  "api": "openai-completions",
  "apiKey": "webai-api",
  "baseUrl": "http://webai-api:6969/v1",
  "models": [
    {
      "id": "gemini-3.0-pro",
      "name": "Gemini 3.0 Pro",
      "reasoning": true,
      "input": ["text", "image"],
      "contextWindow": 1000000,
      "maxTokens": 32768,
      "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 }
    },
    {
      "id": "gemini-3.0-flash",
      "name": "Gemini 3.0 Flash",
      "reasoning": false,
      "input": ["text", "image"],
      "contextWindow": 1000000,
      "maxTokens": 32768,
      "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 }
    },
    {
      "id": "gemini-3.0-flash-thinking",
      "name": "Gemini 3.0 Flash Thinking",
      "reasoning": true,
      "input": ["text", "image"],
      "contextWindow": 1000000,
      "maxTokens": 32768,
      "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 }
    }
  ]
}
```

This goes under `models.providers` in your `~/.openclaw/openclaw.json` (or `/config/.openclaw/openclaw.json`). The gateway hot-reloads this automatically.



## Example NVIDIA Build's API as fallback changes

Only **one file** was actually changed by our work:

**`/config/.openclaw/openclaw.json`** — edited to add the NVIDIA provider and fallback model.

The other `.json` files (`agents/main/agent/models.json`, `sessions/sessions.json`, etc.) are runtime state files that get rewritten by the gateway automatically — they weren't touched by us.

Here's the diff of what changed:

```diff
--- original
+++ modified
@@ -3,7 +3,8 @@
   "agents": {
     "defaults": {
       "model": {
-        "primary": "ollama/minimax-m2.7:cloud"
+        "primary": "ollama/minimax-m2.7:cloud",
+        "fallbacks": ["nvidia/z-ai/glm4.7"]
       },
...
   "models": {
     "mode": "merge",
     "providers": {
+      "nvidia": {
+        "api": "openai-completions",
+        "apiKey": "nvapi-fakefakefakefake_dummydummy--q17Te7wJ5Cr2Qsz",
+        "baseUrl": "https://integrate.api.nvidia.com/v1",
+        "models": [{
+          "id": "z-ai/glm4.7",
+          "name": "glm4.7",
+          "reasoning": true,
+          "input": ["text"],
+          "contextWindow": 128000,
+          "maxTokens": 16384,
+          "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 }
+        }]
+      },
       "ollama": {
```



No git repo here, but I can show you exactly what changed. I made **two edits** to `openclaw.json`:

---

### 1. Added new provider `nvidia` (inside `models.providers`)

```json
"nvidia": {
  "api": "openai-completions",
  "apiKey": "nvapi-3G-DTG1nfakey-fakey-mIVebaPva22_EYU",
  "baseUrl": "https://integrate.api.nvidia.com/v1",
  "models": [
    {
      "id": "z-ai/glm4.7",
      "name": "GLM-4.7 (NVIDIA)",
      "input": ["text"],
      "contextWindow": 128000,
      "maxTokens": 16384,
      "reasoning": true,
      "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 }
    }
  ]
}
```

---

### 2. Updated `agents.defaults.model` (was just `primary`, added `fallbacks`)

**Before:**
```json
"defaults": {
  "model": {
    "primary": "ollama/minimax-m2.7:cloud"
  },
```

**After:**
```json
"defaults": {
  "model": {
    "primary": "ollama/minimax-m2.7:cloud",
    "fallbacks": ["nvidia/z-ai/glm4.7"]
  },
```

---

```markdown
## Model Configuration Changes

### Overview

| Setting | Value |
|---|---|
| Primary model | `ollama/minimax-m2.7:cloud` |
| Fallback model | `nvidia/z-ai/glm4.7` |
| Provider API | OpenAI Completions compatible |
| Base URL | `https://integrate.api.nvidia.com/v1` |
| Model | Zhipu AI GLM-4.7 |
| Reasoning | Enabled |
| Context window | 128,000 tokens |
| Max output | 16,384 tokens |

---

### Changes to `openclaw.json`

#### 1. Added `models.providers.nvidia`

```json
"nvidia": {
  "api": "openai-completions",
  "apiKey": "nvapi-fakefakefake-s18QUOUMexmIVebaPva22_EYU",
  "baseUrl": "https://integrate.api.nvidia.com/v1",
  "models": [
    {
      "id": "z-ai/glm4.7",
      "name": "GLM-4.7 (NVIDIA)",
      "input": ["text"],
      "contextWindow": 128000,
      "maxTokens": 16384,
      "reasoning": true,
      "cost": {
        "input": 0,
        "output": 0,
        "cacheRead": 0,
        "cacheWrite": 0
      }
    }
  ]
}
```

#### 2. Updated `agents.defaults.model`

```diff
"defaults": {
  "model": {
    "primary": "ollama/minimax-m2.7:cloud",
+   "fallbacks": ["nvidia/z-ai/glm4.7"]
  },
```

---

### Failover Behavior

When the primary model (`ollama/minimax-m2.7:cloud`) fails due to:
- Auth errors
- Rate limits
- Timeouts

OpenClaw automatically switches to the fallback (`nvidia/z-ai/glm4.7`).


### How to install OpenClaw without starting from Ollama launch

src: https://github.com/ollama/ollama/blob/main/cmd/launch/openclaw.go

```
openclaw onboard --non-interactive --accept-risk \
--auth-choice ollama \
--custom-base-url http://127.0.0.1:11434 \
--custom-model-id ollama/minimax-m2.7:cloud \
--skip-channels --skip-skills \
--skip-health 

Or —install-daemon
```

