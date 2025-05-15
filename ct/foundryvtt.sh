#!/usr/bin/env bash

# source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
source <(curl -fsSL https://raw.githubusercontent.com/BrianBenninger/ProxmoxVE/foundryvtt/misc/build.func)
# Author: Brian Benninger
# License: MIT

APP="FoundryVTT"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-6}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  msg_info "Updating $APP not currently implemented"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup complete!${CL}"
echo -e "${INFO}${YW} Access it at:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:30000${CL}"
