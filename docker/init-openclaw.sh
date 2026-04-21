#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1

SRC="/custom-cont-init.d/OpenClaw.desktop"

sync_desktop_file "$SRC" "/config/.config/autostart/OpenClaw.desktop"
sync_desktop_file "$SRC" "/config/Desktop/OpenClaw.desktop"