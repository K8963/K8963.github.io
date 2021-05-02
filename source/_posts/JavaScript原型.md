---
title: JavaScript 原型详解
date: 2021-04-27 20:38:00
comments: false
tags: 
  - JavaScript
categories:
  - 前端

---

JavaScript 原型详解

<!-- more -->

# prototype属性

显式原型属性，**只有函数才拥有该属性**。

除了通过 bind() 方法创建的函数外，其他函数都有 prototype 属性

```javascript
let fun = Function.prototype.bind()
```

**prototype如何产生？**

当我们声明一个函数时，这个属性就会被自动创建了

这个属性的值是一个对象，这个对象也就是这个函数的原型`constructor` , `contructor` 对应着构造函数

**constructor**

`constructor` 是一个公有且不可枚举的属性。但是可以通过原型链提取到 constructor

> **注意：**
>
> 在 JavaScript 中<u>对象的属性</u>分为可枚举和不可枚举。它们是由属性的enumerable（可枚举型）的值决定的。
>
> 可枚举决定这个属性能否被for...in查找遍历到。
>
> 属性的枚举性会影响以下三个函数的结果：
>
> for…in
>
> Object.keys()
>
> JSON.stringify
>
> [来源](https://www.cnblogs.com/jcz1206/p/9553115.html)

**prototype有什么作用？**

- 让实例对象知道是什么函数构造了它
- 如果想给某些类库中的构造函数增加一些自定义的方法，就可以通过 `xx.constructor.method` 来扩展

#  _ proto_

每个对象都有的隐式原型属性，指向创建该对象的构造函数的原型，其实这个属性指向了 [[prototype]] 但是这是内部属性，我们无法访问，因此使用 `_proto_`来访问。

使用new操作符时，生成的实例对象拥有了`_proto_`属性

```javascript
function Foo() {}
// 这个函数是 Function 的实例对象
// function 就是一个语法糖
// 内部调用了 new Function(...)
```

所以在new的过程中，新对象被添加了 `_proto_`并链接到了构造函数的原型上。

**new的过程？**

1. 新生成了一个对象
2. 链接到原型上
3. 绑定this
4. 返回新的对象

实现new

```javascript
function create() {
	// 创建一个空的对象
	let obj = new Object()
	// 获得构造函数
	let Con = [].shift.call(arguments)
	// 链接到原型
	obj.__proto__ = Con.prototype
	// 绑定 this，执行构造函数
	let result = Con.apply(obj, arguments)
	// 确保 new 出来的是个对象
	return typeof result === 'object' ? result : obj
}
```

对于实例对象来说，都是通过 `new` 产生的，无论是 `function Foo()` 还是 `let a = { b : 1 }` 。

[new详解]()

对于创建一个对象来说，更推荐使用字面量的方式创建对象。因为你使用 `new Object()` 的方式创建对象需要通过作用域链一层层找到 `Object`，但是你使用字面量的方式就没这个问题。

```javascript
function Foo() {}
// function 就是个语法糖
// 内部等同于 new Function()
let a = { b: 1 }
// 这个字面量内部也是使用了 new Object()
```



#  Function.proto === Function.prototype

对于对象来说，`obj._proto_.contrcutor` 是该对象的构造函数。

但是`Function.__proto__ === Function.prototype`

所有对象都可以通过原型链最终找到 `Object.prototype` ，虽然 `Object.prototype` 也是一个对象，但是这个对象却不是 `Object` 创造的，而是引擎自己创建了 `Object.prototype` 。

**所以可以这样说，所有实例都是对象，但是对象不一定都是实例。**

将`Function.prototype`打印出来，会发现这个对象其实是一个函数，这个函数是通过引擎自己创建的。首先引擎创建了`Object.prototype`，然后创建 `Function.prototype` ，并且通过 `__proto__` 将两者联系了起来。

对于`Function.__proto__ === Function.prototype` 这个问题，因为先有`Function.prototype` 以后才有的 `function Function()`。

# 总结

- `Object` 是所有对象的爸爸，所有对象都可以通过`_proto_` 找到它
- `Function` 是所有函数的爸爸，所有函数都可以通过`_proto_` 找到它
- `Function.prototype` 和 `Object.prototype` 是两个特殊的对象，他们由引擎来创建，其他对象都是通过构造器 `new` 出来的
- 函数的 `prototype` 是一个对象，也就是原型
- 对象的 `__proto__` 指向原型， `__proto__` 将对象和原型连接起来组成了原型链









































