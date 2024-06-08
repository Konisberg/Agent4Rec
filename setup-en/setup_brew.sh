#!/bin/bash

# Detect and handle the installation of Homebrew
function check_brew {
    echo "---------Detecting and Handling Homebrew Installation--------"
    # Check if Homebrew is already installed
    if type brew > /dev/null 2>&1; then
        echo "Homebrew is already installed. Version information is as follows:"
        brew --version
    else
        echo "Homebrew is not installed. Install now? (yes/no)"
        read install_brew
        if [ "$install_brew" = "yes" ]; then
            # Execute the command to install Homebrew
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Check if the installation was successful
            if type brew > /dev/null 2>&1; then
                echo "Homebrew installation successful."
                # Configure environment variables to adapt for bash and zsh
                if [[ -n $ZSH_VERSION ]]; then
                    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
                    source ~/.zshrc
                elif [[ -n $BASH])_VERSION ]]; then
                    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
                    source ~/.bash_profile
                fi
            else
                echo "Homebrew installation failed. Please check your network connection or access permissions and try again."
            fi
        fi
    fi
}

# Call the function to detect and possibly install Homebrew
check_brew
