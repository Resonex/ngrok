#!/usr/bin/env bash

# NGROK Installer for Termux (Rainbow Edition)
# Version: 2.0.0 | Author: xAI (inspired by Resonex)
set -e

# Color Palette (Rainbow)
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
INDIGO='\033[0;35m'
VIOLET='\033[1;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Spinner Loader (Enhanced)
spinner() {
    local msg="$1"
    local duration=${2:-5}
    local frames=('🌈' '✨' '🌟' '💫' '🌀' '⭐' '🌟' '💫')
    local frame_index=0

    printf "${BLUE}%-40s${NC} " "$msg"
    for ((i=0; i<duration*10; i++)); do
        printf "\r${BLUE}%-40s ${WHITE}%s${NC}" "$msg" "${frames[frame_index]}"
        frame_index=$(( (frame_index + 1) % 8 ))
        sleep 0.1
    done
    printf "\r${GREEN}%-40s ✓${NC}\n" "$msg"
}

# Retry wrapper
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

# BANNER (Keep As-Is)
clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v2.0.0               ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${CYAN}   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${BLUE}   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${GREEN}   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${RED}   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${PURPLE}   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${VIOLET}     Crafted by Resonex ✨                        ${NC} ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Internet Check
spinner "🌐 Checking internet connection..." 3
curl -s --connect-timeout 5 https://google.com >/dev/null || {
    echo -e "${RED}Error: No internet connection${NC}"
    exit 1
}

# Termux check
if [ "$PREFIX" != "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}Error: This script is for Termux only${NC}"
    exit 1
fi

# Dependencies
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━ ${CYAN}Installing Dependencies${WHITE} ━━━━━━━━━━━━━━━━━━━${NC}"
deps=("update -y" "upgrade -y" "install wget unzip -y")
for dep in "${deps[@]}"; do
    label=$(echo "$dep" | awk '{print toupper($1)}')
    spinner "💾 Installing $label..." 4
    run_silent "pkg $dep" || exit 1
done
echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Vars
NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
INSTALL_DIR="$HOME/ngrok"
BIN_DIR="$PREFIX/bin"

spinner "📁 Creating install directory..." 2
run_silent "mkdir -p \"$INSTALL_DIR\"" || exit 1

spinner "⬇️ Downloading ngrok..." 4
run_silent "wget -q \"$NGROK_URL\" -O ngrok.zip" || exit 1

spinner "📦 Extracting ngrok..." 3
run_silent "unzip -o ngrok.zip -d \"$INSTALL_DIR\"" || exit 1

spinner "⚙️ Configuring ngrok binary..." 2
run_silent "mv \"$INSTALL_DIR/ngrok\" \"$BIN_DIR/ngrok\"" || exit 1
run_silent "chmod +x \"$BIN_DIR/ngrok\"" || exit 1

spinner "🧹 Cleaning up..." 2
rm -rf "$INSTALL_DIR" ngrok.zip &>/dev/null

# Authtoken
echo -e "${BLUE}╔═══════════════════ 🔐 AUTHTOKEN SETUP ═══════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${GREEN}Let's link your ngrok account for full access.         ${NC}${BLUE}║${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}We'll open the Ngrok dashboard in your browser now.   ${NC}${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
spinner "🌍 Opening ngrok dashboard..." 2
run_silent "termux-open-url https://dashboard.ngrok.com/get-started/your-authtoken"

echo ""
read -p "${ORANGE}Paste your authtoken here (or leave blank to skip): ${NC}" NGROK_AUTH
if [ -n "$NGROK_AUTH" ]; then
    spinner "🔐 Applying authtoken..." 2
    run_silent "ngrok authtoken \"$NGROK_AUTH\"" || {
        echo -e "${RED}Error: Invalid authtoken. Please try manually later.${NC}"
        exit 1
    }
else
    echo -e "${YELLOW}Skipped. You can set it later with:${NC} ${WHITE}ngrok authtoken <your-token>${NC}"
fi
echo ""

spinner "✅ Verifying ngrok install..." 2
if command -v ngrok >/dev/null && ngrok --version &>/dev/null; then
    echo -e "${GREEN}🎉 ngrok installed successfully!"
    echo -e "${CYAN}Type ${WHITE}ngrok${CYAN} to get started!"
else
    echo -e "${RED}Installation failed. Please try again.${NC}"
    exit 1
fi

# Final: Open Telegram
spinner "🚀 Opening Cyber Snipper..." 2
run_silent "pkg install termux-api -y"
run_silent "termux-open-url https://t.me/cyber_snipper" || {
    echo -e "${YELLOW}Visit manually: https://t.me/cyber_snipper${NC}"
}

exit 0
