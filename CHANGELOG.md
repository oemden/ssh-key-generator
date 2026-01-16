# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-01-16

### Added

- Initial release of SSH Key Generator
- Default values initialization for key type (ed25519), size (4096), and output directory (~/.ssh/keys)
- Interactive prompting for key name when not provided via command-line arguments
- Interactive passphrase prompting when `-p` flag is provided without an argument
- Key existence validation before generation to prevent accidental overwrites
- Automatic output directory creation with `mkdir -p` if directory doesn't exist
- Proper file permissions setting:
  - Private key: `600` (read/write for owner only)
  - Public key: `644` (read/write for owner, read for others)
- Apple Keychain integration for storing SSH key passphrases on macOS
- Path expansion for `~` in output directory paths (expands to `${HOME}`)
- Usage message display when script is run without arguments
- Verbose mode (`-v` flag) for additional output including passphrase display
- Support for multiple key types (RSA, ed25519, etc.)
- Support for custom key sizes
- Support for custom output directories
- Command-line argument parsing with short and long option forms
- Version display (`-V` or `--version` flag)
- Help message (`-h` or `--help` flag)

### Changed

- N/A (initial release)

### Fixed

- N/A (initial release)

### Security

- Automatic setting of secure file permissions (600 for private keys, 644 for public keys)
- Key existence validation prevents accidental overwrites of existing keys
- Secure passphrase input (hidden) when prompting interactively

[0.0.1]: https://github.com/oem/ssh-key-generator/releases/tag/v0.0.1
