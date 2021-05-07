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

# 原型链



## 原型对象与构造函数的关系

在JavaScript中，每当定义一个函数数据类型(普通函数、类)时候，都会天生自带一个prototype属性，这个属性指向函数的原型对象。

当函数经过new调用时，这个函数就成为了构造函数，返回一个全新的实例对象，这个实例对象有一个__proto__属性，指向构造函数的原型对象。

![img](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/原型1.png)

```JavaScript
function Person(){};
let p1 = new Person();
```

定义一个函数Person

new Person 并赋给p1

Person就成为了构造函数，p1就是Person这个构造函数的实例对象

实例对象p1有一个`__proto__`属性，指向构造函数 Person 的原型对象。

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/原型4.png)

## 如何描述一下原型链？

JavaScript对象通过`__proto__ `指向父类对象，直到指向Object对象为止，这样就形成了一个原型指向的链条, 即原型链。

![img](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/原型2.png)

- 对象的 hasOwnProperty() 来检查对象自身中是否含有该属性
- 使用 in 检查对象中是否含有某个属性时，如果对象中没有但是原型链中有，也会返回 true

```javascript
function Person(){};
function Programmer(){};
Programmer.prototype = new Person();
let p1 = new Programmer();
```

##  原型、原型链关系总结

```javascript
 function Person(name, age){ 
    this.name = name;
    this.age = age;
 }
 
 Person.prototype.motherland = 'china'
let p1 = new Person('小明',18);
```

**四个概念**

1. js分为函数对象的普通对象，每个对象都有`_proto_` 属性，但是只有函数对象才有 prototype 属性
2.  Object 、Function、Array、RegExp、Date、Boolean、Number、String都是js内置的函数
3. 属性`_proto_` 是一个对象，它有两个属性，constructor和 _ proto _
4. 原型对象prototype有一个默认的constructor属性，用于记录实例是由哪个构造函数创建的

**两个准则**

1. Person.prototype.constructor == Person 

   准则1：原型对象（即Person.prototype）的constructor指向构造函数本身

2. p1.__ proto__ == Person.prototype 

   准则2：实例（即p1）的__ proto__和原型对象指向同一个地方

   

![img](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/原型3.png)

```javascript
// 从上方 function Foo() 开始分析这一张经典之图
function Foo(){}
let f1 = new Foo();
let f2 = new Foo();

f1.__proto__ = Foo.prototype; // 准则2
f2.__proto__ = Foo.prototype; // 准则2
Foo.prototype.__proto__ = Object.protitype; // 准则2 (Foo.prototype本质也是普通对象，可适用准则2)
Object.prototype.__proto__ = null; // 原型链到此停止
Foo.prototype.constructor = Foo; // 准则1
Foo.__proto__ = Function.prototype; // 准则2
Function.prototype.__proto__  = Object.protitype; //  准则2 (Function.prototype本质也是普通对象，可适用准则2)
Object.prototype.__proto__ = null; // 原型链到此停止
// **此处注意Foo 和 Function的区别， Foo是 Function的实例**

// 从中间 Function Object()开始分析这一张经典之图
Function Object()
let o1 = new  Object();
let o2 = new  Object();

o1.__proto__ = Object.prototype; // 准则2
o2.__proto__ = Object.prototype; // 准则2
Object.prototype.__proto__ = null; // 原型链到此停止
Object.prototype.constructor = Object; // 准则1
Object.__proto__ = Function.prototype // 准则2 (Object本质也是函数)；
// 此处有点绕，Object本质是函数，Function本质是对象
Function.prototype.__proto__ =  Object.prototype; // 准则2 (Function.prototype本质也是普通对象，可适用准则2)
Object.prototype.__proto__ = null; // 原型链到此停止

// 从下方 Function Function()开始分析这一张经典之图
Function Function()
Function.__proto__ = Function.prototype // 准则2
Function.prototype.constructor = Function; // 准则1
```



# 继承

构造函数、原型和实例的关系：每一个构造函数都有一个原型对象，原型对象都包含一个指向构造函数的指针，而实例都包含一个原型对象的指针。

继承的本质就是**复制，即重写原型对象，代之以一个新类型的实例**。

## 如何实现继承？

> 1. 使用call
> 2. 使用原型链
> 3. 将两种组合
> 4. 组合继承的优化1
> 5. 组合继承优化(最推荐使用)：寄生组合继承

###  使用call

```javascript
function Person(){
  this.name = 'Tom';
}
function P1(){
  Person.call(this);
  this.type = 'cat'
}
console.log(new P1);
```

> call() 改变函数的this指向，语法
>
> ```javascript
> fun.call(thisArg, param1, param2, ...)
> ```
>
> 返回值:
>
> fun 执行结果
>
> 参数：
>
> `thisArg(可选)`
>
> 1.  **`fun`的`this`指向`thisArg`对象**
>
> 2. 非严格模式下：thisArg指定为null，undefined，fun中的this指向window对象.
>
> 3. 严格模式下：`fun`的`this`为`undefined`
>
> 4. 值为原始值(数字，字符串，布尔值)的this会指向该原始值的自动包装对象，如 String、Number、Boolean
>
> `param1,param2(可选)`: 传给`fun`的参数。
>
> 1. 如果param不传或为 null/undefined，则表示不需要传入任何参数.
> 2. apply第二个参数为数组，数组内的值为传给`fun`的参数。

虽然子类可以继承到父类的属性值，但是无法继承父类的方法

###  使用原型链

```javascript
  function Parent2() {
    this.name = 'parent2';
    this.play = [1, 2, 3]
  }
  function Child2() {
    this.type = 'child2';
  }
  Child2.prototype = new Parent2();

  console.log(new Child2());
```

将Child2的原型对象指向Parent2，Child2的实例便可以通过原型链找到Parent2的方法和属性。

但是此方法有一个不足：两个实例对象使用同一个原型对象，其中一个改变时，另一个也会改变

```javascript
  var s1 = new Child2();
  var s2 = new Child2();
  s1.play.push(4);
  console.log(s1.play, s2.play);
```



###  call + 原型链

```javascript
  function Parent3 () {
    this.name = 'parent3';
    this.play = [1, 2, 3];
  }
  function Child3() {
    Parent3.call(this);
    this.type = 'child3';
  }
  Child3.prototype = new Parent3();
  var s3 = new Child3();
  var s4 = new Child3();
  s3.play.push(4);
  console.log(s3.play, s4.play);
```

之前的问题都得以解决。但是这里又徒增了一个新问题，那就是Parent3的构造函数会多执行了一次（Child3.prototype = new Parent3();）



### call + 原型链 优化

```javascript
  function Parent4 () {
    this.name = 'parent4';
    this.play = [1, 2, 3];
  }
  function Child4() {
    Parent4.call(this);
    this.type = 'child4';
  }
  Child4.prototype = Parent4.prototype;
  var s3 = new Child4();
  var s4 = new Child4();
  console.log(s3)
```

这里让将父类原型对象直接给到子类，父类构造函数只执行一次，而且父类属性和方法均能访问。

但是这样子类实例的构造函数就变成了Parent4，显然这是不对的，应该是Child4。



### call + 原型链 最优

此方法也称为：寄生组合继承

```javascript
  function Parent5 () {
    this.name = 'parent5';
    this.play = [1, 2, 3];
  }
  function Child5() {
    Parent5.call(this);
    this.type = 'child5';
  }
  Child5.prototype = Object.create(Parent5.prototype);
```











































