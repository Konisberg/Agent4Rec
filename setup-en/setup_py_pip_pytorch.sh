#!/bin/bash

# Define the required version information
PYTHON_VERSION="3.9.12"
PYTORCH_VERSION="1.13.1+cu117"

# Install Python and PyTorch
function install_python_pytorch {
    echo "---------Checking and handling the installation of Python and PyTorch--------"
    # Ensure the Conda command is available
    source ~/miniconda3/etc/profile.d/conda.sh
    conda init bash
    source ~/.bashrc
    
    echo "Current list of Conda environments:"
    conda env list
    
    echo "Do you need to create a new Conda environment? (yes/no)"
    read create_env
    
    if [ "$create_attr" = "yes" ]; then
        echo "Enter the name of the new environment (default is 'agent4rec'):"
        read env_name
        # Use 'agent4rec' as the default if no name is entered
        env_name=${env_name:-agent4rec}
        conda create -n $env_name python=$PYTHON_VERSION -y
        conda activate $env_name
    else
        echo "Please enter the name of the environment to activate:"
        read env_name
        conda activate $env_name
    fi
    
    # Install PyTorch and related libraries
    pip install torch==$PYTORCH_VERSION torchvision==0.14.1+cu117 torchaudio==0.13.1 -f https://download.pytorch.org/whl/torch_stable.html
}

# Check if pip is installed and attempt to upgrade
function check_pip {
    echo "---------Checking and handling the installation and version of pip--------"
    if type pip > /dev/null 2>&1; then
        echo "pip is installed, version information as follows:"
        pip --version
    else
        echo "pip is not installed. Install the latest version of pip now? (yes/no)"
        read install_pip
        if [ "$install_pip" = "yes" ]; then
            if type python > /dev/null 2>&1; then
                python -m ensurepip
                pip install --upgrade pip
                echo "pip has been installed and upgraded."
            else
                echo "Python is not installed, unable to install pip."
            fi
        fi
    fi
}

# Execute all checks and installations
echo "Starting to configure the environment and install necessary tools (python, pip, pytorch)..."
install_python_pytorch
check_pip

echo "Environment setup and tool checks are complete."
