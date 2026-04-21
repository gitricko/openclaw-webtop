#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1

SRC="/custom-cont-init.d/ModelRelay.desktop"

configure_open_claw() {
    local config_path="$1"
    echo "[init-modelrelay] Configuring OpenClaw at $config_path"

    tmp_file=$(mktemp)
    jq \
    --arg baseUrl "http://127.0.0.1:7352/v1" \
    '
    # Ensure base paths exist
    .models //= {} |
    .models.providers //= {} |
    .agents //= {} |
    .agents.defaults //= {} |
    .agents.defaults.model //= {} |
    .agents.defaults.models //= {} |
    .agents.defaults.models["modelrelay/auto-fastest"] //= {} |

    # Logic for config.models.providers.modelrelay
    .models.providers.modelrelay = {
        "baseUrl": $baseUrl,
        "api": "openai-completions",
        "apiKey": "no-key",
        "models": [
        { "id": "auto-fastest", "name": "Auto Fastest" }
        ]
    } |

    # Logic for config.agents.defaults.model.primary
    .agents.defaults.model.primary = "modelrelay/auto-fastest"
    
    ' "$config_path" > "$tmp_file" && mv "$tmp_file" "$config_path"
    cat "$config_path"
    echo "Success: Configured $config_path"
    return 0
}

# Prep nodejs npm for ModelRelay 
rm -rf /config/.npm
chown abc:abc -R  /usr/local/lib/node_modules &
chown abc:abc -R  /usr/local/bin &

# Sync desktop file for autostart and desktop icon
sync_desktop_file "$SRC" "/config/.config/autostart/ModelRelay.desktop"
sync_desktop_file "$SRC" "/config/Desktop/ModelRelay.desktop"

# Add modelrelay model to openclaw's config as soon as it appears, and set it as default for agents if no default was set
# /config/.openclaw/openclaw.json 
(
    for i in {0..120}; do
        echo "[init-modelrelay] i am here"
        if [ -f "/config/.openclaw/openclaw.json.bak" ] && [ -f "/config/.openclaw/openclaw.json" ]; then
            configure_open_claw "/config/.openclaw/openclaw.json"
            chown abc:abc "/config/.openclaw/openclaw.json"
            break
        fi
        sleep 5
    done
) &