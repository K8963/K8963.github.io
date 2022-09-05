---
title: Mongodb稍微高级操作
date: 2021-01-29 17:46:25
comments: false
author: 8963
tags:
  - Mongodb
categories:
  - 数据库
---

Mongodb 稍微高级操作-排序分页、聚合查询、角色权限

<!-- more -->

# MongoDB 排序&分页

## 准备

准备数据库和数据

```
use test3
db.c1.insert({_id1:1,name:"a",sex:1,age:1})
db.c1.insert({_id1:2,name:"a",sex:1,age:2})
db.c1.insert({_id1:3,name:"b",sex:2,age:3})
db.c1.insert({_id1:4,name:"c",sex:2,age:4})
db.c1.insert({_id1:5,name:"d",sex:2,age:5})

db.c1.find()
```

## 排序

**语法**

```
db.集合名.find().sort({键：值})
					键：要排序的列/字段
					值：1升序，-1降序
```

**练习：**根据年龄的升序、降序

```
db.c1.find().sort({age:1})
db.c1.find().sort({age:-1})
```

## Limit 与 Skip 方法

**语法：**

```
db.集合名.find().sort({键：值}).skip(数字).limit(数字)
```

> skip 跳过指定数量（可选），limit 限制查询的数量

**练习：**1-降序查询 2 条，2-降序跳过 2 条并查询 2 条

```
db.c1.find().sort({age:-1}).limit(2)
db.c1.find().sort({age:-1}).skip(2).limit(2)
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/22.png)

**实战分页**

需求：数据库 1-10 数据，每页显示两条（5 页）

语法：

```
db.c1.find(2).skip((当前页-1)*每页显示条数).limit(2)
```

## 小总结

排序、分页

```
db.集合名.find()
.sort({键：值})
.skip(跳过数)
.limit(显示数)
.count(总数量);
```

# 聚合查询

统计数据、分组统计

聚合查询把数据聚起来，然后统计

**语法：**

```
db.集合名.aggregate([
	{管道:{表达式}}
	...
])
```

常用管道

```
$group	将集合中的文档分组用于统计集合$match	过滤数据，只要输出符合条件的文档$sort		聚合数据进一步排序$skip		跳过指定文档数$limit	限制返回文档数...
```

常用表达式

```
$sum	总和$avg	平均$min	最小值$max	最大值
```

## 准备

```
use test4db.c1.insert({_id:1,name:"a",sex:"1",age:1})db.c1.insert({_id:2,name:"b",sex:"1",age:2})db.c1.insert({_id:3,name:"c",sex:"2",age:3})db.c1.insert({_id:4,name:"d",sex:"2",age:4})db.c1.insert({_id:5,name:"e",sex:"2",age:5})db.c1.find()
```

## 练习

- 统计男生、女生总年龄

> ```
> db.c1.aggregate([	{$group:{		_id:"$sex",		rs:{$sum:"$age"}	}}])//	_id:根据哪个字段分组,列、字段需要使用 $ 符//	rs:结果如何显示
> ```

- 统计男生、女生总人数

> ```
> db.c1.aggregate([	{$group:{		_id:"$sex",		rs:{$sum:1}	}}])
> ```

- 求学生总数和平均年龄

> ```
> db.c1.aggregate([	{$group:{			_id:null,			rs1:{$sum:1},			rs2:{$avg:"$age"}		}}])
> ```
>
> ![](../../../整理/All2/数据库/img/23.png)

- 查询男生、女生人数，按人数升序

> ```
> db.c1.aggregate([	{$group:{		_id:"$sex",		rs:{$sum:1}	}},	{$sort:{rs:1}}])
> ```

# 索引

索引：一种排序好的便于快速查询的数据结构

**语法**

- 创建索引

  ```
  db.集合名.createIndex(待创建索引的列[,额外选项])
  ```

- 参数

  > 待创建索引的列：{键：1...，键：-1}
  >
  > 说明：1 升序，-1 降序，例如{age}表示创建 age 索引并按照升序的方式存储
  >
  > 额外选项：设置索引的名称或者唯一的索引等等

- 删除索引

  > 全部删除：db.集合名.dropIndexes()
  >
  > 删除指定：db.集合名.dropIndex(索引名)

- 查看索引

  > db.集合名.getIndexes()

## 练习

**准备：**向数据库新增十万条数据

```
use test5for(var i=0;i<100000;i++){	db.c1.insert({name:"aaa"+i,age:i})}db.c1.count()
```

**练习 1：给 name 添加普通索引**

> ```
> db.c1.createIndex({name:1})
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/24.png)

**练习 2：删除 name 索引**

> ```
> db.c1.dropIndex('name_1')
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/25.png)

**练习 3：给 name 创建索引并起名 web**

> ```
> db.c1.createIndex({name:1},{name:"web"})
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/26.png)

**练习 4：**创建复合/组合索引，给 name 和 age 添加组合索引

> ```
> db.集合名.createIndex({键1：存储方式，键：存储方式})db.c1.createIndex({name:1,age:1})
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/27.png)

**练习 5：**创建唯一索引，给 name 添加普通索引

> 删除全部索引
>
> ```
> db.c1.dropIndexes()
> ```
>
> 设置唯一索引
>
> ```
> db.c1.createIndex({name:1},{unique:"name"})
> ```
>
> 测试唯一索引的特性
>
> ```
> db.c1.insert({name:"a"})
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/28.png)

## 分析索引

语法：

```
db.集合名.find().explain('executionStats')
```

分析查询情况

案例

> 1.age 未添加索引
>
> ```
> db.c1.find({age:18}).explain('executionStats')
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/29.png)
>
> 2.age 添加索引
>
> ```
> db.c1.createIndex({age:1})db.c1.find({age:18}).explain('executionStats')
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/30.png)

## 选择规则

- 为常作条件、排序、分组的字段建立索引
- 选择唯一性索引
- 选择较小的数据列
- 为较长的字符串使用前缀索引

# Mongodb 权限机制

使用权限机制开启验证模式

## 语法

```
db.createUser({	"user":"账号",	"pwd":"密码",	"roles":[{		role:"角色",		db:"所属数据库"	}]})
```

## 角色

```
#角色种类超级用户角色:root数据库用户角色:read、readwrite;数据库管理角色: dbAdmin.userAdmin;集群管理角色: clusterAdmin、clusterManager、clusterMonitor、hostManager;备份恢复角色:backup、restore;所有数据库角色: readAnyDatabase、readwriteAnyDatabase、userAdminAnyDatabase,dbAdminAnyDatabase
```

## 开启验证模式

1. 添加超级管理员

   ```
   use admindb.createUser({	"user":"8963",	"pwd":"8963root",	"roles":[{		role:"root",		db:"admin"	}]})
   ```

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/31.png)

   数据中查看超级管理员

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/32.png)

2. 退出卸载服务

   ```
   管理员命令bin\mongod --remove
   ```

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/33.png)

3. 安装需要身份验证的 MongoDB 服务

   ```
   // 安装服务 --authmongod --install --dbpath F:\data\mongodb\data --logpath F:\data\mongodb\logs\mongodb2.log --auth
   ```

4. 启动服务，登录测试

   ```
   // 启动服务net start MongoDB
   ```

## 通过超级管理员账号登录

方法 1: mongo 服务器 IP 地址:端口/数据库 -u 用户名 -p 密码

```
mongo 127.0.0.1:27017/admin -u 8963 -p 8963root
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/34.png)

方法 2: a-先登录，b-选择数据库，c-输入 db.auth(用户名,密码)

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/35.png)

## 创建其他角色

### 准备

添加用户 shop1 可以读取 shop 数据库

添加用户 shop2 可以读写 shop 数据库

注意：在对应的数据库内创建角色

测试数据

```
use shop;for(var i = 1;i <= 10;i++){	db.goods.insert({"name":"goodName"+i,"price":i});}
```

### 添加用户并设置权限

```
// shop1use shopdb.createUser({	"user":"shop1",	"pwd":"admin888",	"roles":[{		role:"read",		db:"shop"	}]})// shop2db.createUser({	"user":"shop2",	"pwd":"admin888",	"roles":[{		role:"readWrite",		db:"shop"	}]})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/36.png)

# Mongodb 备份还原

## 备份数据库 mongodump

**语法**

```
mongodump -h -port -u -p -d -o 导出语法说明-h	host			服务器IP地址(一般不写默认本机-p	ort				端口(一般不写默认27017-u	user			账号-p	pwd				密码-d	database	数据库(数据库不写则导出全部-o	open			备份到指定目录下
```

备份所有数据:

```
mongodump -u 8963 -p 8963root -o F:\data\mongodb\bak
```

备份指定数据

```
mongodump -u 8963 -p 8963root -d test -o F:\data\mongodb\bak2
```

## 还原数据库 mongorestore

语法

```
mongorestore -h -port -u -p -d--drop备份数据目录还原数据说明:-h-port-u-p-d			不写则还原全部数据库--drop	先删除数据库再导入
```

还原所有数据:

```
mongorestore -u 8963 -p 8963root --drop F:\data\mongodb\bak
```

还原指定数据

```
mongorestore -u 8963 -p 8963root -d test --drop F:\data\mongodb\bak\test
```
