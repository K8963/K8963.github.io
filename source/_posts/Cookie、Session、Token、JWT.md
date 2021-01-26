---
title: 一塌糊涂之Cookie、Session、Token、JWT
date: 2020-08-30 21:52:39
comments: false 
tags:
  - 其他
categories:
  - 其他
---

# 什么是Cookie？

cookie 存储在客户端： cookie 是服务器发送到用户浏览器并保存在本地的一小块数据，它会在浏览器下次向同一服务器再发起请求时被携带并发送到服务器上。

# 什么是Session

session 是另一种记录服务器和客户端会话状态的机制

session 是基于 cookie 实现的，session 存储在服务器端，sessionId 会被存储到客户端的cookie 中

Session 认证流程：
[![dqiF7d.md.jpg](https://s1.ax1x.com/2020/08/30/dqiF7d.md.jpg)](https://imgchr.com/i/dqiF7d)

- 用户第一次请求服务器时，服务器根据用户提交的相关信息(用户名、密码等)，服务器验证通过后，创建对应的Session，并将此SessionID返回给客户端

- 客户端接收服务器返回的SessionID，将此信息存储到Cookie中，同时Cookie记录此SessionID属于哪一个域名。

- 当用户第二次访问服务器的时候，请求会自动判断此域名是否存在Cookie，如果存在，将自动将cookie信息发送到服务器，服务器根据客户端返回的cookie中的sessionID寻找对应的Session信息。

SessionID 是连接 Cookie 和 Session 的一道桥梁，大部分系统也是根据此原理来验证用户登录状态。

# 什么是Token（令牌）

**Acesss Token**

访问资源接口（API）时所需要的资源凭证

Token身份验证流程：
[![dqii0H.jpg](https://s1.ax1x.com/2020/08/30/dqii0H.jpg)](https://imgchr.com/i/dqii0H)

**Refresh Token**

refresh token 是专用于刷新 access token 的 token。
![dqiPne.jpg](https://s1.ax1x.com/2020/08/30/dqiPne.jpg)

Access Token 的有效期比较短，当 Acesss Token 由于过期而失效时，使用 Refresh Token 就可以获取到新的 Token，如果 Refresh Token 也失效了，用户就只能重新登录了。Refresh Token 及过期时间是存储在服务器的数据库中，只有在申请新的 Acesss Token 时才会验证

# 什么是JWT

JWT 是为了在网络应用环境间传递声明而执行的一种基于 JSON 的开放标准（RFC 7519）。JWT 的声

明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源。比如用在用户登录上。

可查看  [阮一峰老师的 JSON Web Token 入门教程](http://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html)
[![dqi9XD.jpg](https://s1.ax1x.com/2020/08/30/dqi9XD.jpg)](https://imgchr.com/i/dqi9XD)