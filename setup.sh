#!/bin/bash
set -e

echo "Installing WinInfected..."

# Cria link simbólico para acesso global ao script principal
chmod +x wininfected.sh
ln -sf "$(pwd)/wininfected.sh" /usr/local/bin/wininfected

echo "WinInfected installed successfully."

cat <<EOF

Usage: sudo wininfected [LHOST] [LPORT] [--obfuscate]

Example: sudo wininfected 192.168.1.1 4444 --obfuscate
Options:
  --dependencies   Check and install missing dependencies.
  --update         Update script and dependencies.
  --obfuscate      Enable payload obfuscation using x86/shikata_ga_nai encoder.
  -h, --help       Display this help message.

More information: https://github.com/byfranke/wininfected
 byfranke.com | 2025

EOF
