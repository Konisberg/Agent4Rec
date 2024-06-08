#!/bin/bash

# 定义所需的版本信息
PYTHON_VERSION="3.9.12"
PYTORCH_VERSION="1.13.1+cu117"

# 安装 Python 和 PyTorch
function install_python_pytorch {
    echo "---------检查并处理 Python 和 PyTorch 的安装--------"
    # 确保 Conda 命令可用
    source ~/miniconda3/etc/profile.d/conda.sh
    conda init bash
    source ~/.bashrc
    
    echo "当前的 Conda 环境列表："
    conda env list
    
    echo "是否需要创建新的 Conda 环境？(yes/no)"
    read create_env
    
    if [ "$create_env" = "yes" ]; then
        echo "输入新环境的名称（默认为 'agent4rec'）："
        read env_name
        # 如果未输入名称，则默认为 'agent4rec'
        env_name=${env_name:-agent4rec}
        conda create -n $env_name python=$PYTHON_VERSION -y
        conda activate $env_name
    else
        echo "请输入要激活的环境名称："
        read env_name
        conda activate $env_name
    fi
    
    # 安装 PyTorch 及相关库
    pip install torch==$PYTORCH_VERSION torchvision==0.14.1+cu117 torchaudio==0.13.1 -f https://download.pytorch.org/whl/torch_stable.html
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
echo "开始配置环境和安装必要的工具(python, pip, pytorch)..."
install_python_pytorch
check_pip

echo "环境配置和工具检查完成。"
