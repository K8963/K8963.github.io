---
title:Laravel-CSRF攻击
date:2020-08-31 08:27:25
comments:false
author:8963
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

什么是 CSRF 攻击？
laravel 如何避免 CSRF 攻击？

<!-- more -->

# CSRF 攻击是什么

CSRF 攻击是跨站请求伪造(Cross-site request forgery)的英文缩写

Laravel 框架中避免 CSRF 攻击很简单，laravel 自动为每个用户 Session 生成一个 CSRF Token，该 Token 可用于验证登录用户和发起者请求是否是同一个人，如果不是则请求失败。

Laravel 提供了一个全局帮助函数 csrf token 来获取 Token 值，因此只需要在视图提交表单中添加如下 HTML 代码即可在请求中带上 Token：

```
<input type=”hidden” name=”_token” value=”<?php csrf token();?>”>
```

# 避免 CSRF 攻击

案例：实现 CSRF 机制的验证

1. 创建两个路由，一个用于展示表单（get），一个用于处理请求（post）
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070819298.png)

2. 创建对应的方法
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070819678.png)

3. 创建需要的简易表单
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820224.png)

   提交后报错，说明 laravel 中 csrf 验证机制是默认开启的

4. 通过 CSRF 验证
   解决方法：带上 csrf 需要的 token 值，随着请求传递给后续的方法
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820984.png)

   在浏览器查看源码会发现 token
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820285.png)

   提交效果：
   ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820026.png)

**针对`csrf_token()`简化方法：**

```
{{csrf_field()}}
```

两者的区别是：
`csrf_token()`只是输出 token 的值
`csrf_field`输出了一整个的 input 隐藏域

注意：当使用异步提交表单方式时，必须使用`csrf_token()`

# 从 CSRF 验证中排除例外路由

并不是所有请求都需要去避免 CSRF 攻击，比如去第三方 API 获取数据的请求
可以通过在`VerifyCsrfToken（app/Http/Middleware/VerifyCsrfToken.php）`中间件中将要排除的请求添加到`$except`属性数组（白名单）中：
![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820722.png)
例如：
![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820544.png)

在`VerifyCsrfToken.php`中的`$except`编写 test7 的路由之后，再次提交表单后，提交成功
（排除单个路由）
![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070820675.png)
排除所有路由：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070823489.png)