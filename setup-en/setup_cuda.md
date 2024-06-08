## Installing CUDA 11.7 (while keeping CUDA 11.3)

To install CUDA 11.7 on Ubuntu 20.04.4 LTS while retaining the installed CUDA 11.3, you can refer to the README document below. This process involves adding NVIDIA's official package repository and then installing CUDA 11.7 without removing the already installed version of CUDA 11.3.

### Step 1: Adding NVIDIA's Package Manager Repository

First, ensure your system has the `software-properties-common` package installed to use the `add-apt-repository` command.

```bash
sudo apt update
sudo apt install software-properties-common
```

Add NVIDIA's GPG key and repository:

```bash
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
```
```bash 
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt update
```

### Step 2: Installing CUDA 11.7

Install CUDA 11.7, but do not uninstall the current CUDA 11.3.

```bash
sudo apt install cuda-11-7
```

### Step 3: Configuring Environment Variables

To easily switch CUDA versions from the command line, you need to automatically update your environment variables using the following shell script. This script will add the necessary environment variable definitions to your `~/.bashrc` file:

```bash
#!/bin/bash

# Detect which version of CUDA the user wishes to set
read -p "Please enter the CUDA version you wish to configure (e.g., 11.7): " cuda_version

# Add environment variables to ~/.bashrc, ensuring the same line is not added multiple times if the script is run repeatedly
if ! grep -q "export PATH=/usr/local/cargo/bin:\$PATH" ~/.bashrc; then
    echo "export PATH=/usr/local/cargo/bin:\$PATH" >> ~/.bashrc
fi

if ! grep -q "export LD_LIBRARY_PATH=/usr/local/cuda-\$cuda_version/lib64:\$LD_LIBRARY_PATH" ~/.bashrc; then
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-\$cuda_version/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc
fi

echo "Environment variables configured. Please restart your terminal or execute 'source ~/.bashrc' to apply the changes."
```

Or directly use the commands:
```bash 
echo 'export PATH=/usr/local/cuda-11.7/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
```

### Step 4: Reloading Environment Variables

After modifying the environment variables, reload them:

```bash
source ~/.bashrc
```

Or log in again to your user account.

### Step 5: Verifying Installation

Verify if CUDA 11.7 has been successfully installed:

```bash
nvcc --version
```

You should see the version information for CUDA 11.7. If you need to switch between the two versions, simply modify the paths in the environment variables.

### Conclusion

Now, both CUDA 11.3 and CUDA 11.7 are installed on your system, and you can choose which version to use as needed. If you have any issues, please refer to NVIDIA's [official documentation](https://developer.nvidia.com/cuda-downloads) or contact technical support.