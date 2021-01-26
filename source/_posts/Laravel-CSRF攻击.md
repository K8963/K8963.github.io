---
title: Laravel-CSRF攻击
date: 2020-08-31 08:27:25
comments: false 
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

# CSRF攻击是跨站请求伪造(Cross-site request forgery)的英文缩写，

Laravel框架中避免CSRF攻击很简单，laravel自动为每个用户Session生成一个CSRF Token，该Token可用于验证登录用户和发起者请求是否是同一个人，如果不是则请求失败。
Laravel提供了一个全局帮助函数csrf token来获取Token值，因此只需要在视图提交表单中添加如下HTML代码即可在请求中带上Token：

```
<input type=”hidden” name=”_token” value=”<?php csrf token();?>”>
```



# laravel如何避免CSRF攻击？

案例：实现CSRF机制的验证

1. 创建两个路由，一个用于展示表单（get），一个用于处理请求（post）
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082152417.png#pic_center)

2. 创建对应的方法
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082200671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

3. 创建需要的简易表单
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082209929.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

   提交后报错，说明laravel中csrf验证机制是默认开启的

4. 通过CSRF验证
   解决方法：带上csrf需要的token值，随着请求传递给后续的方法
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082218308.png#pic_center)

   在浏览器查看源码会发现token
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082226615.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

   提交效果：
   ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082234550.png#pic_center)

**针对`csrf_token()`简化方法：**

```
{{csrf_field()}}
```

两者的区别是：
`csrf_token()`只是输出token的值
`csrf_field`输出了一整个的input隐藏域

注意：当使用异步提交表单方式时，必须使用`csrf_token()`

# 从CSRF验证中排除例外路由

并不是所有请求都需要去避免CSRF攻击，比如去第三方API获取数据的请求
可以通过在`VerifyCsrfToken（app/Http/Middleware/VerifyCsrfToken.php）`中间件中将要排除的请求添加到`$except`属性数组（白名单）中：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082243418.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
例如：
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082259878.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)

在`VerifyCsrfToken.php`中的`$except`编写test7的路由之后，再次提交表单后，提交成功
（排除单个路由）
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082307980.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
排除所有路由：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200831082314134.png#pic_center)