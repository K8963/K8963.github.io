---
title:React脚手架实践
date:2021-05-12 20:38:00
comments:false
tags: 
  - JavaScript
  - React
categories:
  - 前端

---

# 创建项目

用脚手架创建
推荐使用npx

```
npx create-react-app demo
```


# hello word

1. 删除在src目录下所有文件
2. src目录下新建index.js文件作为入口文件
```javascript
// 核心模块

import React from 'react'

import ReactDOM from 'react-dom'

ReactDOM.render(<h1>hello word!</h1>, document.getElementById('root'))
```
![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070950232.png)

# 面向对象

封装继承 - 构造函数

```javascript
function Animal(val) {
  this.name = val
  this.sayInfo = function () {
    console.log('这是一只' + this.name)
  }
}

function Dog(val) {
  Animal.call(this, val)
}

var dog = new Dog('kk')
dog.sayInfo()
```

在子类型构造函数的内部调用超类型构造函数，通过使用`apply()`和`call()`方法可以在新创建的对象上执行构造函数

封装继承 - 类

```javascript
class Animal {
  constructor(val) {
    this.name = val
  }
  sayInfo() {
    console.log('这是一只' + this.name)
  }
}

class Cat extends Animal {
  constructor(props) {
    super(props)
  }
}

let cat = new Cat('mm')
cat.sayInfo()
```

# 组件化开发

定义组件分为3步：
1、导入React核心模块
2、定义组件类
3、导出组件

组件
```javascript
import React from 'react'
class Hello extends React.Component {
  render() {
    return (
      <>
        <h1>hello world!!!</h1>
      </>
    )
  }
}
export default Hello
```

在`index.js`中使用组件
```javascript
// 核心模块
import React from 'react'
import ReactDOM from 'react-dom'

import Hello from './App'

ReactDOM.render(<Hello />, document.getElementById('root'))
```

>1. 定义组件的时候，return 后面只能有一个根标签，不能有多个，但这个标签内部可以有其他多个标签
>2. 使用组件的时候，首字母必须大写 
>3. 如果最外层实在不想放置一层div根目录，可以使用 `<></>` 空标签代替

# JSX

## JSX的特点
-   JSX 执行更快，因为它在编译为 JavaScript 代码后进行了优化。
-   它是类型安全的，在编译过程中就能发现错误。
-   使用 JSX 编写模板更加简单快速。

## JSX几个注意的格式

1、React的JSX是使用大写和小写字母来区分本地组件和HTML组件
>如：html就用 div p h1 ， 组件就用 MyButton App Home List等 

2、JSX和html的标签属性的区别:


示例:
```javascript
import React, { Component } from 'react'

var myImg = require('./assets/01.png')\

export default class App2 extends Component {
  render() {
    return (
      <>
        <label htmlFor="ipt">label: </label>
        <input
          type="text"
          id="ipt"
          className="ipt"
          style={{ background: 'pink', color: 'gray' }}
        />
        <hr />
        <img src={myImg} alt="" />
      </>
    )
  }
}
```

>注意：图片查找路径在src目录，所以引入的时候从src目录触发查找文件

## 虚拟DOM

React的JSX创建出来的是虚拟DOM，而不是HTML
`index.js`
```javascript
// 核心模块
import React from 'react'
import ReactDOM from 'react-dom'

import Hello from './App'

import App2 from './App2'

ReactDOM.render(<Hello />, document.getElementById('root'))

const virtualDom = React.createElement('div')
const realDom = document.createElement('div')

let virtualNum = 0
let realNum = 0

for (var key in virtualDom) {
  virtualNum++
}
for (var key in realDom) {
  realNum++
}

console.log('虚拟DOM的属性个数：' + virtualNum)
console.log('真实DOM的属性个数：' + realNum)
```

## 变量引用、三目运算符、for循环

在JSX中，想要调用变量，需要在return中直接使用单花括号 -- `{}` 调用

```javascript
import React, { Component } from 'react'

let name = '小明',arr = [1, 2, 3, 4, 5],gender = 0

export default class App3 extends Component {
  render() {
    return (
      <>
        {/* JSX中引用变量需要加单花括号 */}
        <h3>{name}</h3>
        {/* 三目运算符的使用 */}
        <p>{gender === 0 ? '男' : gender === 1 ? '女' : '保密'}</p>
        {/* for循环的使用 - 方式1 */}
        <ul>
          {arr.map((v, k) => (
            <li key={k}>{v}</li>
          ))}
        </ul>
        {/* for循环的使用 - 方式2 */}
        <ul>
          {arr.map((v, k) => {
            return <li key={k}>{v}</li>
          })}
        </ul>
      </>
    )
  }
}
```

>总结：在jsx语法中，需要书写js代码的时候，请先加上{ } 再书写js语法


# state

## 点击事件

```javascript
import React, { Component } from 'react'

export default class App5 extends Component {
  handleClick() {
    console.log(123)
  }
  render() {
    return (
      <>
        <button onClick={this.handleClick}>btn</button>
      </>
    )
  }
}
```

## setState

setState是异步的

```javascript
import React, { Component } from 'react'

export default class App8 extends Component {
  state = {
    msg: '你好 世界',
  }
  render() {
    return (
      <>
        <h3>{this.state.msg}</h3>
        <button onClick={this.handleClick.bind(this)}>change msg</button>
      </>
    )
  }
  handleClick() {
    this.setState({
      msg: 'hello world',
    })
    // 同步则输出“hello world”，异步则输出“你好世界”
    console.log(this.state.msg)
    // 验证结果：this.setState是异步的
    // 回调函数
    // this.setState(
    //   {
    //     msg: 'hello world',
    //   },
    //   () => {
    //     console.log(this.state.msg)
    //   }
    // )
  }
}
```

## 计数器

使用 `setState` 操作 `state`

```javascript
import React, { Component } from 'react'

export default class App6 extends Component {
  constructor(props) {
    super(props)
    this.state = {
      num: 0,
    }
    this.handleClick = this.handleClick.bind(this)
  }
  handleClick() {
    this.setState({
      num: this.state.num + 1,
    })
  }
  render() {
    return (
      <>
        <h3>{this.state.num}</h3>
        {/* 通过bind来改变this的指向 */}
        {/* <button onClick={this.handleClick.bind(this)}>add</button> */}
        {/* 箭头函数默认没有this，所以this指向数组对象 */}
        {/* <button onClick={()=>this.handleClick()}>add</button> */}
        <button onClick={this.handleClick}>add</button>
      </>
    )
  }
}
```

## 双向数据绑定

React中没有类似vue的 `v-model` 指令，因此要实现双向数据绑定，只能操作 `value` 和 `onChange(或onInput)事件`。

```javascript
import React, { Component } from 'react'

export default class App7 extends Component {

  constructor(props) {
    super(props)
    this.state = {
      name: 'nike',
    }
  }
  // 简写 state
  // state = {
  //   name: 'nike',
  // }
  handleChange(e) {
    console.log(e.currentTarget.value)
    console.log(e.target.value)
    this.setState({
      name: e.target.value,
    })
  }
  render() {
    return (
      <>
        <h3>{this.state.name}</h3>
        <input
          type="text"
          value={this.state.name}
          onChange={this.handleChange.bind(this)}
        />
      </>
    )
  }
}
```

currentTarget与target有什么区别？
 - 当只有一层元素的时候，两者没区别
 - 当存在两层元素嵌套时，就会有冒泡现象，那么真正指向被你事件触发的元素，是currentTarget


## state中数组的修改

我们对数组进行操作时，大部分数组方法会修改到原数组，因此建议先将数组深拷贝一次，修改后再重新赋值：

```javascript
import React, { Component } from 'react'

export default class App9 extends Component {
  state = {
    arr: ['张飞', '关羽', '刘备'],
  }
  render() {
    return (
      <>
        <ul>
          {this.state.arr.map((item, index) => {
            return <li key={index}>{item}</li>
          })}
        </ul>
        <button onClick={this.addFn.bind(this)}>add</button>
      </>
    )
  }
  addFn() {
    // 如果我声明一个变量，等于this.state.arr，并且让这个变量和this.state.arr完全脱离关系[深拷贝]
    let newArr = JSON.parse(JSON.stringify(this.state.arr))
    newArr.push('haha')
    this.setState({
      arr: newArr,
    })
  }
}
```