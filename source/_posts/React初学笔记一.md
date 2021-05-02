---
title: React初学笔记一
date: 2021-04-27 20:38:00
comments: false
tags: 
  - JavaScript
  - React
categories:
  - 前端
---

React初学笔记一

JSX、组件、state

<!-- more -->

# JSX

全称：JavaScript XML

react定义的一种类似于XML的js扩展语法：js+xml

jsx语法规则

1. 定义虚拟DOM时，不要写引号

2. 标签中混入JS表达式时要用{}

3. 样式的类名指定不要用class，而是使用className

4. 内联样式需要用`style={{key:value}}`的形式去写

5. 只有一个根标签

6. 标签必须闭合

7. 标签首字母：

   a. 若小写字母开头，则将改标签转为html中同名元素，若html中无该标签对应的同名元素，则报错。

   b. 若大写字母开头，react就去渲染对应的组件，若组件没有定义，则报错。

# 组件

## 函数式组件

```javascript
// 1.创建函数式组件
function Dome() {
      /*
        babel 翻译后开启了严格模式
        组件中的 this 是undefined
      */
      console.log(this);
      return <h2>简单组件</h2>
    }
    // 2.渲染组件到页面
    ReactDOM.render(<Dome />, document.getElementById('test'))
```

执行 ReactDOM.render(<Dome />, ...) 之后发生了什么

1. React解析组件标签，找到了 Dome 组件
2. 发现组件是使用函数定义的，随后调用该函数，将返回的虚拟dom转为真实dom随后呈现在页面中

## 类组件

```JavaScript
class Dome extends React.Component{
  // render 存储在类的原型对象上，供实例使用
  // render 中的this是，Dome的实例对象
  render(){
    console.log(this);
    return <h2>复杂组件</h2>
  }
}
// 渲染
ReactDOM.render(<Dome/>,document.getElementById('test'))
```
执行 ReactDOM.render(<Dome />, ...) 之后发生了什么

1. React解析组件标签，找到了 Dome 组件
2. 发现组件是使用类定义的，随后new出该类的实例，并通过实例调用到该原型上的render方法
3. 将返回的虚拟dom转为真实dom，随后呈现在页面中

# 组件核心属性 - state

state小例子

```javascript
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>
  <div id="test"></div>
  <script src="../js/react.development.js"></script>
  <script src="../js/react-dom.development.js"></script>
  <script src="../js/babel.min.js"></script>
  <script type="text/babel">
    class Weather extends React.Component {
      // 构造器调用1次
      constructor(props) {
        super(props)
        this.state = { isHot: true }
        // 使用bind更改this指向
        this.dome = this.changeWeather.bind(this)
      }

      // 触发几次调用几次
      changeWeather() {
        const { isHot } = this.state
        // 状态需要调用setState更新，并且这种更新是合并
        this.setState({ isHot: !isHot })
      }
      // 调用1+n次，1是初始化，n是状态更新的次数
      render() {
        // 解构获值
        const { isHot } = this.state
        // 此处调用的是修改使用bind创建新函数并且修改this指向所赋值的dome
        return <h1 onClick={this.dome}>天气{isHot ? '炎热' : '凉爽'}</h1>
      }
    }
    ReactDOM.render(<Weather />, document.getElementById('test'))
  </script>
</body>

</html>
```

1. 创建一个类组件 Weather

2. 向 Weather 中添加一个构造函数，用来初始化 state

   > **注意**
   >
   > 在 [JavaScript class](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) 中，每次你定义其子类的构造函数时，都需要调用 `super` 方法。因此，在所有含有构造函数的的 React 组件中，构造函数必须以 `super(props)` 开头。

3. 新建一个 changeWeather 方法用来更新 state 中的值，更新 state 需要使用 setState 方法

   方法中的this为undefined

4. 需要通过bind创建新函数并且修改this指向所赋值的dome，渲染组件并绑定dome

   dome中this指向 Weather 实例对象