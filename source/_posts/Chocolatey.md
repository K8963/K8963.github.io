---
title: Windows 包管理工具
date: 2021-10-11 12:10:00
comments: false
author: 8963
tags:
  - 工具
categories:
  - Other
---

Chocolatey、Scoop包管理工具

<!-- more -->

# Chocolatey 

## Chocolatey 是什么?

Chocolatey是一款专为Windows系统开发的、基于NuGet的包管理器工具，类似于Node.js的npm，MacOS的brew，Ubuntu的apt-get，它简称为choco。Chocolatey的设计目标是成为一个去中心化的框架，便于开发者按需快速安装应用程序和工具。
[Chocolatey官网](https://chocolatey.org/) 

## 安装 Chocolatey

以管理员方式运行`PowerShell`, 安装命令

```bash
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

![image-20211023100026524](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211023100026524.png)

安装成功:

![image-20211023100209863](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211023100209863.png)



## 安装包

作者君安装 `Chocolatey` 的目的是安装 `neovim`

```bash
choco install neovim
```

速度堪忧......

安装失败,或许是需要梯子

![image-20211023101418708](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211023101418708.png)

# Chocolatey卸载

卸载`Chocolatey`只需要删除它安装的文件夹，并删除对应的环境变量即可。对于使用`Chocolatey`安装的其它软件，如果也需要卸载的话，需要先手动卸载。

> 删除环境变量`ChocolateyInstall`对应的安装文件夹，默认是 `C:\ProgramData\chocolatey`

# Scoop

## Scoop是什么?

Scoop是Windows的命令行安装程序，是一个强大的包管理工具。

## 安装Scoop

安装环境

- 用户名不含中文字符
- Windows 7 SP1+ / Windows Server 2008+
- [PowerShell 3+](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.microsoft.com%2Fen-us%2Fdownload%2Fdetails.aspx%3Fid%3D34595)
- [.NET Framework 4.5+](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.microsoft.com%2Fnet%2Fdownload)

```bash
$PSVersionTable.PSVersion.Major   #查看Powershell版本
$PSVersionTable.CLRVersion.Major  #查看.NET Framework版本
```

设置环境变量

```
$env:SCOOP='D:\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP',$env:SCOOP,'User')
$env:SCOOP_GLOBAL='D:\ScoopGlobalApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL,'User')
```

安装

```
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
## 或者
iwr-useb get.scoop.sh|iex
```

这个过程需要梯子

![image-20211023102717278](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211023102717278.png)

## 报错

