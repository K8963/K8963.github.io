---
title: Laravel-文件上传
date: 2020-08-29 17:52:39
comments: false
author: 8963
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel-文件上传

<!-- more -->

前提工作：

创建数据库、连接数据库、创建表、创建字段

创建控制器、视图、上传按钮

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829164452831.png)

关于上传的本质就是文件的移动，业务逻辑

1. 先去判断文件是否正常和存在
2. 获取相关的信息（可选）
3. 保存文件（其实就是移动文件到新的目录）

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170323167.png)

上传文件目录

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170341406.png)

关于项目中使用路径的说明：

如果路径是给 php 代码使用的，则建议路径使用 ’ ./ ’ 的形式；如果路径是给浏览器使用的则建议使用 “ / ” 形式。

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170401348.png)

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170407439.png)

注意：如果要使用得是 create 方法添加数据到数据表中，则这里还要修改一下模型里面的 fillable 属性，代表允许插入到数据库的字段

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170429880.png)

将数据写入数据表

![img](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20200829170438412.png)
