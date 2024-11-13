# Simplify directory names by creating variables
ZAP_DIR="tools/dependencies/esp-matter/connectedhomeip/connectedhomeip/.environment/cipd/packages/zap"
ESP_MATTER_DIR="tools/dependencies/esp-matter"

if [ -f "$ZAP_DIR/zap-cli"* ]; then
  log_message "zap is already installed." 32
  export ZAP_INSTALL_PATH=$(readlink -f "$ZAP_DIR")

else
  handle_error "zap is not installed. run install.sh first."
  exit 1
fi

if [ ! -d "$ESP_MATTER_DIR" ]; then
  handle_error "$ESP_MATTER_DIR folder does not exist."
  exit 1
fi
export ESP_MATTER_PATH=$(readlink -f "$ESP_MATTER_DIR")

export LOW_CODE_PATH=$(readlink -f $(dirname $0))

log_message "Successfully exported variables" 32
