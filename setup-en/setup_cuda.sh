#!/bin/bash

CUDA_VERSION="11.7"

# Check the current CUDA version
function check_cuda_version {
    echo "---------Checking the current CUDA version--------"
    if command -v nvidia-smi > /dev/null 2>&1; then
        nvidia-smi
    else
        echo "nvidia-smi not found, please check if the NVIDIA driver is installed."
    fi

    if command -v nvcc > /dev/null 2>&1; then
        nvcc --version
        CURRENT_CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $6}' | sed 's/,//')
        if [ "$CURRENT_CUDA_WHOLE_VERSION" != "$CUDA_VERSION" ]; then
            echo "Current CUDA version is $CURRENT_CUDA_VERSION."
            echo "Do you want to reinstall CUDA $CUDA_VERSION? (yes/no)"
            read reinstall_cuda
            if [ "$reinstall_cuda" = "yes" ]; then
                echo "Uninstalling CUDA $CURRENT_CUDA_VERSION..."
                sudo /usr/local/c->uda-$CURRENT_CUDA_VERSION/bin/cuda-uninstaller
                install_cuda
            fi
        else
            echo "CUDA $CUDA_VERSION is already installed."
        fi
    else
        echo "nvcc not found, please check if CUDA is installed."
        install	cuda
    fi
}

# Install CUDA
function install_cuda {
    echo "---------Checking and installing CUDA $CUDA_VERSION--------"
    # Using the network installer instead of the local runfile for better management
    CUDA_REPO_PKG="cuda-repo-ubuntu$(lsb_release -sr | cut -d. -f1)04_${CUDA_VERSION}_amd64.deb"
    CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -sr | cut -d. -f1)04/x86_64/${CUDA_REPO_PKG}"

    wget ${CUDA_URL} -O ${CUDA_REPO_PKG}

    if [ $? -eq 0 ]; then
        sudo dpkg -i ${CUDA_REPO_PKG}
        sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -sr | cut -d. -f1)04/x86_64/7fa2af80.pub
        sudo apt-get update
        sudo apt-get install cuda-$CUDA_VERSION

        echo 'export PATH=/usr/local/cuda-$CUDA_VERSION/bin${PATH:+:${PATH}}' >> ~/.bashrc
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda-$CUDA_VERSION/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_FEAST}}' >> ~/.bashrc
        source ~/.bashrc
    else
        echo "Failed to download CUDA. Please check the URL and your internet connection."
    fi
}

check_cuda_version
