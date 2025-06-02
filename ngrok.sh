#!/usr/bin/env bash

# NGROK Installer for Termux (Silent, Retry, Animated)
# Version: 1.3.0 | Author: xAI

set -e

# Rainbow color cycle
RAINBOW=("\033[0;31m" "\033[0;33m" "\033[0;32m" "\033[0;36m" "\033[0;34m" "\033[0;35m" "\033[1;35m")
NC='\033[0m'  # No Color
WHITE='\033[1;37m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
ERROR='\033[1;31mError${NC}'

# Spinner animation (professional style)
spinner() {
    local msg="$1"
    local duration=${2:-4}
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    printf "${WHITE}%-40s" "$msg"
    while ((duration--)); do
        for ((j=0; j<${#spin}; j++)); do
            printf "\r${WHITE}%-40s ${CYAN}%s${NC}" "$msg" "${spin:j:1}"
            sleep 0.1
        done
    done
    printf "\r${WHITE}%-40s ${GREEN}✔${NC}\n" "$msg"
}

# Retry-safe silent command runner
run_silent() {
    local cmd="$1"
    local retries=3
    while (( retries > 0 )); do
        eval "$cmd" &>/dev/null && return 0
        ((retries--))
        sleep 1
    done
    printf "\r${ERROR}\n"
    return 1
}

# Rainbow section header
section() {
    local text="$1"
    local len=${#text}
    local deco="═"
    local edge="╔══════════════════════════════════════════════════════════════╗"
    echo -e "${RAINBOW[RANDOM % ${#RAINBOW[@]}]}$edge${NC}"
    printf "${RAINBOW[RANDOM % ${#RAINBOW[@]}]}║${NC} ${BOLD}${WHITE}%-60s${NC} ${RAINBOW[RANDOM % ${#RAINBOW[@]}]}║${NC}\n" "$text"
    echo -e "${RAINBOW[RANDOM % ${#RAINBOW[@]}]}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# Banner
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v1.3.0               ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[1]}   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[2]}   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[3]}   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[4]}   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[5]}   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RAINBOW[6]}   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Step: Internet check
section "Checking Internet Connection"
spinner "Checking connection"
curl -s --connect-timeout 5 https://google.com >/dev/null || {
    echo -e "${ERROR}: No internet connection"
    exit 1
}

# Check if running in Termux
if [[ "$PREFIX" != "/data/data/com.termux/files/usr" ]]; then
    echo -e "${ERROR}: Run this script inside Termux."
    exit 1
fi

# Step: Install Dependencies
section "Installing Dependencies"
for cmd in \
    "pkg update -y" \
    "pkg upgrade -y" \
    "pkg install wget -y" \
    "pkg install unzip -y" \
    "pkg install termux-api -y"
do
    spinner "Installing ${cmd#* }"
    run_silent "$cmd" || exit 1
done

# Step: Prepare for Installation
section "Setting Up ngrok"
NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
INSTALL_DIR="$HOME/ngrok"
BIN_DIR="$PREFIX/bin"

spinner "Creating install directory"
run_silent "mkdir -p \"$INSTALL_DIR\""

spinner "Downloading ngrok"
run_silent "wget -q \"$NGROK_URL\" -O ngrok.zip"

spinner "Extracting ngrok"
run_silent "unzip -o ngrok.zip -d \"$INSTALL_DIR\""

spinner "Moving ngrok binary"
run_silent "mv \"$INSTALL_DIR/ngrok\" \"$BIN_DIR/ngrok\""
run_silent "chmod +x \"$BIN_DIR/ngrok\""

spinner "Cleaning up"
rm -rf "$INSTALL_DIR" ngrok.zip &>/dev/null

# Step: Authtoken
section "Ngrok Authtoken Setup"
echo -e "${WHITE}To unlock full features, connect your ngrok account.${NC}"
echo -e "${CYAN}Opening ngrok dashboard in browser...${NC}"
termux-open-url "https://dashboard.ngrok.com/get-started/your-authtoken" &>/dev/null || echo -e "${YELLOW}Couldn't open browser. Visit manually above.${NC}"

read -p "${YELLOW}Paste your ngrok authtoken here (or press Enter to skip): ${NC}" NGROK_AUTH
if [[ -n "$NGROK_AUTH" ]]; then
    spinner "Applying authtoken"
    run_silent "ngrok config add-authtoken \"$NGROK_AUTH\"" || {
        echo -e "${YELLOW}Could not apply authtoken. Try manually later.${NC}"
    }
else
    echo -e "${YELLOW}Authtoken skipped. You can apply later using:${NC}"
    echo -e "${WHITE}  ngrok config add-authtoken <your-token>${NC}"
fi

# Step: Final verification
section "Finalizing Installation"
spinner "Verifying installation"
if command -v ngrok >/dev/null && ngrok version &>/dev/null; then
    echo -e "${GREEN}ngrok installed successfully! Start with: ${WHITE}ngrok${NC}"
else
    echo -e "${ERROR}: ngrok installation failed."
    exit 1
fi

# Bonus: Telegram link
section "Join Our Telegram Channel"
spinner "Opening Cyber Snipper Channel"
termux-open-url "https://t.me/cyber_snipper" &>/dev/null || {
    echo -e "${YELLOW}Visit manually: https://t.me/cyber_snipper${NC}"
}

exit 0
