---
title: Node爬取字母站视频
date: 2020-09-13 15:49:58
comments: false 
tags:
  - JavaScript
  - Node.js
categories:
  - 前端
---
使用工具[ibili](https://www.npmjs.com/package/ibili)爬取B站视频
<!-- more -->

# 下载
首先，安装好node环境，下载一个工具库 [ibili](https://www.npmjs.com/package/ibili)
```language
npm install ibili
```
可以点击[ibili](https://www.npmjs.com/package/ibili)主页查看其他功能，这里我们试一试下载视频功能。
```Javascript
// 引入模块
const ibili = require('ibili')
//定义函数
function downloadV(info) {
  ibili.downloadVideo({
    //视频地址
    url: info.url, 
    //下载后定义的文件名
    filename: info.name,
  }).then(() => {
    console.log('下载完成！')
  })
}
let videoInfo = {
  url: 'https://www.bilibili.com/video/BV1rs411p7c8?from=search&seid=16766879598476832298',
  name: 'feeling you'
}
// 调用函数
downloadV(videoInfo);
```
例如我要下载`https://www.bilibili.com/video/BV1rs411p7c8?from=search&seid=16766879598476832298`这个地址的视频，并取名为`feeling you `

执行文件

![](https://s1.ax1x.com/2020/09/15/wywkWD.jpg)

查看路径下的media文件夹可看到已经下载完成的视频文件

![](https://s1.ax1x.com/2020/09/15/wywGlQ.jpg)