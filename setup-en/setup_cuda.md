要升级CUDA到特定版本（如CUDA 11.7），通常需要按照以下步骤操作，因为NVIDIA没有提供直接的命令行升级工具。不过，您可以通过命令行下载并安装新版本的CUDA。

1. **卸载当前的CUDA版本**（如果需要保留多个版本，请忽略此步骤）:
   ```bash
   sudo apt-get --purge remove cuda
   ```

2. **清理旧版本的依赖**：
   ```bash
   sudo apt-get autoremove
   ```

3. **添加NVIDIA的包管理器仓库**（如果之前没有添加过的话）：
   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/3bf863cc.pub
   sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/ /"
   sudo apt-get update
   ```

4. **安装新版本的CUDA**（以CUDA 11.7为例）：
   ```bash
   sudo apt-get install cuda-11-7
   ```

这些步骤适用于使用基于Debian的系统（如Ubuntu）。如果您使用的是RedHat或Fedora等基于RPM的系统，安装命令会有所不同，使用`yum`或`dnf`代替`apt-get`。

注意，在安装新版本前，请确保您的GPU驱动支持您想要安装的CUDA版本。通常，更新CUDA也需要更新NVIDIA驱动。

安装完成后，您可能需要重新配置环境变量，比如：

```bash
export PATH=/usr/local/cuda-11.7/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.7/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

这样可以确保系统使用正确版本的CUDA。