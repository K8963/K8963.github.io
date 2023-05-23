---
title:CentOS
date:2022-01-18 23:10:00
comments:false
author:8963
tags:
  - Linux
categories:
  - 环境工具
---

CentOS

<!-- more -->

[下载地址](https://mirrors.aliyun.com/centos/7/isos/x86_64/)

各个版本的ISO镜像文件说明：

CentOS-7-x86_64-DVD-1708.iso 标准安装版（推荐）

CentOS-7-x86_64-Everything-1708.iso 完整版，集成所有软件（以用来补充系统的软件或者填充本地镜像）

CentOS-7-x86_64-LiveGNOME-1708.iso GNOME桌面版

CentOS-7-x86_64-LiveKDE-1708.iso KDE桌面版

CentOS-7-x86_64-Minimal-1708.iso 精简版，自带的软件最少

CentOS-7-x86_64-NetInstall-1708.iso 网络安装版（从网络安装或者救援系统）

# 退出登录

```
［xxq@loclhost xxq］ $ exit
```



# 配置网络

```
cd /etc/sysconfig/network-scripts/ 进入这个目录
vi ifcfg-enp0s3 修改配置文件
```

动态分配一个ip地址

```
ONBOOT=yes
```

重启一下网络， 就可以看到自动分配的ip地址了。

```
service network restart
ip addr
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122324923.png)

再次编辑`ifcfg-enp0s3`

```
vi ifcfg-enp0s3
```

修改 **BOOTPROTO** 为 **static** ，依次设置静态ip，掩码，网关。

```
BOOTPROTO=static
IPADDR=192.168.10.10
NETMASK=255.255.255.0
GATEWAY=192.168.10.55
```

配置DNS

```
检查NetManager的状态：systemctl status NetworkManager.service
检查NetManager管理的网络接口：nmcli dev status
检查NetManager管理的网络连接：nmcli connection show
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122324970.png)

设置dns

```
nmcli con mod enp0s3 ipv4.dns “114.114.114.114 8.8.8.8”
```

让dns配置生效 

```
nmcli con up enp0s3
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122324739.png)

完成上述步骤就可以用 ping 命令 ping一下 本地ip 是否可以ping 通

```
ping 10.0.2.15
```

注意:如果ping不通关闭本地防火墙就可以了。

```
# 关闭防火墙 
systemctl stop firewalld.service
# 禁止开机自启 
systemctl disable firewalld.service
```

[参考](https://blog.csdn.net/Ever_Ardour/article/details/118314884)



# ssh

首先，要确保CentOS7安装了  **openssh-server**，在终端中输入 

```
yum list installed | grep openssh-server
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122325830.png)

表示已经安装

> 如果没有安装就使用此命令安装
>
> ```
> yum install openssh-server
> ```

 找到了  **/etc/ssh/**  目录下的sshd服务配置文件 **sshd_config**，用Vim编辑器打开

```
cd /etc/ssh/
vi sshd_config
```

关于监听端口、监听地址前的 # 号去除

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122325233.png)

开启允许远程登录

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122325778.png)

开启使用用户名密码来作为连接验证

![image-20220929155054461](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202305231210107.png)



保存文件，退出。

开启  sshd  服务

```
sudo service sshd start
```

检查  sshd  服务是否已经开启

```
ps -e | grep sshd
# or 检查  22 号端口是否开启监听
netstat -an | grep 22
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122325438.png)



查看CentOS7的属性，发现网络连接方式是采用的**NAT**方式连接的

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202210122325295.png)











