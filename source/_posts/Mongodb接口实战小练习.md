---
title: Mongodb接口实战小练习
date: 2021-02-03 14:53:25
comments: false
author: 8963
tags:
  - Mongodb
categories:
  - 数据库
---

教学管理系统-学生模块接口开发

<!-- more -->

# mongoose 简介

Node 中操作 mongodb 的模块，能够通过 node 语法实现 mongodb 数据库的增删改查

```
npm i mongoose
yaen add mongoose
```

## schema

约束 MongoDB 文档数据

[文档](http://mongoosejs.net/)

## model

一个模型 对应 一个集合，通过模型管理集合中的数据

# mongoose 使用

```javascript
// 1.导入模块
const mongoose = require("mongoose");
// 2.连接数据库 'mongodb://user:pass@localhost:port/database'
const db = mongoose.createConnection(
  "mongodb://shop2:admin888@localhost:27017/shop",
  { useNewUrlParser: true, useUnifiedTopology: true },
  (err) => {
    if (err) {
      console.log("连接失败，原因：" + err);
      return;
    }
    console.log("数据库连接成功");
  }
);
// 3.设置数据模型
const model = db.model("api", {
  uname: { type: String, default: "用户名" },
  pwd: { type: String }, // => pwd:String
  age: { type: Number },
  sex: { type: String },
});

// 创建实例操作
// 增
const insertObj = new model({
  uname: "张三",
  pwd: "admin", // => pwd:String
  age: 18,
  sex: "男",
});
// 方法1：insertObj.save((err)=>{db.close()})
// 方法2（推荐）：
insertObj
  .save()
  .then((res) => {
    console.log(res);
    return res;
  })
  .catch((err) => {
    console.log("插入失败" + err);
    return false;
  });
// 查
// 方法1 ：
// model.find / findOne(条件对象，要显示的字段数据对象，(err, result) => db.close())
// 方法2：
model
  .find({})
  .skip(1)
  .limit(1)
  .then((res) => {
    console.log(res);
    return res;
  })
  .catch((err) => {
    console.log(err);
    return false;
  });
```

# 接口（API）

**接口开发需求（Restful API）**

Restful API 是目前比较流行的软件架构，提供了接口设计的原则和约束条件

> 后端将资源发布到 URL 上 ——》前端通过 URL 访问资源 ——》并通过 HTTP 对资源进行操作（get 获取，post 新建，put 更新，delete 删除）
>
> 后端定义接口 ——》前端请求接口——》HTTP 操作资源

# 教学管理系统-学生模块接口开发

## express

基于 node 开发的框架(原理基于 node 内置 http 模块封装)

```javascript
// 1.引入express
const express = require("express");

// 2.创建app对象
let app = express();
// 3.写路由
app.get("/", (req, res) => {
  res.send("hello");
});
// 4.启动服务
app.listen("3000", () => {
  console.log("http://localhost:3000");
});
```

## 准备

**下载包**

```
npm i express
npm i mongoose
// 解析post数据
npm i body-parser
```

**入口文件 `index.html`**

```javascript
const express = require("express");
let app = express();

const bodyparser = require("body-parser");
app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: false }));

app.get("/", (req, res) => {
  res.send("Welcome");
});

const stuController = require(process.cwd() + "/controller/stu");

app.listen("3000", () => {
  console.log("http://localhost:3000");
});
```

**控制器 controller 下的 `stu.js`**

```javascript
// 导入模型
const {
  // createModel, listModel, delModel, upModel
} = require(process.cwd() + "/models/stu");

// 导出方法
module.exports = {
  // create, list, del, updata
};
```

**模型 models 下的 `stu.js`**

```javascript
const mongoose = require("mongoose");
// 连接数据库
const db = mongoose.createConnection(
  "mongodb://shop2:admin888@localhost:27017/shop",
  { useNewUrlParser: true, useUnifiedTopology: true },
  (err) => {
    if (err) {
      console.log("--------err--------");
      console.log(err);
      console.log("--------err--------");
    }
    console.log("连接成功");
  }
);
// 创建模型
const model = db.model("stu", {
  name: String,
  sid: Number,
  age: Number,
  sex: String,
});
// 导出模型方法
module.exports = {
  // createModel, listModel, delModel, upModel
};
```

## 添加学生接口

1. 入口文件 `index.html`

   添加路由方法

   ```javascript
   // #添加学生
   app.post("/stu", stuController.create);
   ```

2. 控制器

   ```javascript
   const create = async (req, res) => {
     // 1.接收 post 数据
     let postData = req.body;
     // console.log(postData);
     // 2.过滤
     // 3.操作数据库
     let rs = await createModel(postData);
     // 4.判断返回
     if (rs) {
       res.send({ meta: { status: 200, msg: "添加成功" }, data: null });
     } else {
       res.send({ meta: { status: 500, msg: "添加失败" }, data: null });
     }
   };
   ```

3. 模型

   ```javascript
   const createModel = (postData) => {
     const insertObj = new model(postData);
     return insertObj
       .save()
       .then((res) => {
         // console.log(res);
         return res;
       })
       .catch((err) => {
         console.log(err);
         return false;
       });
   };
   ```

4. 测试

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/37.png)

## 学生列表接口

1. 入口文件 `index.html`

   添加路由方法

   ```javascript
   // #学生列表app.get('/stu', stuController.list)
   ```

2. 控制器

   ```javascript
   const list = async (req, res) => {
     let getData = req.query;
     let skip = (parseInt(getData.pageno) - 1) * parseInt(getData.pagesize);
     let data = await listModel(skip, parseInt(getData.pagesize));
     if (data) {
       res.send({ meta: { status: 200, msg: "查询成功" }, data: data });
     } else {
       res.send({ meta: { status: 500, msg: "查询失败" }, data: null });
     }
   };
   ```

3. 模型

   ```javascript
   const listModel = (skipNum, limitNum) => {
     return model
       .find()
       .skip(skipNum)
       .limit(limitNum)
       .then((res) => {
         // console.log(res);
         return res;
       })
       .catch((err) => {
         console.log(err);
         return [];
       });
   };
   ```

4. 测试

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/38.png)

## 删除学生接口

1. 入口文件 `index.html`

   添加路由方法

   ```javascript
   // #删除学生app.delete('/stu', stuController.del)
   ```

2. 控制器

   ```javascript
   const del = async (req, res) => {
     let getData = req.body;
     //
     console.log(getData);
     let data = await delModel(getData);
     if (data) {
       res.send({ meta: { status: 200, msg: "删除成功" }, data: null });
     } else {
       res.send({ meta: { status: 500, msg: "删除失败" }, data: null });
     }
   };
   ```

3. 模型

   ```javascript
   const delModel = (name) => {
     return model.deleteMany(name, function (err) {
       if (err) {
         return handleError(err);
       }
       console.log("删除成功");
     });
   };
   ```

4. 测试

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/39.png)

## 修改学生接口

1. 入口文件 `index.html`

   添加路由方法

   ```javascript
   // #修改学生app.put('/stu', stuController.updata)
   ```

2. 控制器

   ```javascript
   const updata = async (req, res) => {
     let getData = req.body;
     let newD = getData.new;
     // console.log(typeof parseInt(getData.sid));
     let data = await upModel(getData.sid, getData.new);
     if (data) {
       res.send({ meta: { status: 200, msg: "修改成功" }, data: null });
     } else {
       res.send({ meta: { status: 500, msg: "修改失败" }, data: null });
     }
   };
   ```

3. 模型

   ```javascript
   const upModel = (sidc, xinc) => {
     let sid = parseInt(sidc);
     let xin = JSON.parse(xinc);
     let jiu = { sid: sid };
     console.log(jiu, xin);
     return model.updateOne(jiu, xin, {}, (err, data) => {
       if (err) {
         console.log(err);
       }
       if (data) {
         console.log(data);
       }
     });
   };
   ```

4. 测试

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/40.png)

## 接口文档 apiDoc

[apiDoc](https://apidocjs.com/)

1. 安装

   ```
   npm install apidoc -g
   ```

2. 在根目录下创建 `apidoc.json` 文件

   ```json
   {
     "name": "教学管理系统接口文档",
     "version": "1.0.0",
     "description": "apiDoc basic example",
     "title": "Custom apiDoc browser title",
     "url": "http://localhost:3000"
   }
   ```

3. 写注释

   ```javascript
   /**
    *  @api {请求方法} /路由  接口名称
    * @apiName Create（方法）
    * @apiGroup Stu（模块）
    *	//参数  * @apiParam {String} name   姓名
    * @apiParam {Number} sid    学号
    * @apiParam {Number} age    年龄
    * @apiParam {String} sex    性别
    *	//返回信息 * @apiSuccess {String} meta  状态码&提示信息
    * @apiSuccess {String} data  null */
   ```

4. 生成

   ```
   apidoc -i ./接口注释目录 -o ./接口文档存放目录
   ```
