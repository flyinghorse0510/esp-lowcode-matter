#!/bin/bash

# Function to log messages with color
log_message() {
    echo -e "\e[${2:-32}m$1\e[0m"
}

# Function to handle errors
handle_error() {
    log_message "Error: $1" 31
    exit 1
}

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $OS in
    darwin)
        case $ARCH in
            arm64) URL="https://github.com/project-chip/zap/releases/latest/download/zap-mac-arm64.zip" ;;
            x86_64) URL="https://github.com/project-chip/zap/releases/latest/download/zap-mac-x64.zip" ;;
            *) handle_error "Unsupported architecture for macOS" ;;
        esac
        ;;
    linux)
        case $ARCH in
            x86_64) URL="https://github.com/project-chip/zap/releases/latest/download/zap-linux-x64.zip" ;;
            aarch64) URL="https://github.com/project-chip/zap/releases/latest/download/zap-linux-arm64.zip" ;;
            *) handle_error "Unsupported architecture for Linux" ;;
        esac
        ;;
    *) handle_error "Unsupported OS" ;;
esac

# Simplify directory names by creating a variable
INSTALL_DIR="tools/dependencies/esp-matter/connectedhomeip/connectedhomeip/.environment/cipd/packages"

mkdir -p "$INSTALL_DIR" || handle_error "Failed to create directory $INSTALL_DIR"
log_message "Installing zap..." 32

curl -L -o "$INSTALL_DIR/zap.zip" $URL || handle_error "Failed to download zap.zip"

if unzip -q "$INSTALL_DIR/zap.zip" -d "$INSTALL_DIR/zap"; then
    log_message "Unzip successful." 32
else
    handle_error "Unzip failed"
fi
if [ -f "$INSTALL_DIR/zap/zap-cli"* ]; then
  rm "$INSTALL_DIR/zap.zip"
  log_message "Successfully Downloaded zap" 32
else
  handle_error "Issue in unzipping the file"
fi

