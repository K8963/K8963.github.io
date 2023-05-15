---
title:express+mysql+sequelize 创建项目
date:2022-03-18 12:52:39
comments:false
author:8963
tags:
  - sequelize 
  - express
  - mysql
categories:
  - 后端

---

express+mysql+sequelize

<!-- more -->

# 创建项目

```
mkdir realworld-api-express
cd realworld-api-express
npm init -y
npm i express
```

在项目根目录创建 app.js

```javascript
const express = require('express')
const app = express()
const PORT = process.env.PORT || 3000
app.get('/', (req, res) => {
  res.send('hello')
})
app.listen(PORT, () => {
  console.log('http://localhost:' + PORT)
})
```

设置`PORT` ，在终端

```
set port=5000
```

运行项目就可以看到改变了的端口号，

```bash
# 查看端口号
set port
# 删除端口号
set port=
```

# 目录结构

-   config 配置文件
    -   config.defaule.js
-   controllers 控制层
-   models 数据持久层
-   middlewares 中间层
-   routers 路由模块
-   utils 工具模块
-   app.js 入口启动文件

# 配置常用的中间件

解析请求体

-   express.json()
-   express.urlencode()

```javascript
const app = express()

app.use(express.json())
app.use(express.urlencoded())
```

日志输出

-   morgan()

```
npm i morgan
------------------
const morgan = require('morgan')
const app = express()

app.use(morgan('dev'))
```

跨域

-   cors()

```
npm i cors
const cors = require('cors')
const app = express()

app.use(cors())
```

# 路由设计

参考：

[https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints](https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints)

# 数据库（Sequelize）

## 连接数据库

[Sequelize](https://www.sequelize.com.cn/core-concepts/getting-started)

```
npm i sequelize
npm i mysql2
```

配置config.default.js

```javascript
module.exports = {
  HOST: 'localhost',
  USERNAME: 'root',
  PASSWORD: 'root',
  DATABASE: 'realworld-api',
  dialect: 'mysql',
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
}
```

`pool`可选，用于Sequelize连接池配置

```swift
- max：池中的最大连接数
- min：池中的最小连接数
- idle：连接释放之前可以空闲的最长时间（以毫秒为单位）
- acquire：该池将在抛出错误之前尝试获取连接的最长时间（以毫秒为单位）
```

创建`modules\index`

```javascript
const Sequelize = require('sequelize')
const { dbConfig } = require('../config/config.default')

const sequelize = new Sequelize(
  dbConfig.DATABASE,
  dbConfig.USERNAME,
  dbConfig.PASSWORD,
  {
    host: dbConfig.HOST,
    dialect: dbConfig.dialect,
    pool: dbConfig.pool,
  }
)

const db = {}
db.Sequelize = Sequelize
db.sequelize = sequelize

module.exports = db
```

至此，连接成功

## 创建模型

创建`modules\user`

```javascript
const { Sequelize, DataTypes } = require('sequelize')

module.exports = (sequelize) => {
  const User = sequelize.define('users', {
    user: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    account: {
      type: DataTypes.INTEGER(12),
      allowNull: false,
      unique: true,
      autoIncrement: true,
      primaryKey: true,
    },
    sex: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: '未知',
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    age: {
      type: DataTypes.INTEGER(3),
    },
    bio: {
      type: DataTypes.STRING,
    },
    img: {
      type: DataTypes.STRING,
    },
  })

  return User
}
```

在`modules\index`中

```javascript
const db = {}
db.Sequelize = Sequelize
db.sequelize = sequelize
// 添加模型
db.users = require('./user')(sequelize)

module.exports = db
```

> 模型列参数
> 
> -   allowNull:false 不为空
>     
> -   defaultValue:"默认值"
>     
> -   unique:true 禁止插入重复数据
>     
> -   primaryKey:true 设置为主键
>     
> -   autoIncrement: true 设置自增
>     
>     数据类型必须为INTEGER类型
>     
>     字段必须为 主键
>     

## 模型同步

-   `User.sync()` - 如果表不存在,则创建该表(如果已经存在,则不执行任何操作)
-   `User.sync({ force: true })` - 将创建表,如果表已经存在,则将其首先删除
-   `User.sync({ alter: true })` - 这将检查数据库中表的当前状态(它具有哪些列,它们的数据类型等),然后在表中进行必要的更改以使其与模型匹配.

# 用户模块

## 数据效验

[规则](https://express-validator.github.io/docs/check-api.html#bodyfields-message)

```
npm i express-validator
```

提取为中间件

`middlewares/validate.js`验证数据处理函数

```javascript
const { validationResult } = require('express-validator')
const { CODE_ERROR, CODE_SUCCESS } = require('../config/constant')

// parallel processing 并行处理
// 暴露一个函数，函数接收验证规则，返回一个函数
module.exports = (validations) => {
  return async (req, res, next) => {
    await Promise.all(validations.map((validation) => validation.run(req)))

    const errors = validationResult(req)
    if (errors.isEmpty()) {
      return next()
    }
    res.status(400).json({
      code: CODE_ERROR,
      msg: '数据效验遇到错误',
      data: errors.array(),
    })
  }
}
```

配置验证规则`middlewares/validator.js`

```javascript
// 配置效验规则
const { body } = require('express-validator')
const validate = require('./validate')
const { userModel } = require('../models')
const { Op } = require('sequelize')

// 用户名是否存在
exports.uNameVai = validate([
  body('user')
    .notEmpty()
    .withMessage('用户名不能为空')
    .custom(async (user) => {
      let result = await userModel.findAll({
        where: { user: user },
      })
      if (result.length) {
        return Promise.reject('用户名已存在')
      }
    }),
])

// 账号是否存在
exports.accountVai = validate([
  body('account')
    .notEmpty()
    .withMessage('账号不能为空')
    .custom(async (account, { req }) => {
      let result = await userModel.findAll({
        where: { account: account },
      })
      if (!result.length) {
        return Promise.reject('账号不存在')
      }
      // 将查询结果添加，使控制器减少查询
      req.result = result
    }),
])

// 用户名 or 账号
exports.userIdVai = validate([
  body('userId')
    .notEmpty()
    .withMessage('用户名不能为空')
    .custom(async (userId, { req }) => {
      let result = await userModel.findAll({
        where: {
          [Op.or]: [
            {
              user: userId,
            },
            {
              account: userId,
            },
          ],
        },
      })
      if (!result.length) {
        return Promise.reject('用户名或账号不存在')
      }
      req.result = result
    }),
])
// 密码
exports.pwsVai = validate([
  body('password').notEmpty().withMessage('密码不能为空'),
])
```

路由使用

可以绑定多个验证规则

```javascript
const express = require('express')

const router = express.Router()
const usersCtrl = require('../controllers/users')
const validator = require('../middlewares/validator')

router.post(
  '/register',
  validator.pwsVai,
  validator.uNameVai,
  usersCtrl.register
)
// 用户登录
router.post('/login', validator.pwsVai, validator.userIdVai, usersCtrl.login)
// 更新用户
router.put('/updata', validator.accountVai, usersCtrl.updata)
// 删除用户
router.delete('/del', usersCtrl.delete)
// 获取当前登录用户信息
router.get('/getCurrentUser', usersCtrl.getCurrentUser)

module.exports = router
```

控制器直接使用数据效验阶段查询数据，减少查询次数

```javascript
let data = req.result[0].dataValues
```

## 注册

-   md5加密密码
    
    ```javascript
    const crypto = require('crypto')
    
    function md5(s) {
      return crypto
        .createHash('md5')
        .update('' + s)
        .digest('hex')
    }
    
    module.exports = md5
    ```
    

## 登录

查询用户名或者账号

```javascript
let result = await userModel.findAll({
  where: {
    [Op.or]: [
      {
        user: req.body.userId,
      },
      {
        account: req.body.userId,
      },
    ],
  },
})
```

## JWT

```
npm i jsonwebtoken express-jwt
```

-   jsonwebtoken 生成token
-   express-jwt效验token

创建 `utils/jwt.js`

```javascript
const jwt = require('jsonwebtoken')
const expressJwt = require('express-jwt')
const { PRIVATE_KEY } = require('../config/constant')

const jwtAuth = expressJwt({
  // 设置密钥
  secret: PRIVATE_KEY,
  // 设置算法
  algorithms: ['HS256'],
  // 是否开启认证
  credentialsRequired: true,
  // 获取token
  getToken: (req) => {
    if (req.header.authorization) {
      return req.header.authorization
    } else if (req.query && req.query.token) {
      return req.query.token
    }
  },
}).unless({
  // 认证白名单
  path: ['api/users/register', 'api/users/login'],
})
// jwt解析
function decode(req) {
  const token = req.get('Authorization')
  return jwt.verify(token, PRIVATE_KEY)
}
module.exports = { jwtAuth, decode }
```

路由解析twt`routers/index.js`

```javascript
const { jwtAuth, decode } = require('../utils/jwt')

const router = express.Router()
// 重要：效验
router.use(jwtAuth)
// 用户相关
router.use('/users', require('./users'))
// 自定义统一异常处理中间件，需要放在代码最后
router.use((err, req, res, next) => {
  // 自定义用户认证失败的错误返回
  if (err && err.name === 'UnauthorizedError') {
    const { status = 401, message } = err
    // 抛出401异常
    res.status(status).json({
      code: status,
      msg: 'token失效,请重新登录',
    })
  } else {
    const { output } = err || {}
    // 错误码和错误信息
    const errCode = (output && output.statusCode) || 500
    const errMsg =
      (output && output.payload && output.payload.error) || err.message
    res.status(errCode).json({
      code: errCode,
      msg: errMsg,
    })
  }
})
```

测试

postman 添加统一请求头

请求成功

不设置token，请求失败