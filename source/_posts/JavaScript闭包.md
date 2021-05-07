---
title: JavaScript 闭包详解
date: 2021-05-01 20:38:00
comments: false
tags: 
  - JavaScript
categories:
  - 前端
---

JavaScript 闭包详解

<!-- more -->

# 作用域与作用域链

当代码在一个环境中执行时，会创建变量对象的一个作用域链（scope chain）。作用域链的用途，是保证对执行环境有权访问的所有变量和函数的有序访问。

在ES5中只有两种作用域——全局作用域、函数作用域。

当访问一个变量时，解释器会首先在当前作用域寻找该变量的标识符，在当前作用没有找到时，会向上前往该作用域的父级作用域寻找，直到找到该变量的标识符或者查明该变量不在父级作用域中，这就是作用域链。

每一个子函数都会拷贝上级的作用域，从而形成一个作用域的链条。

```javascript
function f1() {
  f2()
  function f2() {
    console.log(a);//3
  }
}
f1()
```

这段代码中

f1的作用域指向全局作用域（window）和f1本身

f2的作用域指向全局作用域、父级作用域f1、f2本身

而作用域从最底层开始找，直到查找到最外层的作用域——全局作用域（window）为止，还没有找到就会报错。

![image-20210503125810466](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/闭包1.png)



# 闭包

红宝书(p178)上对于闭包的定义：闭包是指有权访问另外一个函数作用域中的变量的函数。

MDN 对闭包的定义为：闭包是指那些能够访问自由变量的函数。 （其中自由变量，指在函数中使用的，但既不是函数参数arguments也不是函数的局部变量的变量，其实就是另外一个函数作用域中的变量。）

**闭包产生的原因?**

闭包产生的本质是，当前环境中存在指向父级作用域的的引用

```javascript
function f1() {
  var a = 2
  function f2() {
    console.log(a);//2
  }
  return f2;
}
var x = f1();
x();
```

在当前环境中，x拿到了含有对f2的引用，f2引用了 window、f1、f2的作用域。

因此执行 x() 时，可以输出在f1作用域中的a值

**那是不是只有返回函数才算是产生了闭包呢？**

回到闭包的本质，我们只需要父级作用域的引用即可

```javascript
var f3;
function f1() {
  var a = 2
  f3 = function() {
    console.log(a);
  }
}
f1();
f3();
```

- 声明一个变量f3

- 执行f1()，通过作用域链获取到window的变量f3并赋值为一个函数

- 执行 f3() ，此时 f3() 包含了window、f1、f3的作用域引用，因此输出a值为2 

在这里是外面的变量 f3 存在父级作用域的引用，因此产生了闭包，形式变了，闭包的本质（存在父级作用域的引用）没有改变。

#  闭包的表现形式

明白了闭包的本质，在当前环境中存在父级作用域的引用。在真实的场景中，究竟在哪些地方能体现闭包的存在？

> 1. 返回一个函数
> 2. 作为函数的参数传递
> 3. 在异步操作中使用回调函数
> 4. IIFE立即执行函数表达式创建闭包

## 返回一个函数

```javascript
function f1() {
  var a = 2
  function f2() {
    console.log(a);//2
  }
  return f2;
}
f1()();	// 2
```



## 作为函数参数传递

```javascript
var a = 1;
function foo(){
  var a = 2;
  function foo2(){
    console.log(a)
  }
  foo1(foo2)
}
function foo1(fn){
  fn();
}
foo()
```

执行foo()，通过 foo() 执行 foo1()，并将foo内部的函数foo2作为参数传递给foo1

foo1通过fn接收foo2并且执行。

经过这些操作，foo1就能获取到foo2上window、foo的作用域引用。

foo1函数就拥有了window、foo、foo2、foo1本身的作用域引用



## 在异步操作中使用回调函数

在定时器、事件监听、Ajax请求、跨窗口通信、Web Workers或者任何异步中，使用回调函数，实际上就是在使用闭包。

```javascript
// 定时器
setTimeout(function timeHandler(){
  console.log('111');
}，100)

// 事件监听
$('#app').click(function(){
  console.log('DOM Listener');
})
```



##  IIFE(立即执行函数表达式)创建闭包

IIFE(立即执行函数表达式)创建闭包, 保存了`全局作用域window`和`当前函数的作用域`，因此可以全局的变量。

```javascript
var a = 2;
(function IIFE(){
  // 输出2
  console.log(a);
})();
```

#  循环输出问题

```JavaScript
for(var i = 1; i <= 5; i ++){
  setTimeout(function timer(){
    console.log(i)
  }, 0)
}
```

在 js 的 eventLoop 事件循环机制中，setTime属于宏任务，在主线程同步任务执行完后才去执行宏任务，因此 setTime 中的回调必须在 for 循环完成之后才能依次执行，当setTime执行时for循环已经完成，i为6因此输出6

解决办法：

1. 用IIFE(立即执行函数表达式)当每次for循环时，把此时的i变量传递到定时器中

   ```javascript
   for(var i = 1;i <= 5;i++){
     (function(j){
       setTimeout(function timer(){
         console.log(j)
       }, 0)
     })(i)
   }
   ```

   每一次循环之后，都会执行IIFE并将i的值传入，因此setTime函数可以获取到每一次循环 i 的值

2. 给定时器传入第三个参数，作为timer函数的第一个参数

   ```javascript
   for(var i=1;i<=5;i++){
     setTimeout(function timer(j){
       console.log(j)
     }, 0, i)
   }
   ```

3. 使用ES6的let

   ```javascript
   for(let i = 1; i <= 5; i++){
     setTimeout(function timer(){
       console.log(i)
     },0)
   }
   ```

   let使JS发生革命性的变化，让JS有函数作用域变为了块级作用域，用let后作用域链不复存在。代码的作用域以块级为单位

   



























