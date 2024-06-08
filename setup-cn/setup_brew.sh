#!/bin/bash

# 检测并处理 Homebrew 的安装
function check_brew {
    echo "---------检测并处理 Homebrew 的安装--------"
    # 检测 Homebrew 是否已安装
    if type brew > /dev/null 2>&1; then
        echo "Homebrew 已安装，版本信息如下："
        brew --version
    else
        echo "Homebrew 未安装。是否现在安装？(yes/no)"
        read install_brew
        if [ "$install_brew" = "yes" ]; then
            # 执行安装 Homebrew 的命令
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # 检测安装是否成功
            if type brew > /dev/null 2>&1; then
                echo "Homebrew 安装成功。"
                # 配置环境变量，适配 bash 和 zsh
                if [[ -n $ZSH_VERSION ]]; then
                    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
                    source ~/.zshrc
                elif [[ -n $BASH_VERSION ]]; then
                    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
                    source ~/.bash_profile
                fi
            else
                echo "Homebrew 安装失败，请检查网络连接或访问权限后重试。"
            fi
        fi
    fi
}

# 调用函数检测并可能安装 Homebrew
check_brew
