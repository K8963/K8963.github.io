---
title:Laravel-项目初始化
date:2020-08-29 14:52:39
comments:false 
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel-项目初始化
创建项目、连接数据库、项目设置
<!-- more -->

# 1.创建 laravel 项目

使用 composer 下载 Laravel

> composer create-project laravel/laravel=(版本号).\* --prefer-dist ./

```
composer create-project --prefer-dist laravel/laravel blog 5.6.*
```

# 2.创建、连接数据库

创建数据库，修改.env 文件，配置数据库连接操作

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070824831.png)

# 3.设置本地站点为中文

下载语言包：

> composer require caouecs/laravel-lang:~3.0

找到语言包下载目录，复制到指定位置，修改 config/app.php 配置文件
指定位置

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070824437.png)

修改配置

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070824269.png)

# 4. 设置项目的使用时区

修改系统默认的时区，在 config/app.php 文件中：

配置项：timezone

配置项的值：Aisa/sahnghai、Aisa/chongqing、PRC（People`s Republic of China）

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070824695.png)

# 5. 清理项目（删除不需要的文件）

控制器

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070825819.png)

迁移、填充器文件

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070825710.png)

视图文件

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070825926.png)

# 6.安装 debugbar 工具条

（可选，开发时可以使用，上线时要去掉）

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070825126.png)

注意：laravel<5.5 使用https://github.com/barryvdh/laravel-debugbar/tree/2.4

添加提供者

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070826122.png)
debugbar 效果

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070826799.png)