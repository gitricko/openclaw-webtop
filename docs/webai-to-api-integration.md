# Integrate WebAPI-to-API as fallback

```
Hey, i want you to add another provider called webai-api which is a proxy to Gemini-Web. Here are the set of APIs. Please configure the provider and the set of models it supports and the details of the API is below.

To query the models it supports: http://webai-api:6969/v1/models

And example of calling it:
curl http://webai-api:6969/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3.0-flash",
    "messages": [{ "role": "user", "content": "Hello!" }]
  }'

For full api spec, you can look at. http://webai-api:6969/openapi.json

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
