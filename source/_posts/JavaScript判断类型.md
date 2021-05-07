---
title: JavaScript 判断类型
date: 2021-05-03 12:38:00
comments: false
tags: 
  - JavaScript
categories:
  - 前端
---

JavaScript 判断类型方法，typeof、instanceof 原理详解

<!-- more -->

#  typeof

**使用**

参考[typeof](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/typeof)

`typeof`操作符返回一个字符串，表示未经计算的操作数的类型。

对于原始数据类型来说,除了null都可以调用typeof显示正确的类型。

**如何解释 `typeof null` 输出 object 呢?**

这需要解释一下typeof的原理

首先js在底层如何存储变量的类型信息:

> js 在底层存储变量的时候，会在变量机器码的地位1-3位存储其类型信息
>
> - 000 - 对象
> - 010 - 浮点数
> - 100 - 布尔
> - 1:整数
>
> 特殊:
>
> null - 所有机器码均为0
>
> undefined - 用 −2^30 整数来表示

所以，`typeof` 在判断 `null` 的时候就出现问题了，由于 `null` 的所有机器码均为0，因此直接被当做了对象来看待。

回答问题:为什么 `typeof null` 输出 object 呢?

> 因为null的机器码均为0,typeof通过JS在底层所存储的变量的类型信息判断,低位为000的类型信息为变量,因此`typeof null` 输出 为 object

`typeof` 操作符的唯一目的就是检查数据类型，如果我们希望检查任何从 Object 派生出来的结构类型，使用 `typeof` 是不起作用的，因为总是会得到 `"object"`。最好是用 `typeof` 来判断基本数据类型.

#  Object.prototype.toString

```javascript
Object.prototype.toString.call(1) // "[object Number]"

Object.prototype.toString.call('hi') // "[object String]"

Object.prototype.toString.call({a:'hi'}) // "[object Object]"

Object.prototype.toString.call([1,'a']) // "[object Array]"

Object.prototype.toString.call(true) // "[object Boolean]"

Object.prototype.toString.call(() => {}) // "[object Function]"

Object.prototype.toString.call(null) // "[object Null]"

Object.prototype.toString.call(undefined) // "[object Undefined]"

Object.prototype.toString.call(Symbol(1)) // "[object Symbol]"

```

#  instanceof

`instanceof `运算符用于检测构造函数的 `prototype` 属性是否出现在某个实例对象的原型链上。

```
object instanceof constructor
```

object - 某个实例对象

constructor - 某个构造函数

instanceof 就是判断实例是否属于某种类型

```javascript
let Person = function(){};
let programmer = function(){};
programmer.prototype = new Person();
let p1 = new programmer();
p1 instanceof Person  // true
p1 instanceof programmer  // true
```

**`instanceof` 的原理是什么呢?**

检测实例的原型链上是否存中类型的`prototype`

**instanceof 的实现**

```javascript
function myInstanceof(left, right) {
    //基本数据类型直接返回false
    if(typeof left !== 'object' || left === null) return false;
    //getProtypeOf是Object对象自带的一个方法，能够拿到参数的原型对象
    let proto = Object.getPrototypeOf(left);
    while(true) {
        //查找到尽头，还没找到
        if(proto == null) return false;
        //找到相同的原型对象
        if(proto == right.prototype) return true;
        proto = Object.getPrototypeOf(proto);
    }
}
```

`instanceof` 在查找的过程中会遍历实例的原型链，直到找到类型的 `prototype`，如果查找失败，则会返回 false，告诉我们实例并非是类型的实例。

实现instanceof涉及了JavaScript原型链问题

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E5%8E%9F%E5%9E%8B3.png)



# 总结

基本类型建议使用typeof进行判断

对象的具体类型考虑使用instanceof

较准确判断对象实例类型使用 Object.prototype.toString.call

# 补充

##  == 和 === 的区别

`===` 严格相等，不仅值要相等，类型也要相等

`==` 对于一般情况，只要值相等，就会返回true，但是要涉及一些转换规则：

- 两边的类型是否相同，相同的话就比较值的大小
- 判断的是否是null和undefined，是的话就返回true
- 判断的类型是否是String和Number，是的话，把String类型转换成Number
- 判断其中一方是否是Boolean，是的话，就把Boolean转换成Number
- 如果其中一方为Object，且另一方为String、Number或者Symbol，会将Object转换成字符串，再进行比较



## 对象转原始类型的流程

对象转原始类型，会调用内置的[ToPrimitive]函数，对于该函数而言，其逻辑如下：

1. 如果Symbol.toPrimitive()方法，优先调用再返回
2. 调用valueOf()，如果转换为原始类型，则返回
3. 调用toString()，如果转换为原始类型，则返回
4. 如果都没有返回原始类型，会报错

```javascript
var obj = {
  value: 3,
  valueOf() {
    return 4;
  },
  toString() {
    return '5'
  },
  [Symbol.toPrimitive]() {
    return 6
  }
}
console.log(obj + 1); // 输出7
```



# 参考

- [MDN-typeof](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/typeof)
- [MDN-toString](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/toString)
- [浅谈 instanceof 和 typeof 的实现原理](https://juejin.cn/post/6844903613584654344)