---
title: Event Loop 事件循环
date: 2020-06-03 07:59:00
comments: false 
tags:
  - JavaScript
categories:
  - 前端
---
JavaScript之Event Loop 事件循环

<!-- more -->


# Event Loop是什么

**事件循环（event loop）**

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/EventLoop.png)

调用栈call stack：function、

消息队列Message Queeue：setTimeout

微任务Microtask Queue：promise callback

微任务完成后，立即执行消息队列

# 面试题

## 打印顺序1

### 题目

```javascript
console.log('1');
setTimeout(function() {
    console.log('2'); 
    new Promise(function(resolve) {
        console.log('3');
        resolve();
    }).then(function() {
        console.log('4')
    })
})
new Promise(function(resolve) {
        console.log('5');
        resolve();
    }).then(function() {
        console.log('6')
    })
console.log('7')
```

### 答案

打印的顺序：1,5,7,6,2,3,4

### 解析

先同步后异步，先调用栈再微任务最后消息队列



## 打印顺序2

```javascript
setTimeout(function () {
	// 消息队列
  console.log('1');

})

new Promise(function (resolve) {
	// 调用栈1
  console.log('2');

  for (var i = 0; i < 1000; i++) {

    i == 99 && resolve();

  }
// 调用栈2
  console.log('3');

}).then(function () {
//微任务1
  console.log('4');
})
// 调用栈3
console.log('5')
```

### 答案

2,3,5,4,1



## 打印顺序3

```javascript
// 调用栈1
console.log('start')

setTimeout(() => {
    // 消息队列1
  console.log('setTimeout')
}, 0)

new Promise((resolve) => {
    // 调用栈2
  console.log('promise')
  resolve()
})
  .then(() => {
    // 微任务1
    console.log('then1')
  })
  .then(() => {
    // 微任务2
    console.log('then2')
  })
// 调用栈3
console.log('end')

```

### 答案

start，promise，end，then1，then2，setTimeout



## 打印顺序4

```javascript
// 调用栈1
console.log('start')
// 消息队列1
setTimeout(() => {
  console.log('timer1')
    //微任务2
  Promise.resolve().then(function() {
    console.log('promise1')
  })
}, 0)
// 消息队列2
setTimeout(() => {
  console.log('timer2')
    //微任务3
  Promise.resolve().then(function() {
    console.log('promise2')
  })
}, 0)
// 微任务1
Promise.resolve().then(function() {
  console.log('promise3')
})
console.log('end')

```

### 答案

start,end，promise3,timer1,promise1，timer2，promise2

## 打印顺序5

```javascript
console.log('global')

for (var i = 1;i <= 5;i ++) {
  setTimeout(function() {
    console.log(i)
  },i*1000)
  console.log(i)
}

new Promise(function (resolve) {
  console.log('promise1')
  resolve()
 }).then(function () {
  console.log('then1')
})

setTimeout(function () {
  console.log('timeout2')
  new Promise(function (resolve) {
    console.log('timeout2_promise')
    resolve()
  }).then(function () {
    console.log('timeout2_then')
  })
}, 1000)

```

### 答案

global，1,2,3,4,5，promise1，then1，6，timeout2，timeout2_promise，timeout2_then，6,6,6,6

# 参考资料

- [高频面试题 -- Event Loop](https://juejin.cn/post/6943788276385857573)
- [2分钟了解 JavaScript Event Loop](https://www.bilibili.com/video/BV1kf4y1U7Ln?from=search&seid=14830053828966099717)
- [MDN - EventLoop](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/EventLoop)













