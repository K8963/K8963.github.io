---
title: this、call、apply、band
date: 2020-07-21 07:59:00
comments: false 
tags:
  - JavaScript
categories:
  - 前端
---

this、call、apply、band

<!-- more -->
# this

## 为什么要使用this

减少代码量，使代码整洁

未使用this

```javascript
let myNewCar = {
  type:'truck',
  size:'big',
  description:fuunction(){
  	console.log("这个车的类型是：" + myNewCar.type + ',它的尺寸是：' + myNewCar.size);
	}
}
myNewCar.description()
```

使用this后

```javascript
let myNewCar = {
  type:'truck',
  size:'big',
  description:fuunction(){
  	console.log("这个车的类型是：" + this.type + ',它的尺寸是：' + this.size);
	}
}
myNewCar.description()
```



## thiss的指向

**this永远指向最后调用它的那个对象**

函数中的this

```javascript
var name = "windowsName";
function a() {
    var name = "Cherry";

    console.log(this.name);          // windowsName

    console.log("inner:" + this);    // inner: Window
}
a();
console.log("outer:" + this)         // outer: Window
```



对象中的this

```javascript
var name = "windowsName";
var a = {
    name: "Cherry",
    fn : function () {
        console.log(this.name);      // Cherry
    }
}
a.fn();
window.a.fn();
```



对象中的函数赋值给一个变量，再执行变量

```javascript
var name = "windowsName";
var a = {
    name : null,
    // name: "Cherry",
    fn : function () {
        console.log(this.name);      // windowsName
    }
}

var f = a.fn;
f();
```



## 改变this的指向

- 使用ES6箭头函数
- 在函数内部使用 `_this = this`
- 使用`apply`、 `call` 、`bind`
- new 实例化一个对象

例子：

```javascript
var name = "windowsName";

var a = {
    name : "Cherry",

    func1: function () {
        console.log(this.name)     
    },

    func2: function () {
        setTimeout(  function () {
            this.func1()
        },100);
    }

};

a.func2()     // this.func1 is not a function
```
最后调用setTimeout的是window对象，但是在window中并没有func1函数，因此会报错。

### 箭头函数

**箭头函数的this始终指向函数定义时的this，而非执行时的**

箭头函数中没有this绑定，必须通过查询作用域链来决定其值，如果箭头函数被非箭头函数包含，则 this 绑定的是最近一层非箭头函数的 this，否则，this 为 undefined。

```javascript
var name = "windowsName";
var a = {
    name : "Cherry",
    func1: function () {
        console.log(this.name)     
    },
    func2: function () {
        setTimeout( () => {
            this.func1()
        },100);
    }
};
a.func2()     // Cherry
```
setTimeout回调函数中的箭头函数被fun2包含，fun2绑定的this是对象a，因此箭头函数中的zhit也指向对象a

### _this = this

我们是先将调用这个函数的对象保存在变量 `_this` 中，然后在函数中都使用这个 `_this`，这样 `_this` 就不会改变了。

```javascript
var name = "windowsName";
var a = {
    name : "Cherry",
    func1: function () {
        console.log(this.name)     
    },
    func2: function () {
        var _this = this;
        setTimeout( function() {
            _this.func1()
        },100);
    }
};
a.func2()       // Cherry
```
`var _this = this;` _this变量接收this指向的对象a，在回调函数中调用 _this变量 就是调用对象a

### 使用 apply、call、bind

使用apply

```javascript
var a = {
    name : "Cherry",
    func1: function () {
        console.log(this.name)
    },
    func2: function () {
        setTimeout(  function () {
            this.func1()
        }.apply(a),100);
    }
};

a.func2()            // Cherry
```
使用call

```javascript
var a = {
    name : "Cherry",
    func1: function () {
        console.log(this.name)
    },
    func2: function () {
        setTimeout(  function () {
            this.func1()
        }.call(a),100);
    }
};
a.func2()            // Cherry
```
使用bind

```javascript
var a = {
    name : "Cherry",
    func1: function () {
        console.log(this.name)
    },
    func2: function () {
        setTimeout(  function () {
            this.func1()
        }.bind(a)(),100);
    }
};
a.func2()            // Cherry
```


# apply、call、bind 区别

apply、call、bind 都是可以改变 this 的指向

在 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) 中定义 apply 如下；

> apply() 方法调用一个函数, 其具有一个指定的this值，以及作为一个数组（或类似数组的对象）提供的参数

语法：

```javascript
fun.apply(thisArg, [argsArray])
```

- thisArg：在 fun 函数运行时指定的 this 值。需要注意的是，指定的 this 值并不一定是该函数执行时真正的 this 值，如果这个函数处于非严格模式下，则指定为 null 或 undefined 时会自动指向全局对象（浏览器中就是window对象），同时值为原始值（数字，字符串，布尔值）的 this 会指向该原始值的自动包装对象。
- argsArray：一个数组或者类数组对象，其中的数组元素将作为单独的参数传给 fun 函数。如果该参数的值为null 或 undefined，则表示不需要传入任何参数。从ECMAScript 5 开始可以使用类数组对象。浏览器兼容性请参阅本文底部内容。

## apply 和 call 的区别

其实 apply 和 call 基本类似，他们的区别只是传入的参数不同。

call 的语法为：

```javascript
fun.call(thisArg[, arg1[, arg2[, ...]]])复制代码
```

所以 apply 和 call 的区别是 call 方法接受的是若干个参数列表，而 apply 接收的是一个包含多个参数的数组。

apply

```javascript
var a ={
    name : "Cherry",
    fn : function (a,b) {
        console.log( a + b)
    }
}
var b = a.fn;
b.apply(a,[1,2])     // 3
```
call

```javascript
var a ={
    name : "Cherry",
    fn : function (a,b) {
        console.log( a + b)
    }
}
var b = a.fn;
b.call(a,1,2)       // 3
```


## bind 和 apply、call 区别

 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) 文档上对bind说明：

> bind()方法创建一个新的函数, 当被调用时，将其this关键字设置为提供的值，在调用新函数时，在任何提供之前提供一个给定的参数序列。

bind 是创建一个新的函数，我们必须要手动去调用：

```javascript
var a ={
    name : "Cherry",
    fn : function (a,b) {
        console.log( a + b)
    }
}
var b = a.fn;
b.bind(a,1,2)()           // 3
```














