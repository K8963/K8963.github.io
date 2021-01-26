---
title: Laravel-项目初始化
date: 2020-08-29 14:52:39
comments: false 
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

# 1.创建laravel项目
使用 composer 下载 Laravel

> composer create-project laravel/laravel=(版本号).* --prefer-dist ./

# 2.创建、连接数据库
创建数据库，修改.env文件，配置数据库连接操作
![](https://img-blog.csdnimg.cn/2020082508535993.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
# 3.设置本地站点为中文
下载语言包：

> composer require caouecs/laravel-lang:~3.0

找到语言包下载目录，复制到指定位置，修改config/app.php配置文件
指定位置![指定位置](https://img-blog.csdnimg.cn/20200825085739634.png#pic_center)
修改配置
![](https://img-blog.csdnimg.cn/20200825085800705.png#pic_center)

# 4. 设置项目的使用时区
修改系统默认的时区，在config/app.php文件中：
配置项：timezone
配置项的值：Aisa/sahnghai、Aisa/chongqing、PRC（People`s Republic of China）
![](https://img-blog.csdnimg.cn/20200825085841181.png#pic_center)

# 5. 清理项目（删除不需要的文件）
控制器
![](https://img-blog.csdnimg.cn/20200825090232225.png#pic_center)

迁移、填充器文件
![](https://img-blog.csdnimg.cn/20200825090302235.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

视图文件
![](https://img-blog.csdnimg.cn/20200825090315183.png#pic_center)

# 6.安装debugbar工具条
（可选，开发时可以使用，上线时要去掉）
![](https://img-blog.csdnimg.cn/20200825090447886.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

注意：laravel<5.5 使用https://github.com/barryvdh/laravel-debugbar/tree/2.4

添加提供者
![](https://img-blog.csdnimg.cn/20200825090711379.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
debugbar效果
![](https://img-blog.csdnimg.cn/20200825090800982.png#pic_center)