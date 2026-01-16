#!/bin/bash

# Ultra basic ssh Keygen wrapper to easily generate new ssh keys.
# Usage: ./ssh-key-generator.sh
# Author: oemden
# Date: 2026-01-16
# License: MIT
# Copyright (c) 2026 oemden
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights

version="0.0.2"
default_type="ed25519"
default_size="4096"
default_passphrase="" # no passphrase use -p to set it
default_output_dir="~/.ssh/keys" # default output directory

usage() {
    echo "SSH Key Generator v${version}"
    echo "Usage: ./ssh-key-generator.sh"
    echo "Usage: skg (if installed in /usr/local/bin/skg)"
    echo "       -h, --help      Show this help message and exit"
    echo "       -V, --version   Show the version and exit"
    echo "       -n, --name      Enter the name of the ssh Key (my_server_key, my_github_key, etc.)"
    echo "       -t, --type      Enter the type of the ssh Key (rsa, ed25519, etc.)"
    echo "       -i, --type-include      Include the type in the ssh Key comment (default: false) - syntax: id_<type>_<name> example: id_ed25519_my_server_key"
    echo "       -s, --size      Enter the size of the ssh Key (2048, 4096, etc.)"
    echo "       -p, --passphrase Enter the passphrase of the ssh Key (if no arg provided, will prompt)"
    echo "       -c, --comment   Add custom john@doe.com comment to the ssh Key (Initialized with john@doe.com value if not set when the key was generated)"
    echo "       -o, --output    Enter the output directory (default: ~/.ssh)"
    echo "       -k, --use-apple-keychain    Use Apple Keychain to store the ssh Key passphrase"
    echo "       -v, --verbose   Verbose mode, show more output including the passphrase (default: false)"
    # echo "       -l, --load-apple-keychain    Load the ssh Key passphrase from Apple Keychain in the creation process - only if -k is provided"
    # echo "       -f, --force     Force overwrite existing ssh Key"
    # echo "       -q, --quiet     Quiet mode, no output"
    echo "Example: ./generate_new_keychain.sh -n my_server_key -t ed25519 -s 4096 -p my_passphrase -o ~/.ssh/keys -k -c \"john@doe.com\" "
    echo "Example: skg -n my_server_key -t rsa -s 2048 -p  -o ~/.ssh/keys -k -v -c \"john@doe.com\" - Use will be prompted for a passphrase if -p as no arg provided"
    echo "Example: skg -n my_server_key -t ed25519 -s 4096 -p -k -v -c \"john@doe.com\" -i - Include the type in the ssh Key Name (id_ed25519_my_server_key) - User will be prompted for a passphrase if -p as no arg provided"
    echo "Note: skg -n \"gitlab\" -t ed25519 -i -c \"john@doe.com\" is the same as skg -n \"id_ed25519_gitlab\" -t ed25519 -c \"john@doe.com\" and will create an ssh key named \"id_ed25519_gitlab\""
    echo "script defaults are: type=${default_type}, size=${default_size}, passphrase=${default_passphrase}, output_dir=${default_output_dir}, use_apple_keychain=false, verbose=false"
}

parse_arguments() {
    # Current flags: -h, -V, -n, -t, -s, -p, -o
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
            ;;
            -V|--version)
                echo "Version: $version"
                exit 0
            ;;
            -n|--name)
                name=$2
                shift 2
            ;;
            -t|--type)
                type=$2
                shift 2
            ;;
            -s|--size)
                size=$2
                shift 2
            ;;
            -p|--passphrase)
                # Check if next argument exists and is not an option
                if [ $# -gt 1 ] && [[ ! "$2" =~ ^- ]]; then
                    passphrase=$2
                    shift 2
                else
                    # -p provided but no argument, flag to prompt later
                    prompt_for_passphrase=true
                    shift 1
                fi
            ;;
            -k|--use-apple-keychain)
                use_apple_keychain=true
                shift 1
            ;;
            -o|--output)
                output_dir=$2
                shift 2
            ;;
            -v|--verbose)
                verbose=true
                shift 1
            ;;
            -c|--comment)
                comment=$2
                shift 2
            ;;
            -i|--type-include)
                type_include=true
                shift 1
            ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
            ;;
        esac
    done
}

check_key_exists() {
    # Check if key files already exist
    if [ -f "${output_dir}/${name}" ] || [ -f "${output_dir}/${name}.pub" ]; then
        echo "Error: Key with name '${name}' already exists in ${output_dir}"
        echo "Private key: ${output_dir}/${name}"
        echo "Public key: ${output_dir}/${name}.pub"
        exit 1
    fi
}

create_ssh_key() {
    # Check if key already exists
    check_key_exists
    
    # Create output directory if it doesn't exist
    mkdir -p "${output_dir}"
    if [ $? -ne 0 ]; then
        echo "Failed to create output directory: ${output_dir}"
        exit 1
    fi
    

    # Build ssh key name with type include if requested
    if [ "${type_include}" = true ]; then
        key_name="id_${type}_${name}"
    else
        key_name="${name}"
    fi
    # Build ssh-keygen command with passphrase handling
    # Use -N with passphrase (empty string if no passphrase)
    ssh-keygen -t ${type} -b ${size}  -f "${output_dir}/${key_name}" -N "${passphrase}" -q -C "${comment}"
    
    if [ $? -ne 0 ]; then
        echo "Failed to create ssh key"
        exit 1
    fi
    
    # Set proper file permissions
    chmod 600 "${output_dir}/${key_name}"
    chmod 644 "${output_dir}/${key_name}.pub"
    
    echo "SSH key created successfully"
    echo "Private key: ${output_dir}/${key_name}"
    echo "Public key: ${output_dir}/${key_name}.pub"
    
    if [ -n "${passphrase}" ] && [ "${verbose}" = true ]; then
        echo "SSH key passphrase: ${passphrase}"
    fi
}

store_ssh_key_in_apple_keychain() {
    if [ "$use_apple_keychain" = true ]; then
        echo "Storing ssh key passphrase in Apple Keychain"
        # security add-generic-password -a $name -s $name -w $passphrase -j $type -l $size
        ssh-add --apple-use-keychain "${output_dir}/${key_name}"
        if [ $? -ne 0 ]; then
            echo "Failed to store ssh key passphrase in Apple Keychain"
            exit 1
        fi
        echo "SSH key passphrase stored in Apple Keychain successfully"
    fi
}

main() {
    # Check if no arguments provided, show usage first
    if [ $# -eq 0 ]; then
        usage
        echo ""
    fi
    
    # Initialize variables with default values
    type=${default_type}
    size=${default_size}
    passphrase=${default_passphrase}
    output_dir=${default_output_dir}
    use_apple_keychain=false
    verbose=false
    prompt_for_passphrase=false
    name=""
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Expand ~ to ${HOME} in output directory path
    output_dir="${output_dir/#\~/${HOME}}"
    
    # Prompt for name if not provided
    if [ -z "${name}" ]; then
        read -p "Enter key name: " name
        if [ -z "${name}" ]; then
            echo "Error: Key name is required"
            exit 1
        fi
    fi
    
    # Prompt for passphrase if -p was provided without argument
    if [ "${prompt_for_passphrase}" = true ]; then
        read -sp "Enter passphrase: " passphrase
        echo ""
        if [ -z "${passphrase}" ]; then
            echo "Warning: Empty passphrase will be used"
        fi
    fi
    
    # Create SSH key
    create_ssh_key
    
    # Store in Apple Keychain if requested
    if [ "${use_apple_keychain}" = true ]; then
        store_ssh_key_in_apple_keychain
    fi
}

# Call main function with all arguments
main "$@"
