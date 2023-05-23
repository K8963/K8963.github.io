---
title: Laravel-数据分页
date: 2020-08-31 08:59:20
comments: false 
author: 8963
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel-数据分页 步骤+案例
<!-- more -->

# 分页效果的步骤

- 查询符合分页条件的总的记录数
- 计算总的页数（总记录数/每页要显示的记录数，并且向上取整）
- 拼凑分页的连接
- （核心）使用limit语法来限制分页的记录数
- 展示分页的页码和分页数据
- 分页样式

# 案例

创建路由，并且展示简易的列表页面

路由：

 ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829746.png)

创建列表文件：

编写控制器方法

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829749.png)

展示数据

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070830944.png)

效果：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829924.png)



使用分页展示页面

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829751.png)

分页的基本语法：

```
Model::paginate(每页显示的记录数);
```

Paginate()和get()方法一致，支持使用where，orderBy等辅助查询方法。

 ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829779.png)

- 效果（不展示分页连接）：

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829526.png)

- 在页面中展示分页链接：

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829329.png)

  语法格式：`{{$保存数据的对象 -> links()}}` 生成的链接

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829183.png)

  效果：

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829312.png)

将页面提示的<<和>> 该成文字的上一页与下一页（可选）

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829397.png)

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829315.png)

修改后：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070829900.png)

分页数据对象其他实用方法：

- 分页数据对象 -> `count()`						//当前页数据条数
- 分页数据对象 -> `correntPage()	`		//当前页码
- 分页数据对象 -> `firstltem()	`				//当前页第一条数据的序号
- 分页数据对象 -> `hasMorePages()`		//是否有后续页码
- 分页数据对象 -> `lastltem()`					//当前页最后一条数据的序号
- 分页数据对象 -> `lastlPage()`					//最后页序号
- 分页数据对象 -> `nextPageUrl()`			//下一页的连接地址
- 分页数据对象 -> `perPage()		`			//每页显示数据条数
- 分页数据对象 -> `previousPageUrl()`		//上一页的连接地址
- 分页数据对象 -> `total()`						//记录总条数
- 分页数据对象 -> `url()	`						//制作指定页码的连接地址

