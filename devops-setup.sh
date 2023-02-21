#!/bin/bash

# Install apt if not already installed
if ! command -v apt-get &> /dev/null; then
    if command -v yum &> /dev/null; then
        sudo yum install -y apt
    elif command -v brew &> /dev/null; then
        brew install apt
    else
        echo "Error: No supported package manager found."
        exit 1
    fi
fi

# Define list of packages to install
PACKAGES=("git" "python3" "virtualenv" "ansible" "docker" "terraform" "kubectl" "helm" "awscli" "packer" "jenkins" "prometheus" "grafana")

# Ask user if they want to continue with automatic installation
read -p "Do you want to continue with the automatic installation of these packages? [y/n]: " INSTALL
case $INSTALL in
    [yY])
        # Install all packages without further questions
        case $PKG_MGR in
            "apt-get") sudo apt-get update && sudo apt-get install -y ${PACKAGES[*]} ;;
            "yum") sudo yum update && sudo yum install -y ${PACKAGES[*]} ;;
            "brew") brew install ${PACKAGES[*]} ;;
        esac
        ;;
    [nN])
        # Do nothing and terminate the script
        exit 0
        ;;
    [pP])
        # Prompt user for which packages they want to install
        for PACKAGE in "${PACKAGES[@]}"; do
            read -p "Do you want to install $PACKAGE? [y/n]: " INSTALL_PKG
            case $INSTALL_PKG in
                [yY]) 
                    # Install package
                    case $PKG_MGR in
                        "apt-get") sudo apt-get install -y $PACKAGE ;;
                        "yum") sudo yum install -y $PACKAGE ;;
                        "brew") brew install $PACKAGE ;;
                    esac
                    ;;
                [nN])
                    # Do not install package
                    continue
                    ;;
                *)
                    # Prompt user for valid input
                    echo "Invalid input. Please enter 'y' or 'n'."
                    ;;
            esac
        done
        ;;
    [hH])
        # Open Github link in new browser tab
        xdg-open https://github.com/inventorSuraj &> /dev/null || open https://github.com/inventorSuraj &> /dev/null
        ;;
    *)
        # Prompt user for valid input
        echo "Invalid input. Please enter 'y', 'n', 'p', or 'h'."
        ;;
esac

exit 0
