---
title: 函数的arguments
date: 2021-05-11 20:38:00
comments: false
tags: 
  - JavaScript
categories:
  - 前端
---

什么是arguments？

函数的arguments为什么不是数组？如何转化成数组？

<!-- more -->

#  arguments

什么是arguments？

函数的arguments为什么不是数组？如何转化成数组？

## 什么是arguments？

**`arguments`** 是一个对应于传递给函数的参数的类数组对象。

arguments 对象是所有函数（非箭头）都可以使用的**局部变量**。可以使用arguments对象在函数中引用函数的参数。此对象包含传递给函数的每个参数，第一个参数在索引0处

```javascript
function person(name,sex,age){
  arguments[2]=18;
  console.log(arguments);
}
person('小明','男',20);
```

参数也可以被设置：

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/arguments1.png)

arguments 的属性：

- arguments.callee：指向当前执行的函数（在 严格模式 下，第5版 ECMAScript (**ES5**) 禁止使用 `arguments.callee()`）
- argunments.length：指向传递给当前函数的参数数量

## 函数的arguments为什么不是数组？如何转化成数组？

因为arguments本身并不能调用数组方法，它是一个另外一种对象类型，只不过属性从0开始排，依次为0，1，2...最后还有callee和length属性。我们也把这样的对象称为**类数组**。

> 常见的类数组还有：
>
> - 用getElementsByTagName/ClassName()获得的HTMLCollection
> - 用querySelector获得的nodeList

**如何将类数组转为数组呢**？

最原始的方法就是再创建一个数组，用for循环把类数组的每个属性值放在里面，但是还有其他方法

> 1. Array.prototype.slice.call()
> 2. Array.from()
> 3. ES6对象展开符
> 4. concat + apply

###  Array.prototype.slice.call()

```javascript
function sum(a, b) {
  let args = Array.prototype.slice.call(arguments);
  console.log(args.reduce((sum, cur) => sum + cur));
  //args可以调用数组原生的方法啦
}
sum(1, 2);//3

```



###  Array.from()

```javascript
function sum(a, b) {
  let args = Array.from(arguments);
  console.log(args.reduce((sum, cur) => sum + cur));
  //args可以调用数组原生的方法啦
}
sum(1, 2);//3
```



### ES6展开运算符

```javascript
function sum(a, b) {
  let args = [...arguments];
  console.log(args.reduce((sum, cur) => sum + cur));//args可以调用数组原生的方法啦
}
sum(1, 2);//3
```



###  使用 concat+apply

```javascript
function sum(a, b) {
  let args = Array.prototype.concat.apply([], arguments);//apply方法会把第二个参数展开
  console.log(args.reduce((sum, cur) => sum + cur));//args可以调用数组原生的方法啦
}
sum(1, 2);//3
```









