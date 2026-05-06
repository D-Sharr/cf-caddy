# CF-Caddy Auto Setup Script 🛡️

An automated bash script to easily set up **Caddy Server** with the **Cloudflare DNS plugin**. This script is designed to create a stealthy Web UI that acts as a front for WebSocket-based VPNs (like VLESS, VMess, or Trojan via 3x-ui), automatically handling SSL certificates through the Cloudflare API challenge.

## ✨ Features
* **One-Click Installation:** Fully automates the installation of Caddy and the custom Cloudflare DNS module.
* **Auto SSL Certificate:** Obtains and renews Let's Encrypt certificates automatically via Cloudflare API, even if the domain is proxied (☁️ Orange Cloud).
* **Stealth Web UI:** Generates a lightweight, customizable dummy HTML page to hide your VPN endpoint from active probing.
* **Smart Reverse Proxy:** Forwards requests matching your secure path to the local VPN core (e.g., `127.0.0.1:58834`) while returning `404 Not Found` for unauthorized paths.

## 📋 Prerequisites
Before running the script, ensure you have:
1. A VPS running **Ubuntu / Debian**.
2. **Root (sudo) privileges**.
3. A domain name actively managed on **Cloudflare**.
4. A **Cloudflare API Token** with `Zone -> DNS -> Edit` permissions.

## 🚀 Quick Start (One-Liner)

Log in to your VPS terminal as root and run the following command:
```bash
bash <(curl -Ls [https://raw.githubusercontent.com/D-Sharr/cf-caddy/refs/heads/main/cf_caddy_setup.sh](https://raw.githubusercontent.com/D-Sharr/cf-caddy/refs/heads/main/cf_caddy_setup.sh))
