# Integrate WebAPI-to-API as fallback

sdsd





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
