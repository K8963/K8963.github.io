---
title: Laravel-文件上传
date: 2020-08-29 17:52:39
comments: false 
tags:
  - Laravel
  - PHP
categories:
  - 后端
---
前提工作：
创建数据库、连接数据库、创建表、创建字段
创建控制器、视图、上传按钮
![](https://img-blog.csdnimg.cn/20200829164452831.png#pic_center)
关于上传的本质就是文件的移动，业务逻辑
a.先去判断文件是否正常和存在
b.获取相关的信息（可选）
c.保存文件（其实就是移动文件到新的目录）
![](https://img-blog.csdnimg.cn/20200829170323167.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
上传文件目录
![](https://img-blog.csdnimg.cn/20200829170341406.png#pic_center)
关于项目中使用路径的说明：
如果路径是给php代码使用的，则建议路径使用 ’ ./ ’ 的形式；如果路径是给浏览器使用的则建议使用 “ / ” 形式。
![](https://img-blog.csdnimg.cn/20200829170401348.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
![](https://img-blog.csdnimg.cn/20200829170407439.png#pic_center)
注意：如果要使用得是create方法添加数据到数据表中，则这里还要修改一下模型里面的fillable属性，代表允许插入到数据库的字段
![](https://img-blog.csdnimg.cn/20200829170429880.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
将数据写入数据表
![](https://img-blog.csdnimg.cn/20200829170438412.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)