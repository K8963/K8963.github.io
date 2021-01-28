---
title: 使用return false报错问题
date: 2021-01-27 20:38:00
comments: false
tags: 
  - JavaScript
categories:
  - bug报告
---
使用return false报错 `Uncaught SyntaxError: Illegal return statement`
<!-- more -->

问题：
1.bug
```JavaScript
  if (!window.localStorage) {
    alert("浏览器不支持localstorage");
    return false;
  } else {
      console.log(123);
  }
```

解决办法：
```JavaScript
  (function () {
    if (!window.localStorage) {
      alert("浏览器不支持localstorage");
      return false;
    } else {
      console.log(123);
    }
  })()
```

原因：在JavaScript中return只能在函数中使用