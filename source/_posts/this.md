---
title: 关键字this
date: 2020-06-01 07:59:00
comments: false 
tags:
  - JavaScript
categories:
  - 前端
---

JavaScript之this关键字

<!-- more -->

# 为什么要使用this

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



# this的绑定规则

## 默认绑定

```javascript
function girl(){
  console.log(this)
}
girl()
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this默认绑定.png)

此处的this默认绑定全局对象window

## 隐式绑定

```javascript
let girl1 = {
  name: '小红',
  height: 160,
  weight: 180,
  datail: function () {
    console.log("小明的女朋友叫" + this.name + '，她身高' + this.height + '体重' + this.weight);
  }
}
girl1.datail();
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this隐式绑定.png)

此处的this隐式绑定对象girl1



## 硬绑定

```javascript
    console.log("---------硬绑定--------");
    let girlName = {
      name: '小红',
      sayName: function () {
        console.log("我的女朋友叫" + this.name);
      }
    }
    let girl2 = {
      name: '小黄'
    }
    let girl3 = {
      name: '小绿'
    }
    girlName.sayName.call(girl2)
    girlName.sayName.apply(girl3)
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this硬绑定.png)

使用 `call()` 和 `apply()` 方法改变了this的指向

## 构造函数绑定

```javascript
    function Lover(name) {
      this.name = name;
      this.sayName = function () {
        console.log('小明的老婆是' + this.name);
      }
    }
    let name = '小黄';
    let wife = new Lover('小红');
    wife.sayName();
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this构造函数绑定.png)

创建一个构造函数，然后对其实例化，这时候的this就会和实例化后的新对象进行捆绑，即使出现了同名的变量name，也不会影响name



# 题目测试

## 第一道

```javascript
    function a() {
      function b() {
        console.log(this);
        function c() {
          'use strict';
          console.log(this);
        }
        c();
      }
      b();
    }
    a();
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this题目测试1.png)

第3行的this，没有指定任何对象，因此使用默认绑定指向全局window对象。

第6行的this，使用了严格模式，因此this为undefined

## 第二道

```javascript
    let name = '小绿';

    function special() {
      console.log(this.name);
    }
    let girl = {
      name: '小红',
      datail: function () {
        console.log(this.name);
      },
      woman: {
        name: '小黄',
        datail: function () {
          console.log(this.name);
        }
      },
      special: special,
    }
    girl.datail();
    girl.woman.datail();
    girl.special();
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this题目测试2.png)

19行的`datail()`方法是在girl对象中调用，因此this指向girl对象中的name

20行的`datail()`方法是在girl内部对象woman中调用，此处的`datail()`方法是woman中的datail()方法，因此this指向woman对象中的name

21行的`special()`方法虽然是全局方法，但是是在girl对象中调用，this会指向实际调用该方法的对象，因此this指向girl对象中的name



## 第三道

```javascript
    var name = '小红'
    function a() {
      let name = "小绿";
      console.log(this.name);
    }
    function d(i) {
      return i();
    }
    var b = {
      name1: '小黄',
      detail: function () {
        console.log(this.name);
      },
      bibi: function () {
        return function () {
          console.log(this.name);
        };
      },
    }
    let c = b.detail;
    b.a = a
    let e = b.bibi();
    a();
    c();
    b.a();
    d(b.detail);
    e();
```

![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/JavaScript/this题目测试3.png)



# 参考

[B站蛋老师-this关键字](https://www.bilibili.com/video/BV1BE411677T/?spm_id_from=333.788.recommend_more_video.-1)















