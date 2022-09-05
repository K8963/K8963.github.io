---
title: Mongodb基础操作
date: 2021-01-28 17:53:25
comments: false
author: 8963
tags:
  - Mongodb
categories:
  - 数据库
---

Mongodb 基础操作(curd)

<!-- more -->

# Mongodb 安装

1. [下载](https://www.mongodb.com/try/download/community)

2. 解压

3. 创建服务

   - 通过管理员身份运行 dos 窗口
   - 提前创建数据和日志存放目录

   ```
   mongod --install --dbpath 数据路径(F:\data\mongodb\data) --logpath 日志路径(F:\data\mongodb\logs\mongodb.log)
   ```

   > 运行后无任何的报错提示算成功

   此处小坑

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/1.png)

   安装微软运行库解决问题

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/2.png)

4. 启动服务

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/3.png)

   或者

   ```
   net start mongodb
   ```

5. 登录（验证安装）

   ```
   bin/mongo
   ```

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/4.png)

语法：

```
创建服务:bin/mongod.exe --install --dbpath 磁盘路径 --logpath 日志路径
删除服务:bin/mongod.exe --remove
启动服务:net start mongodb
关闭服务:net stop mongodb
```

# Mongodb 基本操作

数据库(database)、集合(collection)、数据/文档(document)

## 查看数据库

语法：

```
show databases
```

效果：

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/5.png)

## 选择数据库

语法

```
use 数据库名称
```

效果：

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/6.png)

注意：

在 Mongodb 中选择不存在的数据库并不会报错，而是隐式创建了一个数据库。

**隐式创建** 当该数据库有数据时，系统会自动创建

## 删除数据库

语法：

```
db.dropDatabase()
```

效果：

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/9.png)

## 查看集合

语法：

```
show collecttions
```

## 创建集合

语法：

```
db.createCollection('集合名')
```

## 删除集合

语法：

选择进入数据库再执行删除操作

```
db.集合名.drop()
```

效果：

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/8.png)

## 小总结

数据库（查看、创建、选择、删除）

```
创建：隐式创建查看：show databases选择：use 数据库名删除：db.dropDatabase()
```

集合（查看、创建、删除）

```
查看：show collections创建：db.crateCollection('集合名')删除：db.集合名.drop()
```

# Mongodb 文档 CURD

文档的增删改查

## C 增

**语法：**

```
db.集合名.insert(JSON数据)
```

说明：若集合存在则直接插入数据，集合不存在则隐式创建

**练习：**

在 test 数据库的 c1 集合中插入数据：姓名：webopenfather，年龄：18

```
use testdb.c1.insert({name:"wxh",age:18})
```

mongodb 会给每条数据增加一个 `_id` 键，这个由 时间戳、机器码、PID、计数器组成

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/10.png)

**练习**

1.插入多条记录

> 传递数组，数组中写入一个 JSON 数据
>
> ```
> db.c.insert([	{uname:"zs",age:"15"},	{uname:"ls",age:"18"},	{uname:"ww",age:"22"},])
> ```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/11.png)

2.快速插入 10 条记录

> mongodb 底层是使用 js 引擎是实现的，所以支持部分 js 语法，因此可以使用 for 循环
>
> ```
> for(var i=1;i<=10;i++){	db.c2.insert({uname:"a"+i,age:i})}
> ```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/12.png)

## R 查

**基础语法：**

```
db.集合名.find(条件，[,查询的列])条件	查询所有数据				 {}	查询age=15的数据		  {age:15}	查询age=6，性别=男	 {age:6,sex:"男"}查询的列	无 - 查询全部列（字段）	{age:1}		只显示age列	{age:0}		除了age列都显示
```

**升级语法**

```
db.集合名.find({	键：{运算符:值}})
```

| 运算符 | 作用                  |
| ------ | --------------------- |
| $gt    | 大于                  |
| $gte   | 大于等于              |
| $lt    | 小于                  |
| $lte   | 小于等于              |
| $ne    | 等于                  |
| $in    | in 在某个区间内       |
| $nin   | not in 不在某个区间内 |

**练习：**

1.查询所有数据

```
db.c.find()
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/13.png) 2.查询年龄大于 5 的数据

```
db.c2,find(age:{$gt:5})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/14.png)
**3.查询年龄是 5、8，10 的数据**

```
db.c2.find(age:{$in:[5,8,10]})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/15.png) 4.只看年龄列，或除了年龄列

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/16.png)

## U 改

**基础语法**

```
db.集合名.updata(条件，新数据[，是否新增，是否修改多条])是否新增：指条件匹配不到数据则插入，默认为true是否修改多条：指将条件都匹配成功的数据都修改，默认为true
```

**升级语法**

```
db.集合名.updata(条件，新数据[，是否新增，是否修改多条])										 {修改器：{键：值}}
```

| 运算符  | 作用     |
| ------- | -------- |
| $inc    | 递增     |
| $rename | 重命名列 |
| $set    | 修改列值 |
| $unset  | 删除列   |

**准备工作**

```
use test2for(var i=1;i<=10;i++){		db.c3.insert({uname:"zs"+i,age:i})}
```

**练习**

1.将{uname:"zs1"}改为{uname:"zs2"}

```
db.c3.update({uname:"zs1",{uname:"zs2"}})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/17.png)

此操作为替换并非修改，正确应当使用升级语法

```
db.c3.update({uname:"zs1"},{$set:{uname:"zs2"}})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/18.png)

2.将 zs10 的年龄增加或者减少 2 岁

增加：

```
db.c3.update({uname:"zs10"},{$inc:{age:2}})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/19.png)

减少：

```
db.c3.update({uname:"zs10"},{$inc:{age:-2}})
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/20.png) 3.修改器综合练习

插入数据：

```
db.c4.insert({uname:"神龙教主",age:888,who:"男",other:"非国人"});
```

> 需求：
>
> uname 改成 神龙主教
>
> ```
> db.c4.update({uname:"神龙教主"},{$set:{uname:"神龙主教"}})
> ```
>
> age 增加 111
>
> ```
> db.c4.update({uname:"神龙主教"},{$inc:{age:111}})
> ```
>
> who 改字段 sex
>
> ```
> db.c4.update({uname:"神龙主教"},{$rename:{who:sex}})
> ```
>
> other 删除
>
> ```
> db.c4.update({uname:"神龙主教"},{$unset:{other:true}})
> ```
>
> 一次写多个修改器
>
> ```
> db.c4.update({uname:"神龙教主"},{	$set:{uname:"神龙主教"},	$inc:{age:111},	$rename:{who:"sex"},	$unset:{other:true}})
> ```
>
> ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/21.png)

## D 删

语法：

```
db.集合名.remove(条件,[,是否删除一条])注意：是否删除一条，默认false全部删除
```

## 小总结

增 Create

```
db.集合名.insert(JSON数据)
```

删 Delete

```
db.集合名.remove(条件[,是否删除一条])
```

改 Update

```
db.集合名.update(条件，新数据[，是否新增，是否修改多条])db.集合名.update(条件，修改器:{修改器:{键:值}})
```

查 Read

```
db.集合名.find(条件[,查询的列])
```
