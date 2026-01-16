# ssh-key-generator

**Version:** 0.0.2

## Project Overview

SSH Key Generator is a Bash script wrapper around `ssh-keygen` that simplifies the process of generating SSH keys with sensible defaults, interactive prompts, and optional Apple Keychain integration. It automates common tasks like directory creation, file permission setting, and key validation.

## Features

- **Default Values**: Sensible defaults for key type (ed25519), size (4096), and output directory (~/.ssh/keys)
- **Interactive Prompts**: Automatically prompts for key name and passphrase when not provided
- **Key Validation**: Checks if keys already exist before generation to prevent accidental overwrites
- **Automatic Directory Creation**: Creates output directory if it doesn't exist
- **Proper File Permissions**: Automatically sets correct permissions (600 for private key, 644 for public key)
- **Apple Keychain Integration**: Optional storage of passphrase in macOS Keychain
- **Path Expansion**: Automatically expands `~` to home directory in output paths
- **Verbose Mode**: Optional verbose output for debugging

## Installation

Install the script system-wide using the provided installation script:

```bash
./install.sh
```

This will install the script to `/usr/local/bin/skg` and make it executable. After installation, you can use the script from anywhere by running:

```bash
skg
```

Alternatively, you can run the script directly:

```bash
./ssh-key-generator.sh
```

## Usage

### Basic Usage

Generate a key with default settings (will prompt for key name):

```bash
./ssh-key-generator.sh
```

Generate a key with a specific name:

```bash
./ssh-key-generator.sh -n my_server_key
```

### Command-Line Options

| Option      | Long Form              | Description                                                      |
| ----------- | ---------------------- | ---------------------------------------------------------------- |
| `-h`        | `--help`               | Show help message and exit                                       |
| `-V`        | `--version`            | Show version and exit                                            |
| `-n`        | `--name`               | Key name (required, prompts if not provided)                     |
| `-t`        | `--type`               | Key type: `rsa`, `ed25519`, etc. (default: `ed25519`)            |
| `-s`        | `--size`               | Key size in bits: `2048`, `4096`, etc. (default: `4096`)         |
| `-p`        | `--passphrase`         | Passphrase (if no argument provided, will prompt securely)       |
| `-o`        | `--output`             | Output directory (default: `~/.ssh/keys`)                        |
| `-k`        | `--use-apple-keychain` | Store passphrase in Apple Keychain (macOS only)                  |
| `-v`        | `--verbose`            | Verbose mode, show more output including passphrase              |

### Default Values

The script uses the following defaults when options are not provided:

- **Type**: `ed25519`
- **Size**: `4096`
- **Passphrase**: Empty (no passphrase)
- **Output Directory**: `~/.ssh/keys`
- **Apple Keychain**: Disabled
- **Verbose**: Disabled

## Examples

### Example 1: Generate a key with defaults

```bash
./ssh-key-generator.sh -n github_key
```

This creates an ed25519 key with 4096 bits, no passphrase, in `~/.ssh/keys/github_key`.

### Example 2: Generate an RSA key with passphrase

```bash
./ssh-key-generator.sh -n server_key -t rsa -s 2048 -p my_secure_passphrase
```

### Example 3: Generate a key with interactive passphrase prompt

```bash
./ssh-key-generator.sh -n secure_key -p
```

The script will securely prompt for the passphrase (input is hidden).

### Example 4: Generate a key and store in Apple Keychain

```bash
./ssh-key-generator.sh -n mac_key -p my_passphrase -k
```

This generates a key and stores the passphrase in macOS Keychain for automatic unlocking.

### Example 5: Custom output directory

```bash
./ssh-key-generator.sh -n custom_key -o ~/my_keys
```

### Example 6: Verbose mode

```bash
./ssh-key-generator.sh -n debug_key -v
```

Shows additional output including the passphrase (if set).

### Example 7: Complete example with all options

```bash
./ssh-key-generator.sh -n production_key -t ed25519 -s 4096 -p secure_pass -o ~/.ssh/keys -k -v
```

## Key Validation

The script checks if a key with the specified name already exists in the output directory before generation. If either the private key (`${name}`) or public key (`${name}.pub`) exists, the script will:

- Display an error message showing which files exist
- Exit with code 1
- Not overwrite existing keys

This prevents accidental overwrites of existing keys.

## File Permissions

The script automatically sets proper file permissions after key generation:

- **Private Key**: `600` (read/write for owner only)
- **Public Key**: `644` (read/write for owner, read for others)

These permissions are required by SSH and prevent security warnings.

## Output Directory

- The default output directory is `~/.ssh/keys`
- The `~` is automatically expanded to your home directory
- The directory is created automatically if it doesn't exist
- You can specify a custom output directory with the `-o` option

## Apple Keychain Integration

On macOS, you can optionally store the SSH key passphrase in Apple Keychain using the `-k` flag. This allows macOS to automatically unlock the key when needed, eliminating the need to enter the passphrase manually.

**Note**: This feature is only available on macOS systems.

## Version

Current version: **0.0.1**

## Author

oem <oem@mobiloem>

## License

MIT License

Copyright (c) 2026 oemden

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
