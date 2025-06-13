#!/bin/bash

CONFIG_PATH="$HOME/.config/qBittorrent/qBittorrent.ini"
TMP_PATH="/tmp/qBittorrent.ini.tmp"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_PATH="${CONFIG_PATH}.bak.${TIMESTAMP}"

# Detect VPN utun interface and IP
VPN_IFACE=$(ifconfig | grep -A 2 utun | awk '/utun[0-9]+/{gsub(":", "", $1); iface=$1} /inet 10\./{print iface}')
VPN_IP=$(ifconfig | grep -A 2 utun | awk '/utun[0-9]+/{gsub(":", "", $1); iface=$1} /inet 10\./{print $2}')

if [ -z "$VPN_IFACE" ] || [ -z "$VPN_IP" ]; then
  echo "❌ No active VPN utun interface with 10.x.x.x IP found."
  exit 1
fi

echo "🔒 Detected VPN Interface: $VPN_IFACE"
echo "🌐 IP Address: $VPN_IP"

# Copy config for dry run
cp "$CONFIG_PATH" "$TMP_PATH"

# Do changes on temp file
update_or_insert() {
  local key="$1"
  local value="$2"
  local escaped_key
  escaped_key=$(printf "%s" "$key" | sed 's/\\/\\\\/g')

  if grep -q "^$escaped_key=" "$TMP_PATH"; then
    sed -i '' "s|^$escaped_key=.*|$escaped_key=$value|" "$TMP_PATH"
  else
    echo "$key=$value" >> "$TMP_PATH"
  fi
}

update_or_insert "Session\\InterfaceName" "$VPN_IFACE"
update_or_insert "Session\\Interface" "$VPN_IFACE"

# Show diff and conditionally continue
echo
echo "🕵️ Config changes (dry run):"
echo "----------------------------"
if diff -u "$CONFIG_PATH" "$TMP_PATH"; then
  echo "✅ No changes necessary. Already bound to $VPN_IFACE"
  rm "$TMP_PATH"
  exit 0
fi
echo "----------------------------"

# Confirm and apply
read -p "Apply these changes? [y/N]: " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "🗂️  Backing up current config to: $BACKUP_PATH"
  cp "$CONFIG_PATH" "$BACKUP_PATH"

  echo "💾 Applying changes..."
  cp "$TMP_PATH" "$CONFIG_PATH"

  echo "🔄 Restarting qBittorrent..."
  pkill -x "qBittorrent"
  sleep 2
  open -a "qBittorrent"

  echo "✅ Bound to $VPN_IFACE successfully at $(date)"
else
  echo "❌ Aborted. No changes made."
fi

# Cleanup
rm "$TMP_PATH"

