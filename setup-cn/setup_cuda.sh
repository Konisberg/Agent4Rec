CUDA_VERSION="11.7"

# 检查当前的 CUDA 版本
function check_cuda_version {
    echo "---------检查当前的 CUDA 版本--------"
    if command -v nvidia-smi > /dev/null 2>&1; then
        nvidia-smi
    else
        echo "nvidia-smi 未找到，请检查 NVIDIA 驱动是否已安装。"
    fi

    if command -v nvcc > /dev/null 2>&1; then
        nvcc --version
        CURRENT_CUDA_VERSION=$(nvcc --version | grep "release" | awk '{print $6}' | sed 's/,//')
        if [ "$CURRENT_CUDA_VERSION" != "$CUDA_VERSION" ]; then
            echo "当前 CUDA 版本为 $CURRENT_CUDA_VERSION。"
            echo "是否重新安装 CUDA $CUDA_VERSION？(yes/no)"
            read reinstall_cuda
            if [ "$reinstall_cuda" = "yes" ]; then
                sudo /usr/local/cuda-$CURRENT_CUDA_VERSION/bin/uninstall_cuda_$CURRENT_CUDA_VERSION.pl
                install_cuda
            fi
        else
            echo "CUDA $CUDA_VERSION 已安装。"
        fi
    else
        echo "nvcc 未找到，请检查 CUDA 是否已安装。"
        install_cuda
    fi
}

# 安装 CUDA
function install_cuda {
    echo "---------检查并安装 CUDA $CUDA_VERSION--------"

    wget https://developer.nvidia.com/cuda-11-7-0-download-archive/cuda_${CUDA_VERSION}_linux.run -O cuda_${CUDA_VERSION}_linux.run

    if [ $? -eq 0 ]; then
        sudo sh cuda_${CUDA_VERSION}_linux.run
        export PATH=/usr/local/cuda-$CUDA_VERSION/bin${PATH:+:${PATH}}
        export LD_LIBRARY_PATH=/usr/local/cuda-$CUDA_VERSION/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    else
        echo "CUDA 下载失败，请检查链接是否有效。"
    fi
}

check_cuda_version
