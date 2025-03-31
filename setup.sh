#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if [ -f "wininfected" ]; then
  sudo chmod +x wininfected
else
  echo "Error: WinInfected file not found."
  exit 1
fi

if sudo cp wininfected.sh /usr/bin/wininfected; then
  echo "WinInfected installed successfully."
  echo
  echo "Usage: sudo wininfected [LHOST] [LPORT] [--obfuscate]"
  echo
  echo "Example: sudo wininfected 192.168.1.1 4444 --obfuscate"
  echo "Options:"
  echo "  --dependencies   Check and install missing dependencies."
  echo "  --update         Update script and dependencies."
  echo "  --obfuscate      Enable payload obfuscation using x86/shikata_ga_nai encoder."
  echo "  -h, --help       Display this help message."
  echo
  echo "More information: https://github.com/byfranke/WinInfected"
  echo " byfranke.com | 2025"
  echo
else
  echo "Error: Failed to copy WinInfected to /usr/bin."
  exit 1
fi
