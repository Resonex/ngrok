# Release Notes for Ngrok Termux Installer

## v1.1.2 - June 02, 2025

### 🚀 Overview
The **Ngrok Termux Installer v1.1.2** is a polished, feature-rich script for installing ngrok in Termux with a futuristic UI. This release introduces robust network checks and enhances the user experience with a professional, 2025-ready design.

### ✨ Features
- **Advanced UI**: Double-line borders, vibrant colors (cyan, light cyan, yellow, green), and a sleek ASCII banner.
- **Smooth Animations**: Braille-based loading animations (`⠋⠙⠹⠸⠼⠴⠦⠧`) with percentage counters.
- **Network Checks**:
  - Pre-installation internet check using `ping`.
  - Network disruption detection for download and authtoken steps.
- **Silent Installation**: Hides verbose outputs for a clean experience.
- **Authtoken Prompt**: Configures ngrok authtoken with a skip option.
- **Community Integration**: Opens [CYBER SNIPPER](https://t.me/cyber_snipper) post-installation.
- **Error Handling**: Clear, bordered messages for Termux and network errors.

### 🛠️ Changelog
- **Added**: Internet connectivity check before installation.
- **Added**: Network error detection for `wget` and `ngrok authtoken`.
- **Fixed**: Early exit issue during dependency installation.
- **Improved**: UI with consistent spacing and color gradients.
- **Updated**: Version to `1.1.2` with Joker branding.

### 🔧 Upgrade Instructions
1. Pull the latest changes:
   ```bash
   git pull origin main
   ```
2. Ensure `install_ngrok.sh` is executable:
   ```bash
   chmod +x install_ngrok.sh
   ```
3. Run the updated script:
   ```bash
   ./install_ngrok.sh
   ```

### 📋 Known Issues
- Some devices may require `termux-api` for Telegram link functionality:
  ```bash
  pkg install termux-api
  ```
- Non-ARM architectures need a custom `NGROK_URL` (see [ngrok downloads](https://ngrok.com/download)).

### 📢 Get Involved
Join [CYBER SNIPPER](https://t.me/cyber_snipper) for updates and community support!  
Report issues or suggest features on [GitHub](https://github.com/Resonex/ngrok/issues).

---

💻 Crafted by Resonex, powered by Joker.
