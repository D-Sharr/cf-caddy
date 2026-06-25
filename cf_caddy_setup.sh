#!/bin/bash

#Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}    Caddy + Cloudflare DNS Auto Setup Script        ${RESET}"
echo -e "${GREEN}    made with ❤️ by Dev H2 (GitHub: D-Sharr)        ${RESET}"
echo -e "${GREEN}====================================================${RESET}"

# Root Check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Run this script as root!${RESET}" 
   exit 1
fi

# (1) Input Required Information
read -p "1. Domain Name (e.g., vps.example.com): " DOMAIN
read -p "2. Cloudflare API Token: " CF_TOKEN
read -p "3. VPN Path (e.g., /src/assets): " WS_PATH
read -p "4. Backend Port (3x-ui port - e.g., 58834): " VLESS_PORT
read -p "5. Webpage Heading Text: " WEB_TEXT

# (23) Caddy Official Install
echo -e "${GREEN}[+] Installing Base Caddy...${RESET}"
apt update && apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update && apt install caddy -y
systemctl stop caddy

# (3) Cloudflare Plugin Caddy Replace
echo -e "${GREEN}[+] Replacing with Cloudflare-Plugin Caddy...${RESET}"
curl -sL "https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com/caddy-dns/cloudflare" -o /usr/bin/caddy
chmod +x /usr/bin/caddy

# (4) Web UI  
mkdir -p /var/www/html
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API Status</title>
    <style>
        /* Base Reset & Typography */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
            color: #f8fafc;
        }

        /* Modern Glassmorphism Card */
        .card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 24px;
            padding: 3rem 2rem;
            width: 90%;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            position: relative;
            overflow: hidden;
        }

        /* Decorative background glow */
        .card::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: #06b6d4;
            filter: blur(80px);
            opacity: 0.3;
            z-index: 0;
        }

        /* Robot Container */
        .robot-container {
            position: relative;
            z-index: 1;
            margin-bottom: 2rem;
            /* Floating Animation */
            animation: float 4s ease-in-out infinite;
        }

        /* Robot SVG Styling */
        .robot-svg {
            width: 140px;
            height: 140px;
            filter: drop-shadow(0 10px 15px rgba(6, 182, 212, 0.2));
        }

        /* SVG Inner Animations */
        .eyes {
            transform-origin: 50% 55px;
            animation: blink 4s infinite;
        }

        .antenna-bulb {
            animation: pulse-glow 2s ease-in-out infinite;
        }

        /* Text Content */
        .content {
            position: relative;
            z-index: 1;
        }

        h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(to right, #22d3ee, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* --- Keyframe Animations --- */
        
        /* Floating effect for the whole robot */
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        /* Blinking effect for the eyes */
        @keyframes blink {
            0%, 96%, 98% { transform: scaleY(1); }
            97%, 100% { transform: scaleY(0.1); }
        }

        /* Pulsing glow for the antenna */
        @keyframes pulse-glow {
            0%, 100% { fill: #fde047; filter: drop-shadow(0 0 2px #fde047); }
            50% { fill: #ca8a04; filter: drop-shadow(0 0 10px #eab308); }
        }
    </style>
</head>
<body>

    <div class="card">
        <div class="robot-container">
            <!-- Custom Inline SVG Robot -->
            <svg viewBox="0 0 100 100" class="robot-svg" xmlns="http://www.w3.org/2000/svg">
                <!-- Antenna Line -->
                <line x1="50" y1="35" x2="50" y2="15" stroke="#475569" stroke-width="4" stroke-linecap="round"/>
                
                <!-- Antenna Bulb -->
                <circle cx="50" cy="12" r="6" fill="#fde047" class="antenna-bulb"/>
                
                <!-- Left Ear -->
                <rect x="12" y="52" width="8" height="16" rx="4" fill="#334155"/>
                
                <!-- Right Ear -->
                <rect x="80" y="52" width="8" height="16" rx="4" fill="#334155"/>
                
                <!-- Main Head -->
                <rect x="20" y="35" width="60" height="50" rx="16" fill="#1e293b" stroke="#3b82f6" stroke-width="3"/>
                
                <!-- Inner Face Plate -->
                <rect x="28" y="43" width="44" height="34" rx="8" fill="#0f172a"/>
                
                <!-- Eyes Group -->
                <g class="eyes">
                    <circle cx="38" cy="55" r="5" fill="#22d3ee" />
                    <circle cx="62" cy="55" r="5" fill="#22d3ee" />
                </g>
                
                <!-- Friendly Mouth -->
                <path d="M 42 68 Q 50 74 58 68" stroke="#22d3ee" stroke-width="2.5" fill="none" stroke-linecap="round"/>
            </svg>
        </div>

        <div class="content">
            <h1>${WEB_TEXT}</h1>
        </div>
    </div>

</body>
</html>
EOF
chown -R caddy:caddy /var/www/html

# (5) Caddyfile Generate
cat <<EOF > /etc/caddy/Caddyfile
${DOMAIN} {
    tls {
        dns cloudflare ${CF_TOKEN}
    }
    root * /var/www/html
    file_server
    reverse_proxy ${WS_PATH} 127.0.0.1:${VLESS_PORT} {
        header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
    }
}
EOF

# (6) Restart Caddy
systemctl enable caddy
systemctl restart caddy

echo -e "${GREEN}====================================================${RESET}"
echo -e "${GREEN}        Caddy Setup Successfully Completed!         ${RESET}"
echo -e "${GREEN}====================================================${RESET}"
echo -e "Domain: https://${DOMAIN}"
echo -e "Proxy Path: ${WS_PATH} -> 127.0.0.1:${VLESS_PORT}"
