---
title: JavaScript 数据类型
date: 2021-05-02 11:38:00
comments: false
tags: 
  - JavaScript
categories:
  - 前端
---

JavaScript 数据类型，基本数据类型和引用数据类型

<!-- more -->

#  数据类型

## 基本数据类型

Boolean、Number、String、BigInt、Symbol、Null、Undefined

1. Boolean：true 和 false。
2. Null：表示变量未指向任何对象
3. Undefined：表示变量未赋值
4. Number
5. String
6. Symbol(ES6新增) ：表示独一无二的值
7. BigInt(ES10新增)：可以以任意精度表示整数，使用 BigInt 可以安全地存储和操作大型整数，甚至超过数字的安全整数限制

## 引用数据类型(复杂数据类型)

Object

包含普通对象-Object，数组对象-Array，正则对象-RegExp，日期对象-Date，数学函数-Math，函数对象-Function



## 基本数据和引用数据类型有什么区别？

> 内存分配不同
>
> 访问机制不同
>
> 复制变量时不同
>
> 函数传递的参数不同

1. 内存分配不同

   基本数据类型存储在栈中

   引用数据类型存储在堆中

   > let b = {name:'haha'}
   >
   > 变量b存储在栈中,指向堆中对象的引用地址

   堆栈补充

   > 堆：顺序随意    
   >
   > 栈：后进先出(Last-In/First-Out)

2. 访问机制不同

   基本数据类型是按值访问

   引用数据类型是按引用访问

   > JS不允许直接访问保存在堆内存中的对象，在访问一个对象时，首先得到的是这个对 象在堆内存中的地址，然后再按照这个地址去获得这个对象中的值。

3. 复制变量时不同

   **基本数据类型**

   a=b;

   是将b中保存的原始值的副本赋值给新变量a，a和b完全独立，互不影响。

   ![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B1.png)

   **引用数据类**

   a=b;

   将b保存的对象内存的引用地址赋值给了新变量a;

   a和b指向了同一个堆内存地址，其中一个值发生了改变，另一个也会改变

   ![image-20210502101940822](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B2.png)

4. 函数传递的参数不同(实参/形参)

   **基本数据类型给函数传递的是实际的值**

   ![image-20210502102651005](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B3.png)

   因此改变函数内部的p2的值并不会影响到函数外a的值

   **引用数类型给函数传递的是对象在堆中的内存地址值**

   ![image-20210502102546765](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B4.png)

   >  将a在内存中的地址传给了函数作为参数,并函数接收到此地址指向p2
   >
   > 当p2改变改变是,指向p2的内存空间中地址的值也会发生改变
   >
   > 此地址也同样指向a,因此a也发生改变

##  null 是对象吗?

结论: null不是对象。

解释: 虽然 typeof null 会输出 object，但是这只是 JS 存在的一个悠久 Bug。在 JS 的最初版本中使用的是 32 位系统，为了性能考虑使用低位存储变量的类型信息，000 开头代表是对象然而 null 表示为全零，所以将它错误的判断为 object 。

> 调用typeof null 返回的是"object"。这是因为特殊值 null 被认为是一个对空对象的引用。 



#  对象地址

```javascript
function test(person) {
  person.age = 26
  person = {
    name: 'hzj',
    age: 18
  }
  
  return person
}
const p1 = {
  name: 'fyq',
  age: 19
}
const p2 = test(p1)
console.log(p1) // -> ?
console.log(p2) // -> ?
```

![image-20210502094648354](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B5.png)

 在函数传参的时候传递的是对象在堆中的内存地址值

> 依据上图
>
> test(p1)  =>   test(123)

 test函数中的实参person是p1对象的内存地址,通过调用person.age = 26确实改变了p1的值

> 改变的堆内存中地址为123的值
>
> p1指向地址123,因此p1也改变了

但随后person变成了另一块内存空间的地址，并且在最后将这另外一份内存空间的地址返回，赋给了p2。

> 在堆中开辟新内存空间地址456
>
> 并将此返回,此内存空间地址456也指向p2

最终输出结果,p1,p2为不同内存空间地址

```
p1：{name: “fyq”, age: 26}
p2：{name: “hzj”, age: 18}
```

# 基本包装类

JS中为了便于基本类型操作,提供了3个特殊的引用类型:Booolean,Number,String

它们具有基本类型的特殊行为,实际上,每当读取一个基本类型的时候,js内部都会自动创建一个基本包装类对象,可以让我们调用一些方法来操作.

  **'1'.toString()为什么可以调用**

这语句完成了

```javascript
var s = new Object('1')
s.toString()
s = null
```

1. 创建 Object 类型的实例

   > 注意为什么不是String ？ 由于Symbol和BigInt的出现，对它们调用new都会报错，目前ES6规范也不建议用new来创建基本类型的包装类。

2. 调用实例方法

3. 销毁实例

#  0.1+0.2为什么不等于0.3

在进制转换和对阶运算中丢失精度。

0.1和0.2在转为二进制的时候会无限循环,由于标准位数的限制后面多余的位数会被截掉,出现精度损失,相加后因浮点数小数位的限制而截断的二进制数字在转换为十进制就会变成0.30000000000000004。

#  BigInt

BigInt是一种新的数据类型，用于当整数值大于Number数据类型支持的范围时。

这种数据类型允许我们安全地对`大整数`执行算术操作，表示高分辨率的时间戳，使用大整数id，等等，而不需要使用库。

#### 为什么需要BigInt?

防止超过Number最大整数数值的精度丢失.

在JS中，所有的数字都以双精度64位浮点格式表示，那这会带来什么问题呢？

这导致JS中的Number无法精确表示非常大的整数，它会将非常大的整数四舍五入，确切地说，JS中的Number类型只能安全地表示-9007199254740991(-(2^53-1))和9007199254740991（(2^53-1)），任何超出此范围的整数值都可能失去精度。

# 参考

- [MDN数据类型和数据解构](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Data_structures)
- [MDN-toString()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/toString)
- [JavaScript灵魂之问-上](https://juejin.cn/post/6844903974378668039)
- [浅谈 instanceof 和 typeof 的实现原理](https://juejin.cn/post/6844903613584654344)



























