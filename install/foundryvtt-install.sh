#!/usr/bin/env bash

# Copyright (c) 2025 community-scripts ORG
# Author: Brian Benninger
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://foundryvtt.com/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt install -y \
  curl \
  wget \
  unzip \
  libssl-dev
msg_ok "Installed Dependencies"

msg_info "Setting up Node.js Repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
$STD apt-get update
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Setting up Foundry VTT"
useradd -m -d /opt/foundryvtt foundry
cd /opt/foundryvtt
wget -O foundryvtt.zip "https://foundryvtt.com/releases/download?build=343&platform=node"
unzip -q FoundryVTT-12.343.zip
rm FoundryVTT-12.343.zip
mkdir -p /opt/foundrydata
chown -R foundry: /opt/foundryvtt /opt/foundrydata
msg_ok "Setup Foundry VTT"

msg_info "Creating systemd Service"
cat <<EOF >/etc/systemd/system/foundryvtt.service
[Unit]
Description=Foundry VTT
After=network.target

[Service]
Type=simple
User=foundry
WorkingDirectory=/opt/foundryvtt
ExecStart=/usr/bin/node /opt/foundryvtt/main.js --dataPath=/opt/foundrydata
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable foundryvtt
systemctl start foundryvtt
msg_ok "Service Created and Started"

motd_ssh
customize
