为了在Ubuntu 20.04.4 LTS上安装CUDA 11.7，同时保留已安装的CUDA 11.3，您可以参考下面的README文档。这个过程涉及添加NVIDIA官方的包仓库，然后安装CUDA 11.7，同时不会移除已安装的CUDA 11.3版本。

### 安装CUDA 11.7（保留CUDA 11.3）

#### 步骤 1: 添加NVIDIA的包管理器仓库

首先，确保您的系统已经安装了`software-properties-common`包，以便使用`add-apt-repository`命令。

```bash
sudo apt update
sudo apt install software-properties-common
```

添加NVIDIA的GPG key和仓库：

```bash
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
```
```bash 
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt update
```

#### 步骤 2: 安装CUDA 11.7

安装CUDA 11.7，但不卸载当前的CUDA 11.3。

```bash
sudo apt install cuda-11-7
```

#### 步骤 3: 配置环境变量

为了能够在命令行中轻松切换CUDA版本，您需要通过以下Shell脚本自动更新您的环境变量。该脚本将向您的`~/.bashrc`文件添加必要的环境变量定义：

```bash
#!/bin/bash

# 检测用户希望设置哪个版本的CUDA
read -p "请输入您希望配置的CUDA版本（例如: 11.7）: " cuda_version

# 添加环境变量到~/.bashrc，确保重复运行脚本不会重复添加相同的行
if ! grep -q "export PATH=/usr/local/cargo/bin:\$PATH" ~/.bashrc; then
    echo "export PATH=/usr/local/cargo/bin:\$PATH" >> ~/.bashrc
fi

if ! grep -q "export LD_LIBRARY_PATH=/usr/local/cuda-\$cuda_version/lib64:\$LD_LIBRARY_PATH" ~/.bashrc; then
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-\$cuda_version/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc
fi

echo "环境变量配置完成，请重新启动终端或执行 'source ~/.bashrc' 来应用更改。"
```

#### 步骤 4: 重新加载环境变量

修改环境变量后，需要重新加载它们：

```bash
source ~/.bashrc
```

或者重新登录您的用户账户。

#### 步骤 5: 验证安装

验证CUDA 11.7是否安装成功：

```bash
nvcc --version
```

您应该看到CUDA 11.7的版本信息。如果您需要在两个版本之间切换，只需修改环境变量中的路径即可。

#### 结束

现在，您的系统上同时安装了CUDA 11.3和CUDA 11.7，您可以根据需要选择使用哪个版本。如果您有任何问题，请查阅NVIDIA的[官方文档](https://developer.nvidia.com/cuda-downloads)或联系技术支持。