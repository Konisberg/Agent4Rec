#!/bin/bash

# 定义所需的版本信息
PYTHON_VERSION="3.9.12"
PYTORCH_VERSION="1.13.1+cu117"
CUDA_VERSION="11.7"

# 检查当前的 CUDA 版本
function check_cuda_version {
    echo "---------检查当前的 CUDA 版本--------"
    if command -v nvcc > /dev/null 2>&1; then
        nvcc --version
    else
        echo "nvcc 未找到，请检查 CUDA 是否已安装。"
    fi

    if [ -f /usr/local/cuda/version.txt ]; then
        echo "CUDA 版本文件内容："
        cat /usr/local/cuda/version.txt
    else
        echo "未找到 CUDA 版本文件。"
    fi

    if command -v nvidia-smi > /dev/null 2>&1; then
        nvidia-smi | grep "CUDA Version"
    else
        echo "nvidia-smi 未找到，请检查 NVIDIA 驱动是否已安装。"
    fi
}

# 执行检查
check_cuda_version


# 安装 Python 和 PyTorch
function install_python_pytorch {
    echo "---------检查并处理 Python 和 PyTorch 的安装--------"
    source ~/miniconda3/etc/profile.d/conda.sh  # 确保 conda 命令可用
    conda init bash
    source ~/.bashrc
    echo "当前的 Conda 环境列表："
    conda env list
    echo "是否需要创建新的 Conda 环境？(yes/no)"
    read create_env
    if [ "$create_env" = "yes" ]; then
        echo "输入新环境的名称（默认为 'agent4rec'）："
        read env_name
        env_name=${env_name:-agent4rec}  # 如果未输入名称，则默认为 'agent4rec'
        conda create -n $env_name python=$PYTHON_VERSION -y
        conda activate $env_name
    else
        echo "请输入要激活的环境名称："
        read env_name
        conda activate $env_name
    fi
    pip install torch==$PYTORCH_VERSION torchvision==0.14.1+cu117 torchaudio==0.13.1 -f https://download.pytorch.org/whl/torch_stable.html
}

# 检测并处理 Homebrew 的安装
function check_brew {
    echo "---------检测并处理 Homebrew 的安装--------"
    if type brew > /dev/null 2>&1; then
        echo "Homebrew 已安装，版本信息如下："
        brew --version
    else
        echo "Homebrew 未安装。是否现在安装？(yes/no)"
        read install_brew
        if [ "$install_brew" = "yes" ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "Homebrew 安装完成。"
        fi
    fi
}

# 检查 pip 是否安装，并尝试升级
function check_pip {
    echo "---------检查并处理 pip 的安装与版本--------"
    if type pip > /dev/null 2>&1; then
        echo "pip 已安装，版本信息如下："
        pip --version
    else
        echo "pip 未安装。是否现在安装最新版本的 pip？(yes/no)"
        read install_pip
        if [ "$install_pip" = "yes" ]; then
            if type python > /dev/null 2>&1; then
                python -m ensurepip
                pip install --upgrade pip
                echo "pip 安装并升级完成。"
            else
                echo "Python 未安装，无法安装 pip。"
            fi
        fi
    fi
}

# 执行所有检查和安装
install_cuda
install_python_pytorch
check_brew
check_pip

echo "环境配置和工具检查完成。"
