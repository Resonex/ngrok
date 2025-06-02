#!/usr/bin/env bash

# Script to install ngrok in Termux with authtoken configuration
# Credits: Resonex for the original script and banner inspiration
# Version: 1.1.3

# Disable debug mode
set +x

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GREEN='\033[1;32m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Log file for debugging
LOG_FILE="$HOME/ngrok_install.log"
echo "Ngrok installation log - $(date)" > "$LOG_FILE"

# Advanced loading animation with percentage
loading_animation() {
    local pid=$1
    local message=$2
    local delay=0.15
    local anim_chars="⠋⠙⠹⠸⠼⠴⠦⠧"
    local progress=0
    local anim_index=0

    while kill -0 $pid 2>/dev/null; do
        local anim_char=${anim_chars:$anim_index:1}
        printf "\r${LIGHT_CYAN}%-25s [%3d%%] %s${NC}" "$message" "$progress" "$anim_char"
        ((anim_index=(anim_index + 1) % 8))
        ((progress+=4))
        [ $progress -gt 100 ] && progress=0
        sleep $delay
    done
    printf "\r${LIGHT_CYAN}%-25s [100%%] ✓${NC}\n" "$message"
}

# Check internet connectivity
check_internet() {
    echo -e "${CYAN}Checking internet connection...${NC}" | tee -a "$LOG_FILE"
    curl -s --connect-timeout 5 https://google.com >/dev/null 2>&1 &
    pid=$!
    loading_animation $pid "Testing network"
    wait $pid
    if [ $? -ne 0 ]; then
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC} ${WHITE}Error: No internet connection detected!${NC}   ${RED}║${NC}"
        echo -e "${RED}║${NC} ${WHITE}Please check your network and try again.${NC} ${RED}║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        echo "Internet check failed" >> "$LOG_FILE"
        exit 1
    fi
}

# Clear terminal
clear

# Welcome screen with enhanced banner
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v1.1.3 by xAI        ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}     Crafted by Resonex • Powered by xAI • 2025     ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Initializing ngrok installation...${NC} ${PURPLE}[10:46 AM WAT, June 02, 2025]${NC}" | tee -a "$LOG_FILE"
echo ""

# Check internet before proceeding
check_internet

# Check if running in Termux
if [ -z "$PREFIX" ] || [ ! -d "$PREFIX" ] || [ "$PREFIX" != "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: This script must be run in Termux!${NC} ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo "Termux environment check failed: PREFIX=$PREFIX" >> "$LOG_FILE"
    exit 1
fi

# Install dependencies silently
for cmd in "update -y" "upgrade -y" "install wget unzip -y"; do
    pkg $cmd >/dev/null 2>>"$LOG_FILE" &
    pid=$!
    loading_animation $pid "Preparing dependencies ($cmd)"
    wait $pid || {
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC} ${WHITE}Error: Failed to $cmd!${NC}                  ${RED}║${NC}"
        echo -e "${RED}║${NC} ${WHITE}Check $LOG_FILE for details.${NC}          ${RED}║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        exit 1
    }
done

# Set variables
NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
INSTALL_DIR="$HOME/ngrok"
BIN_DIR="$PREFIX/bin"

# Check write permissions
if [ ! -w "$HOME" ] || [ ! -w "$BIN_DIR" ]; then
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: No write permission for $HOME or $BIN_DIR!${NC} ${RED}║${NC}"
    echo -e "${RED}╚═════${NC} ${WHITE}Run 'termux-setup-storage' or check permissions.═════${NC}╝${NC}"
    echo "Permission error: HOME=$HOME, BIN_DIR=$BIN_DIR" >> "$LOG_FILE"
    exit 1
fi

# Create installation directory
mkdir -p "$INSTALL_DIR" 2>>"$LOG_FILE" || {
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: Failed to create $INSTALL_DIR!${NC}    ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
}

# Download ngrok
wget -q "$NGROK_URL" -O ngrok.zip 2>>"$LOG_FILE" &
pid=$!
loading_animation $pid "Downloading ngrok"
wait $pid || {
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: Network failure during download!${NC}   ${RED}║${NC}"
    echo -e "${RED}║${NC} ${WHITE}Please check your network and try again.${NC} ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
}

# Unzip ngrok
unzip ngrok.zip -d "$INSTALL_DIR" 2>>"$LOG_FILE" &
pid=$!
loading_animation $pid "Extracting ngrok"
wait $pid || {
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: Failed to extract ngrok!${NC}          ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
}

# Set up ngrok binary
mv "$INSTALL_DIR/ngrok" "$BIN_DIR/ngrok" 2>>"$LOG_FILE" && chmod +x "$BIN_DIR/ngrok" 2>>"$LOG_FILE" &
pid=$!
loading_animation $pid "Configuring ngrok"
wait $pid || {
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: Failed to configure ngrok!${NC}        ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
}

# Clean up
rm ngrok.zip 2>>"$LOG_FILE"
rm -rf "$INSTALL_DIR" 2>>"$LOG_FILE"

# Prompt for ngrok authtoken
echo -e "${CYAN}╔═════════════════ Authtoken Setup ═════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${GREEN}Ngrok requires an authtoken to unlock features${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${PURPLE}Visit https://dashboard.ngrok.com for your token${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
read -p "$(echo -e ${YELLOW}Enter authtoken [Enter to skip]:${NC} ) " NGROK_AUTH
if [ -n "$NGROK_AUTH" ]; then
    "$BIN_DIR/ngrok" authtoken "$NGROK_AUTH" 2>>"$LOG_FILE" &
    pid=$!
    loading_animation $pid "Applying authtoken"
    wait $pid || {
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC} ${WHITE}Error: Failed to apply authtoken!${NC}       ${RED}║${NC}"
        echo -e "${RED}║${NC} ${WHITE}Check network or token validity.${NC}       ${RED}║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        exit 1
    }
    echo -e "${GREEN}Authtoken applied successfully!${NC}"
else
    echo -e "${RED}No authtoken provided. Set it later with:${NC}"
    echo -e "${YELLOW}  ngrok authtoken <your-authtoken>${NC}"
fi
echo ""

# Verify installation
if command -v ngrok >/dev/null 2>&1 && "$BIN_DIR/ngrok" --version 2>/dev/null | grep -q "ngrok"; then
    echo -e "${CYAN}╔════════════════ Installation Success ══════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${LIGHT_GREEN}ngrok installed successfully!${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${CYAN}Start ngrok by running 'ngrok' in the terminal${NC} ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} ${PURPLE}Join CYBER SNIPPER for more tools and updates!${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${PURPLE}Opening https://t.me/cyber_snipper...${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    termux-open-url https://t.me/cyber_snipper 2>>"$LOG_FILE" &
    pid=$!
    loading_animation $pid "Connecting to Telegram"
    wait $pid
else
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: ngrok installation failed!${NC}        ${RED}║${NC}"
    echo -e "${RED}║${NC} ${WHITE}Check $LOG_FILE for details.${NC}            ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    echo "Installation verification failed" >> "$LOG_FILE"
    exit 1
fi

exit 0
