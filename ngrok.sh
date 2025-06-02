#!/usr/bin/env bash

# Enhanced Ngrok Installer for Termux
# Author: Resonex

set -e

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Rainbow colors for banner
RAINBOW=($RED $YELLOW $GREEN $CYAN $BLUE $MAGENTA)

# Function to print banner with rainbow colors
print_banner() {
    local text=(
        "███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗ "
        "████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝ "
        "██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝  "
        "██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗  "
        "██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗ "
        "╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ "
    )
    echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} ${WHITE}       NGROK TERMUX INSTALLER v1.0.0         ${NC} ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════╣${NC}"
    for i in "${!text[@]}"; do
        color=${RAINBOW[$((i % ${#RAINBOW[@]}))]}
        echo -e "${CYAN}║${NC} ${color}${text[i]}${NC} ${CYAN}║${NC}"
    done
    echo -e "${CYAN}╠═══════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}     Crafted by Resonex and Spiccy           ${NC} ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
}


# Stylish Section Header
section() {
    echo -e "${MAGENTA}╭─────────────────────────────────────────────╮${NC}"
    echo -e "${MAGENTA}│${NC}  $1"
    echo -e "${MAGENTA}╰─────────────────────────────────────────────╯${NC}"
}

# Function to display a spinner
spinner() {
    local message="$1"
    local pid
    local delay=0.1
    local spinstr='|/-\'
    echo -n "$message "
    (
        while true; do
            for i in $(seq 0 3); do
                echo -ne "${spinstr:$i:1}" "\b"
                sleep $delay
            done
        done
    ) &
    pid=$!
    eval "$2"
    kill $pid
    wait $pid 2>/dev/null
    echo -e "${GREEN}✔${NC}"
}

# Clear the screen and print the banner
clear
print_banner

# Check for internet connection
section "${BLUE}🌐 Checking internet connection...${NC}"
if ! ping -c 1 google.com &>/dev/null; then
    clear
    print_banner
    section "${RED}No Internet detected."
    exit 1
fi
clear
print_banner
section "${GREEN}🌐 Internet connection active ${NC}"

# Install required packages
section "${BLUE}📦 Installing required packages...${NC}"
pkg install -y wget unzip termux-api &>/dev/null

# Download Ngrok
section "${BLUE}📥 Downloading Ngrok...${NC}"
ARCH=$(uname -m)
case $ARCH in
    aarch64)
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz"
        ;;
    arm*)
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz"
        ;;
    x86_64)
        NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
        ;;
    *)
        echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

wget -q "$NGROK_URL" -O ngrok.tgz
section "${GREEN}✅ Ngrok downloaded successfully.${NC}"

# Extract Ngrok
echo -e "${BLUE}🧩 Extracting Ngrok...${NC}"
tar -xzf ngrok.tgz
chmod +x ngrok
mv ngrok $PREFIX/bin/
rm ngrok.tgz
section "${GREEN}✅ Ngrok installed successfully.${NC}"

# Prompt for authtoken
echo -e "${CYAN}╔═════════════════ ${YELLOW}Authtoken Setup${NC} ═════════════════╗${NC}"
echo -e "${CYAN}║${NC}${MAGENTA}Set your authtoken.${NC}"
echo -e "${CYAN}║${NC}${MAGENTA}You can find your authtoken at: https://dashboard.ngrok.com/${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
termux-open-url https://dashboard.ngrok.com &>/dev/null
read -p "Enter your Ngrok authtoken (or leave blank to skip): " NGROK_AUTH

if [ -n "$NGROK_AUTH" ]; then
    echo -e "${BLUE}🔧 Configuring Ngrok with your authtoken...${NC}"
    if ngrok config add-authtoken "$NGROK_AUTH" &>/dev/null; then
        echo -e "${GREEN}✅ Authtoken configured successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to configure authtoken. Please check the token and try again.${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Authtoken setup skipped. You can add it later using:${NC}"
    echo -e "${WHITE}    ngrok config add-authtoken <your-token>${NC}"
fi

clear
print_banner
# Open Ngrok dashboard
section "${BLUE}🌐 Join My channel if you want to learn hacking...${NC}"
termux-open-url https://t.me/cyber_snipper &>/dev/null

section "${GREEN}🎉 Ngrok installation and setup complete!${NC}"
section "${GREEN}🚀 You can now use Ngrok by running: ${WHITE}ngrok http 8080${NC}"
