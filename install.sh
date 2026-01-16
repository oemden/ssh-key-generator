#!/bin/bash
# gitremote.sh
# A Bash script to install gitremote.sh.
# Will be installed in /usr/local/bin/gitremote

VERSION="0.0.1"
INSTALL_PATH="/usr/local/bin/skg"
SCRIPT_SOURCE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ssh-key-generator.sh"

# Check if the script source file exists
if [ ! -f "${SCRIPT_SOURCE_PATH}" ]; then
    echo "Error: ssh-key-generator.sh not found in the current directory."
    exit 1
fi

# Check if the user has sudo privileges
if ! sudo -v; then
    echo "This script requires sudo privileges. Please run it with a user that has sudo access."
    exit 1
fi

# Install the script
echo "Installing SKG ssh-key-generator ${VERSION} to ${INSTALL_PATH} ..."
# Copy the script to the installation path
cp "${SCRIPT_SOURCE_PATH}" "${INSTALL_PATH}"
# Make the script executable
chmod +x "${INSTALL_PATH}"

echo "ssh-key-generator has been installed to ${INSTALL_PATH}"
ls -l "${INSTALL_PATH}"

echo "You can run it using the command: ssh-key-generator"
echo ""
echo "Installation complete! To use 'ssh-key-generator' immediately in this shell, run:"
echo ""
echo "  rehash    (for zsh)"
echo "  hash -r   (for bash)"
echo ""
echo "Or simply open a new terminal window."

exit 0
