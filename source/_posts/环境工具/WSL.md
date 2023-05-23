---
title: WSL
date: 2023-05-18 01:10:00
comments: false
author: 8963
tags:
  - WSL
  - 开发环境
categories:
  - 环境工具
---

WSL常用命令、安装docker

<!-- more -->

# 常用命令

## 启动与停止

```shell
# 启动默认 Linux 分发版
wsl
 
# 以指定用户身份运行 Linux 分发版
wsl -u <username>
 
# 运行指定的 Linux 分发版
wsl -d <Linux分发版名称>
 
# 退出 Linux 分发版
exit
 
# 终止指定的分发
wsl -t <Linux分发版名称>
 
# 终止所有运行的分发及 WSL 轻型工具虚拟机
wsl --shutdown
```



## 查看

```
# 列出已安装且可供使用的 Linux 分发版
wsl -l
 
# 列出所有分发，包括当前不可用的分发
wsl -l --all
 
# 仅列出当前正在运行的分发
wsl -l --running
 
# 仅显示分发名称
wsl -l -q
 
# 显示所有分发的详细信息
wsl -l -v
```



## 安装与卸载

```
# 列出可安装 Linux 分发版
wsl -l -o
 
# 安装指定 Linux 分发版
wsl --install -d <Linux分发版名称>
 
# 卸载 Linux 分发版，卸载后可以重新安装
wsl --unregister <Linux分发版名称>
```



## 导入与导出

```
# 导入 Linux 分发版, 可加 --version 指定要用于新分发的版本
wsl --import <Linux分发版名称> <安装位置> <文件名>
 
# 导出 Linux 分发版，后缀名请以 tar 结尾
wsl --export <Linux分发版名称> <路径>
```



## 其他

```
# 设置默认 Linux 分发版
wsl -s <Linux分发版名称>
 
# 在不使用默认 Linux Shell 的情况下执行指定的命令
wsl -e <命令行>
 
# 更改新分发的默认安装版本
wsl --set-default-version <版本>
 
# 更新 WSL2 内核到最新版本
wsl --update
 
# 还原到 WSL2 内核的先前版本
wsl --update --rollback
 
# 更改指定分发的版本
wsl --set-version <Linux分发版名称> <版本>
```



# 安装docker

查看系统并启动默认系统

![image-20230523003712798](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305231208968.png)

更换Ubuntu官方源为国内源，加快下载速度

```
vim /etc/apt/sources.list
```

替换为：

```
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal universe
deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe
deb http://mirrors.aliyun.com/ubuntu/ focal multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-security universe
deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse
```

接下来添加Docker源，依次执行：

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update
```

完成

# Docker Desktop for Windows

Docker Desktop windows版已经能够支持WSL作为Docker Engine运行

1. 浏览器打开[https://www.docker.com/products/docker-desktop](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.docker.com%2Fproducts%2Fdocker-desktop)
    点击Download for Windows (stable)，下载Docker安装程序。
2. 确保WSL内的Docker已经卸载，如果没有卸载，可以执行：



```shell
sudo apt remove docker-ce
sudo apt remove docker-ce-cli
```

3.  双击下载的安装程序安装，记住选择使用WSL作为Docker引擎。
4. 在Windows注销当前用户重新登录。到此Docker Desktop for Windows安装完毕。

注意：如果发现在WSL下无法执行docker命令，可以通过如下操作打开：
进入Docker Desktop的settings，如下所示：
