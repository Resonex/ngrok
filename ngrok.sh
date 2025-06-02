#!/data/data/com.termux/files/usr/bin/bash

# Script to install ngrok in Termux with authtoken configuration
# Credits: Resonex for the original script and banner inspiration
# Version: 1.1.2

# Disable debug mode to prevent scattered output
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
    echo -e "${CYAN}Checking internet connection...${NC}"
    ping -c 1 google.com >/dev/null 2>&1 &
    pid=$!
    loading_animation $pid "Testing network"
    wait $pid
    if [ $? -ne 0 ]; then
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC} ${WHITE}Error: No internet connection detected!${NC}   ${RED}║${NC}"
        echo -e "${RED}║${NC} ${WHITE}Please check your network and try again.${NC} ${RED}║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        exit 1
    fi
}

# Clear terminal
clear

# Welcome screen with enhanced banner
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v1.1.2 by Joker        ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}     Crafted by Resonex • Powered by Joker • 2025   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Initializing ngrok installation...${NC}"
echo ""

# Check internet before proceeding
check_internet

# Check if running in Termux
if ! command -v pkg >/dev/null 2>&1 || [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: This script must be run in Termux!${NC} ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
fi

# Install dependencies silently
pkg update -y >/dev/null 2>&1 && pkg upgrade -y >/dev/null 2>&1 && pkg install wget unzip -y >/dev/null 2>&1 &
pid=$!
loading_animation $pid "Preparing dependencies"
wait $pid

# Set variables
NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
INSTALL_DIR="$HOME/ngrok"
BIN_DIR="/data/data/com.termux/files/usr/bin"

# Create installation directory silently
mkdir -p "$INSTALL_DIR" >/dev/null 2>&1

# Download ngrok silently
wget -q "$NGROK_URL" -O ngrok.zip >/dev/null 2>&1 &
pid=$!
loading_animation $pid "Downloading ngrok"
wait $pid
if [ $? -ne 0 ]; then
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: Network failure during download!${NC}   ${RED}║${NC}"
    echo -e "${RED}║${NC} ${WHITE}Please check your network and try again.${NC} ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
fi

# Unzip ngrok silently
unzip ngrok.zip -d "$INSTALL_DIR" >/dev/null 2>&1 &
pid=$!
loading_animation $pid "Extracting ngrok"
wait $pid

# Set up ngrok binary silently
mv "$INSTALL_DIR/ngrok" "$BIN_DIR/ngrok" >/dev/null 2>&1 && chmod +x "$BIN_DIR/ngrok" >/dev/null 2>&1 &
pid=$!
loading_animation $pid "Configuring ngrok"
wait $pid

# Clean up silently
rm ngrok.zip >/dev/null 2>&1
rm -rf "$INSTALL_DIR" >/dev/null 2>&1

# Prompt for ngrok authtoken
echo -e "${CYAN}╔═════════════════ Authtoken Setup ═════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${GREEN}Ngrok requires an authtoken to unlock features${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${PURPLE}Visit https://dashboard.ngrok.com for your token${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
read -p "$(echo -e ${YELLOW}Enter authtoken [Enter to skip]:${NC} ) " NGROK_AUTH
if [ -n "$NGROK_AUTH" ]; then
    "$BIN_DIR/ngrok" authtoken "$NGROK_AUTH" >/dev/null 2>&1 &
    pid=$!
    loading_animation $pid "Applying authtoken"
    wait $pid
    if [ $? -ne 0 ]; then
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC} ${WHITE}Error: Network failure during authtoken!${NC} ${RED}║${NC}"
        echo -e "${RED}║${NC} ${WHITE}Please check your network and try again.${NC} ${RED}║${NC}"
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        exit 1
    fi
    echo -e "${GREEN}Authtoken applied successfully!${NC}"
else
    echo -e "${RED}No authtoken provided. Set it later with:${NC}"
    echo -e "${YELLOW}  ngrok authtoken <your-authtoken>${NC}"
fi
echo ""

# Verify installation
if command -v ngrok >/dev/null 2>&1; then
    echo -e "${CYAN}╔════════════════ Installation Success ══════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${LIGHT_GREEN}ngrok installed successfully!${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${CYAN}Start ngrok by running 'ngrok' in the terminal${NC} ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} ${PURPLE}Join CYBER SNIPPER for more tools and updates!${NC}  ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${PURPLE}Opening cyber snipper channel........${NC}           ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    termux-open-url https://t.me/cyber_snipper >/dev/null 2>&1 &
    pid=$!
    loading_animation $pid "Connecting to Telegram"
    wait $pid
else
    echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC} ${WHITE}Error: ngrok installation failed!${NC}        ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
fi

exit 0
