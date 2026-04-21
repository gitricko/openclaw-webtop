#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1

SRC="/custom-cont-init.d/ModelRelay.desktop"

add_model_if_missing() {
    local file="$1"

    if ! jq -e '.models.providers | has("modelrelay")' "$file" > /dev/null; then
        echo "[init-modelrelay] Adding modelrelay model to $file"
        jq '.models.providers += {
          modelrelay: {
            "baseUrl": "http://127.0.0.1:7352/v1",
            "api": "openai-completions",
            "apiKey": "no-key",
            "models": [
                {
                    "id": "auto-fastest",
                    "name": "Auto Fastest"
                }
            ]
        }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    fi

    # Set modelrelay as default for agents if no default model is set
    if jq -e '.agents.defaults.model.primary | select(. == null or . == "")' "$file" > /dev/null; then
        echo "[init-modelrelay] Setting modelrelay as defaults for agents in $file"
        jq '.agents |= (. // {}) | .agents.defaults |= (. // {}) | .agents.defaults.model |= (. // {}) | .agents.defaults.model.primary = "modelrelay/auto-fastest" | .agents.defaults.models |= (. // {}) | .agents.defaults.models["modelrelay/auto-fastest"] = {}' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    fi

}

# Prep nodejs npm for ModelRelay 
rm -rf /config/.npm
chown abc:abc -R  /usr/local/lib/node_modules &
chown abc:abc -R  /usr/local/bin &

# Sync desktop file for autostart and desktop icon
sync_desktop_file "$SRC" "/config/.config/autostart/ModelRelay.desktop"
sync_desktop_file "$SRC" "/config/Desktop/ModelRelay.desktop"

# Add modelrelay model to openclaw's config as soon as it appears, and set it as default for agents if no default was set
# /config/.openclaw/config.json 
(
    for i in {0..120}; do
        if [ -f "/config/.openclaw/config.json" ]; then
            add_model_if_missing "/config/.openclaw/config.json"
            chown abc:abc "/config/.openclaw/config.json"
            break
        fi
        sleep 5
    done
) &