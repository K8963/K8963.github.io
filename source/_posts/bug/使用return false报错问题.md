---
title: 使用return false报错问题
date: 2021-01-27 20:38:00
comments: false
author: 8963
tags:
  - JavaScript
categories:
  - bug报告
---

使用 return false 报错 `Uncaught SyntaxError: Illegal return statement`

<!-- more -->

问题：
1.bug

```javascript
if (!window.localStorage) {
  alert("浏览器不支持localstorage");
  return false;
} else {
  console.log(123);
}
```

解决办法：

```javascript
(function () {
  if (!window.localStorage) {
    alert("浏览器不支持localstorage");
    return false;
  } else {
    console.log(123);
  }
})();
```

原因：在 JavaScript 中 return 只能在函数中使用