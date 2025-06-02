#!/usr/bin/env bash

# NGROK Installer for Termux (Silent, Retry, Animated)
# Version: 1.2.0 | Author: xAI (inspired by Resonex)
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GREEN='\033[1;32m'
WHITE='\033[1;37m'
NC='\033[0m'

# Spinner loader
spinner() {
    local msg="$1"
    local duration=${2:-5}
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local frame_index=0

    printf "${LIGHT_CYAN}%-35s${NC} " "$msg"
    for ((i=0; i<duration*10; i++)); do
        printf "\r${LIGHT_CYAN}%-35s ${WHITE}%s${NC}" "$msg" "${frames[frame_index]}"
        frame_index=$(( (frame_index + 1) % 10 ))
        sleep 0.1
    done
    printf "\r${LIGHT_CYAN}%-35s ${GREEN}✓${NC}\n" "$msg"
}

# Silent retry wrapper
run_silent() {
    local cmd="$1"
    local retries=3
    while (( retries > 0 )); do
        eval "$cmd" &>/dev/null && return 0
        printf "\r${RED}Error${NC}\n"
        ((retries--))
        sleep 1
    done
    return 1
}

# Clear screen and show banner
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v1.1.6               ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${LIGHT_CYAN}   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}     Crafted by Resonex                             ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Check internet connection
spinner "Checking Internet" 3
curl -s --connect-timeout 5 https://google.com >/dev/null || {
    echo -e "${RED}Error: No internet connection${NC}"
    exit 1
}

# Check if Termux
if [ "$PREFIX" != "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}Error: Must run this script inside Termux.${NC}"
    exit 1
fi

# Update and install dependencies silently
for cmd in \
    "pkg update -y" \
    "pkg upgrade -y" \
    "pkg install wget unzip -y"
do
    spinner "Installing ${cmd#* }" 3
    run_silent "$cmd" || exit 1
done

# Define vars
NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
INSTALL_DIR="$HOME/ngrok"
BIN_DIR="$PREFIX/bin"

# Create installation directory
spinner "Creating install directory" 2
run_silent "mkdir -p \"$INSTALL_DIR\"" || exit 1

# Download ngrok
spinner "Downloading ngrok" 4
run_silent "wget -q \"$NGROK_URL\" -O ngrok.zip" || exit 1

# Extract ngrok
spinner "Extracting ngrok" 3
run_silent "unzip -o ngrok.zip -d \"$INSTALL_DIR\"" || exit 1

# Move binary
spinner "Configuring ngrok" 2
run_silent "mv \"$INSTALL_DIR/ngrok\" \"$BIN_DIR/ngrok\"" || exit 1
run_silent "chmod +x \"$BIN_DIR/ngrok\"" || exit 1

# Clean up
spinner "Cleaning up" 2
rm -rf "$INSTALL_DIR" ngrok.zip &>/dev/null

# Authtoken prompt
echo -e "${CYAN}╔═════════════════ Authtoken Setup ═════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${GREEN}Ngrok requires an authtoken to unlock features${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${PURPLE}Visit https://dashboard.ngrok.com for your token${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
read -p "${YELLOW}Enter authtoken [or leave blank to skip]: ${NC}" NGROK_AUTH
if [ -n "$NGROK_AUTH" ]; then
    spinner "Applying authtoken" 2
    run_silent "ngrok authtoken \"$NGROK_AUTH\"" || {
        echo -e "${RED}Error applying authtoken${NC}"
        exit 1
    }
else
    echo -e "${YELLOW}Authtoken skipped. You can add it later with:${NC}"
    echo -e "${WHITE}  ngrok authtoken <your-token>${NC}"
fi
echo ""

# Final verification
spinner "Verifying installation" 2
if command -v ngrok >/dev/null && ngrok --version &>/dev/null; then
    echo -e "${CYAN}╔═══════════════ Installation Complete ══════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${LIGHT_GREEN}ngrok installed successfully!${NC}                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${CYAN}Start using it by typing: ${WHITE}ngrok${NC}             ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
else
    echo -e "${RED}ngrok installation failed.${NC}"
    exit 1
fi

# Optional: open Telegram link
spinner "Opening Cyber Snipper" 2
run_silent "pkg install termux-api -y"
run_silent "termux-open-url https://t.me/cyber_snipper" || {
    echo -e "${YELLOW}Visit manually: https://t.me/cyber_snipper${NC}"
}

exit 0
