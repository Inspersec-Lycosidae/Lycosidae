#!/bin/bash
set -e

ENV_FILE=".env"

# Function to get the local private IP (LAN)
get_private_ip() {
    # Gets the IP of the main network interface
    ip addr show | awk '/inet / && $2 !~ /^127/ {sub(/\/.*/,"",$2); print $2; exit}'
}

# Function to get the public IP (internet-facing)
get_public_ip() {
    curl -s https://api.ipify.org
}

# Detect if VPS or local dev
# Simple heuristic: if public IP != private IP, assume VPS
PRIVATE_IP=$(get_private_ip)
PUBLIC_IP=$(get_public_ip)

if [[ -z "$PUBLIC_IP" ]]; then
    echo "Failed to detect public IP, fallback to private IP."
    PUBLIC_IP=$PRIVATE_IP
fi

# Determine which IP to use
# If private IP starts with 10., 172., or 192., assume local dev
if [[ "$PRIVATE_IP" =~ ^10\. ]] || [[ "$PRIVATE_IP" =~ ^172\. ]] || [[ "$PRIVATE_IP" =~ ^192\. ]]; then
    # Local dev environment
    IP_TO_USE="$PRIVATE_IP"
else
    # VPS / public environment
    IP_TO_USE="$PUBLIC_IP"
fi

# Update or append in .env
if grep -q "^PUBLIC_IP=" "$ENV_FILE"; then
    sed -i "s/^PUBLIC_IP=.*/PUBLIC_IP=$IP_TO_USE/" "$ENV_FILE"
else
    echo "PUBLIC_IP=$IP_TO_USE" >> "$ENV_FILE"
fi

echo "Detected IP: $IP_TO_USE set in $ENV_FILE"
