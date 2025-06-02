# 🚀 Ngrok Termux Installer

![GitHub release (latest by date)](https://img.shields.io/github/v/release/Resonex/ngrok?color=cyan&style=flat-square)
![GitHub license](https://img.shields.io/github/license/Resonex/ngrok?color=yellow&style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/Resonex/ngrok?color=lightgreen&style=flat-square)
![Join CYBER SNIPPER](https://img.shields.io/badge/Telegram-Join%20CYBER%20SNIPPER-purple?style=flat-square&logo=telegram)

Welcome to the **Ngrok Termux Installer**, a cutting-edge script for installing [ngrok](https://ngrok.com) in Termux with a futuristic, user-friendly interface. Crafted by **Resonex** and powered by **Joker**. 🚀

Built for 2025, this script transforms ngrok installation into an engaging process. Join the [CYBER SNIPPER Telegram channel](https://t.me/cyber_snipper) for more innovative tools and updates! 🔗

## 📋 Table of Contents

- [🎥 Demo](#-demo)
- [📦 Installation Commands](#-installation-commands)
- [🛠️ Setup](#-setup)
- [📖 Usage](#-usage)
- [🔧 Requirements](#-requirements)
- [⚠️ Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)
- [🙌 Acknowledgments](#-acknowledgments)


## 🎥 Demo

(screenshots coming soon):

```
╔══════════════════════════════════════════════════════╗
║       NGROK TERMUX INSTALLER v1.1.2 by xAI        ║
╠══════════════════════════════════════════════════════╣
║   ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗   ║
║   ████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗██║ ██╔╝   ║
║   ██╔██╗ ██║██║  ███╗██████╔╝██║   ██║█████╔╝    ║
║   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██╔═██╗    ║
║   ██║ ╚████║╚██████╔╝██║  ██║╚██████╔╝██║  ██╗   ║
║   ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ║
╠══════════════════════════════════════════════════════╣
║     Crafted by Resonex • Powered by Joker • 2025     ║
╚══════════════════════════════════════════════════════╝

Initializing ngrok installation... [09:47 AM WAT, June 02, 2025]
Checking internet connection...
Testing network [100%] ✓
Preparing dependencies [ 45%] ⠹
```

> **Note**: Run the script in Termux!

## 📦 Installation Commands

Get started with these commands to install and run the Ngrok Termux Installer:

```bash
# Install git if not already installed
pkg install git

# Clone the repository
git clone https://github.com/Resonex/ngrok.git

# Navigate to the repository
cd ngrok

# Make the script executable
chmod +x ngrok.sh

# Run the installer
./ngrok.sh or bash ngrok.sh
```

## 🛠️ Setup

### Prerequisites
- **Termux**: Installed on an Android device ([F-Droid](https://f-droid.org)).
- **Internet Connection**: Required for downloading ngrok.

### Steps
1. **Install Termux Dependencies**:
   ```bash
   pkg update && pkg upgrade
   pkg install termux-api
   ```

2. **Clone and Run**:
   Follow the [Installation Commands](#-installation-commands) above.

3. **Follow Prompts**:
   - Enter your ngrok authtoken (from [ngrok dashboard](https://dashboard.ngrok.com)) or press Enter to skip.

## 📖 Usage

After installation, start ngrok with:
```bash
ngrok
```

If you skipped the authtoken, configure it later:
```bash
ngrok authtoken <your-authtoken>
```

Join [CYBER SNIPPER](https://t.me/cyber_snipper) for tips, updates, and more tools! 📱

## 🔧 Requirements

- **Termux Environment**: Must be run in Termux (`/data/data/com.termux/files/usr`).
- **Packages**: `wget`, `unzip`, `termux-api` (installed by the script).
- **Architecture**: ARM by default (modify `NGROK_URL` for other architectures; see [ngrok downloads](https://ngrok.com/download)).
- **Permissions**: Grant storage permissions if needed:
  ```bash
  termux-setup-storage
  ```

## ⚠️ Troubleshooting

For further issues, open a [GitHub issue](https://github.com/Resonex/ngrok/issues) or join [CYBER SNIPPER](https://t.me/cyber_snipper).

## 🤝 Contributing

We welcome contributions to enhance this installer! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-animation`).
3. Commit changes (`git commit -m "Add new animation style"`).
4. Push to the branch (`git push origin feature/new-animation`).
5. Open a pull request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details and follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙌 Acknowledgments

- **Resonex**: Original script Owner.
- **CYBER SNIPPER**: Community support and updates ([join here](https://t.me/cyber_snipper)).
- **ngrok**: Robust tunneling solution.

---

⭐ **Star this repo** to show support!  
📢 Join [CYBER SNIPPER on Telegram](https://t.me/cyber_snipper) for more tools!  
💻 Crafted with ❤️ by Resonex.
