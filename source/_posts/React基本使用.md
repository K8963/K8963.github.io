---
title: React基础 - 基本使用
date: 2021-04-27 20:38:00
comments: false
tags: 
  - JavaScript
  - React
categories:
  - 前端
---

React基本使用、jsx、事件处理、表单处理、案例总结

<!-- more -->

# React 基础

> React 是构建用户界面的 JavaScript 库

## React基本使用

### 安装 react

```bash
npm i react react-dom
```

- react 包是核心,提供创建元素\组件等功能
- react-dom 包提供 DOM 相关功能

### 使用react

1. 引入 React

   ```html
   <script src="./node_modules/react/umd/react.development.js"></script>
   <script src="./node_modules/react-dom/umd/react-dom.development.js"></script>
   ```

   

2. 创建 React 元素, 并渲染到页面中

   ```html
   <div id="root"></div>
   <script>
     // 1. 创建的元素
     // React.createElement("元素名称", 元素属性, "元素子节点(文本节点)");
     const title = React.createElement("h1", null, "Hello Raect!");
     // 2. 渲染的元素
     // ReactDOM.render(要渲染的元素, 挂载点);
     ReactDOM.render(title, document.getElementById("root"));
   </script>
   ```

   

## React 脚手架的使用

### 初始化项目

1. 初始化项目 `npx create-react-app my-app`
2. 启动项目 `cd my-app` , `yarn start`

### 在脚手架中使用 React

1. 导入 react 和 react-dom

   ```javascript
   import React from "react";
   import ReactDOM from "react-dom";
   ```

2. 创建 React 元素

   ```javascript
   const title = React.createElement("h1", null, "Hello React !");	
   ```

   

3. 渲染元素到页面中

   ```javascript
   ReactDOM.render(title, document.getElementById("root"));
   ```

   

# 基础组件

## JSX

### 基本使用

> JSX 是 JavaScript XML 的简写, 表示在JavaScript代码中写XML格式的代码.

1. 使用 JSX 创建 React 元素

   ```
   const title = <h1>Hello JSX</h1>;
   ```

   

2. 渲染元素

   ```
   ReactDOM.render(title, document.getElementById("root"));
   ```

**注意:**

1. React 的元素名使用驼峰命名法

   如: class -> className ;  for -> htmlFor ......

2. 没有子节点的 React 元素可以使用 `/>` 结束

3. 推荐使用 ==小括号包裹 JSX== 



> **为什么脚手架中可以直接使用 JSX 语法 ?**
>
> 1. jsx 不是标准的 ECMAScript 语法,它是 ECMAScript 的语法扩展
> 2. 需要使用 babel 编译处理后, 才能在浏览器中显示
> 3. create-react-app 脚手架已经默认有该配置无需手动配置
> 4. 编译 JSX 的语法包为: [@babel/preset-react](https://www.babeljs.cn/docs/babel-preset-react)
> 5. 要想在普通 html 或者 js 文件使用 jsx 需要引入babel包



### JavaScript 表达式

嵌入 js 表达式

语法: `{ JavaScript表达式 }`

```javascript
const name = "Jack";
const title = <h1 className="">Hello , {name}</h1>;
```



### 条件渲染

根据条件渲染特定的 JSX 格式

```javascript
const isLoading = true;
const loadData = () => {
  if (isLoading) {
    return <div>loading......</div>;
  } else {
    return <div>数据加载完成</div>;
  }
};

const title = (
  <h1>
    条件渲染:
    {loadData()}
  </h1>
);
ReactDOM.render(title, document.getElementById("root"));
```



### 列表渲染

渲染一组数据可以使用数组的 `map()` 方法

列表渲染时应该添加 key 属性, key属性要保证唯一的值

避免使用索引号作为key

```javascript
const songs = [
  { id: 1, name: "123" },
  { id: 2, name: "456" },
  { id: 3, name: "789" },
];
const list = (
  <ul>
    {
      songs.map((item) => (
        <li key={item.id}>{item.name}</li>
      ))
		}
  </ul>
);
ReactDOM.render(list, document.getElementById("root"));
```



### 样式处理

1. 行内样式

   以对象形式添加, 使用驼峰命名法

   ```html
   <h1 style={{ color: "red" }}>列表渲染</h1>
   ```

2. 类名 - className

   ```javascript
   <h1 className="title" style={{ color: "red" }}>
         列表渲染
       </h1>
   ```



> React 完全利用 JS 语言自身能力来编写 ui , 而不是造轮子增强 html 功能



## 创建组件

### 函数组件

使用 js 函数或者箭头函数创建的组件

- 函数名称必须以 ==大写字母开头==
- 函数组件必须有返回值, 表示该组件的结构
- 如果返回值为 null , 表示不渲染任何内容

```javascript
// 普通函数
function Hello() {
  return <div>这是一个函数组件</div>;
}
// 箭头函数
const Hello = () => <div>这是一个函数组件</div>;
ReactDOM.render(<Hello />, document.getElementById("root"));
```



### 类组件

使用 ES6 的 class 创建组件

- 类名称必须以 ==大写字母开头==
- 类组件必须继承 `React.Component` 父类, 使用父类提供的方法和属性
- 类组件必须提供 `render()` 方法
- `render()` 方法必须有返回值, 表示该组件的结构

```javascript
class Hello extends React.Component {
  render() {
    return <div> 我是类组件 </div>;
  }
}
ReactDOM.render(<Hello />, document.getElementById("root"));
```



### 组件抽离为独立的 JS 文件

1. 创建 Hello.js, 并导入 React

2. 在 Hello.js 中创建组件, 并导出组件

   ```javascript
   // Hellow.js
   import React from "react";
   
   class Hello extends React.Component {
     render() {
       return <div> 我是独立的 Hello 组件 </div>;
     }
   }
   export default Hello;
   ```

3. 在 index.js 中导入 Hello 组件 , 并渲染组件

   ```javascript
   // idnex.js
   import Hello from "./Hellow";
   
   ReactDOM.render(<Hello />, document.getElementById("root"));
   ```



## React 事件处理

### 事件绑定

语法：`on + 事件名称 = {事件处理}` , 比如: `onClick={()=>{	}}`

注意: React 事件采用==驼峰命名法==, 比如: onMouseEnter , onFoucus



```javascript
// 类组件
class App extends React.Component {
  render() {
    return <button onClick={this.handleClick}>点我</button>;
  }
  handleClick() {
    console.log(123);
  }
}
// 函数组件
function App() {
  function handleClick() {
    console.log(456);
  }
  return <button onClick={handleClick}> 点我 </button>;
}
```





### 事件对象

- 可以通过==事件处理程序的参数==获取到事件对象
- React 中的事件对象叫做: 合成事件 ( 对象 )
- 合成事件: 兼容所有浏览器,无需担心跨浏览器兼容性问题

事例场景:
点击 a 标签, 但是不跳转连接. 

```javascript
class App extends React.Component {
  handleClick(e) {
    // 阻止浏览器的默认行为
    e.preventDefault();
    console.log("跳转到百度");
  }
  render() {
    return (
      <a href="https://www.baidu.com/" onClick={this.handleClick}>
        百度
      </a>
    );
  }
}
```



### 有状态组件和无状态组件

- 函数组件 => 无状态组件 ; 类组件 => 有状态组件
- 状态( status ) 即数据
- 函数组件没有自己的状态, 只负责数据展示( 静 )
- 类组件有自己的状态, 负责更新UI和数据



### State (状态) 的使用

- 状态 (state) 即数据, 是组件内部私有数据, 只能在组件内部使用
- state 的值是对象, 表示一个组件中可以有多个数据

取出数据

```javascript
// 方法一
constructor() {
  super();
  this.state = {
    count: 0,
  };
}
// 方法二
state = {
  count: 0,
};
```

修改状态

语法: `this.setState({要修改的数据})`

注意: 不要直接修改 state 中的值, 这是错误的

react 思想: ==数据驱动视图==



### 事件绑定this指向

> 事件处理程序中的this是 underfind
>
> this 指向组件实例 ( render 方法中的this即为组件实例 )

解决方法 : 

1. 箭头函数

   利用箭头函数自身是不绑定this的特点，`render()`中的 this 就能指向组件实例

   ```javascript
   class App extends React.Component {
     state = {
       count: 0,
     };
     onIncrement() {
       this.setState({
         count: this.state.count + 1,
       });
     }
     render() {
       return (
         <div>
           <h1>计数器:{this.state.count}</h1>
           <button onClick={() => this.onIncrement()}>+1</button>
         </div>
       );
     }
   }
   ```

   

2. `Function.prototype.bind()`

   使用 ES5 中的`bind`方法将事件处理函数中的this与组件实例绑定到一起

   `constructor` 中的 this 指向组件实例

   ```javascript
   class App extends React.Component {
     constructor() {
       super();
       this.state = {
         count: 0,
       };
       this.onIncrement = this.onIncrement.bind(this);
     }
   
     onIncrement() {
       this.setState({
         count: this.state.count + 1,
       });
     }
     render() {
       return (
         <div>
           <h1>计数器:{this.state.count}</h1>
           <button onClick={this.onIncrement}>+1</button>
         </div>
       );
     }
   }
   ```

   

3. class 实例

   利用箭头函数形式的class实例方法

   ```javascript
   class App extends React.Component {
     state = {
       count: 0,
     };
     onIncrement = () => {
       this.setState({
         count: this.state.count + 1,
       });
     };
     render() {
       return (
         <div>
           <h1>计数器:{this.state.count}</h1>
           <button onClick={this.onIncrement}>+1</button>
         </div>
       );
     }
   }
   ```

   

## React 表单处理

### 受控组件

> HTML 中表单元素是可以输入的, 也就是有自己的可变状态. 而React中可变状态通常保存在 state 中,通过 steState() 方法来修改. 
>
> React 将 state 与表单元素的value绑定到一起, ==由state的值来控制表单元素的值==

受控组件基本使用

1. 在state 中添加一个状态，作为表单元素的value值（控制表单元素值的来源)
2. 给表单元素绑定change事件，将表单元素的值设置为state的值（控制表单元素值的变化)

```javascript
class App extends React.Component {
  state = {
    txt: "123",
  };
  changeTxt = (e) => {
    console.log(e.target.value);
    this.setState({
      txt: e.target.value,
    });
  };
  render() {
    return (
      <div>
        <input
          type="text"
          value={this.state.txt}
          onChange={this.changeTxt}
        ></input>
      </div>
    );
  }
}
```

练习使用受控组件

文本框, 富文本框, 下拉框, 复选框

```javascript
class App extends React.Component {
  state = {
    txt: "",
    content: "",
    city: "bj",
    isChecked: false,
  };
  handleTxt = (e) => {
    this.setState({
      txt: e.target.value,
    });
  };
  handleContent = (e) => {
    this.setState({
      content: e.target.value,
    });
  };
  handleCity = (e) => {
    this.setState({
      city: e.target.value,
    });
  };
  handleChecked = (e) => {
    this.setState({
      isChecked: e.target.checked,
    });
  };
  render() {
    return (
      <div>
        {/* 文本框 */}
        <input
          type="text"
          value={this.state.txt}
          onChange={this.changeTxt}
        ></input>
        <br />
        {/* 富文本框 */}
        <textarea
          value={this.state.content}
          onChange={this.handleContent}
        ></textarea>
        <br />
        {/* 下拉框 */}
        <select value={this.state.city} onChange={this.handleCity}>
          <option value="sh">上海</option>
          <option value="bj">北京</option>
          <option value="gz">广州</option>
        </select>
        <br />
        {/* 复选框 */}
        <input
          type="checkbox"
          checked={this.state.isChecked}
          onChange={this.handleChecked}
        ></input>
      </div>
    );
  }
}
```



### 元素优化

优化: 使用一个事件处理程序同时处理多个表单元素

步骤:

1．给表单元素添加name属性，名称与state相同

2．根据表单元素类型获取对应值

3．在change 事件处理程序中通过[name]来修改对应的state

```javascript
class App extends React.Component {
  state = {
    txt: "",
    content: "",
    city: "bj",
    isChecked: false,
  };
  handleForm = (e) => {
    const value =
      e.target.type === "checkbox" ? e.target.checked : e.target.value;
    const name = e.target.name;
    this.setState({
      [name]: value,
    });
  };
  render() {
    return (
      <div>
        {/* 文本框 */}
        <input
          type="text"
          value={this.state.txt}
          onChange={this.handleForm}
          name="txt"
        ></input>
        <br />
        {/* 富文本框 */}
        <textarea
          name="content"
          value={this.state.content}
          onChange={this.handleForm}
        ></textarea>
        <br />
        {/* 下拉框 */}
        <select name="city" value={this.state.city} onChange={this.handleForm}>
          <option value="sh">上海</option>
          <option value="bj">北京</option>
          <option value="gz">广州</option>
        </select>
        <br />
        {/* 复选框 */}
        <input
          name="isChecked"
          type="checkbox"
          checked={this.state.isChecked}
          onChange={this.handleForm}
        ></input>
      </div>
    );
  }
}
```



### 非受控组件

说明：借助于 ref , 使用原生 DOM 方式来获取表单元素值

使用步骤: 

1. 调用 `React.creatRef()` 方法创建一个 ref 对象
2. 将创建好的 ref 对象添加到文本框中
3. 通过 ref 对象获取文本框中的值

```javascript
class App extends React.Component {
  constructor() {
    super();
    this.txRef = React.createRef();
  }
  changeRef = () => {
    console.log(this.txRef.current.value);
  };
  render() {
    return (
      <div>
        <input type="text" ref={this.txRef}></input>
        <button onClick={this.changeRef}>get</button>
      </div>
    );
  }
}
```



## 组件案例

案例：评论列表

### 列表渲染

1. 在state中初始化评论列表数据
2. 使用数组的map方法遍历state中的列表数据
3. 给每个被遍历的li元素添加key属性

### 发表评论

1. 获取评论信息
2. 给按钮绑定单击事件
3. 在事件处理程序中，通过state获取评论信息
4. 将评论信息添加到state中，并调用setState(方法更新state
5. 边界处理：清空文本框，非空判断



```javascript
class App extends React.Component {
  state = {
    comments: [
      { id: 1, name: "jack", content: "沙发!!!" },
      { id: 2, name: "jack2", content: "沙发2!!!" },
      { id: 3, name: "jack3", content: "沙发3!!!" },
    ],
    userName: "",
    userContent: "",
  };
  issue = (e) => {
    console.log();
  };
  // 列表渲染
  renderList = () => {
    if (this.state.comments.length === 0) {
      return <div className="no-comment">暂无评论</div>;
    } else {
      return (
        <ul>
          {this.state.comments.map((item) => (
            <li key={item.id}>
              <h3>{item.name}</h3>
              <p>{item.content}</p>
            </li>
          ))}
        </ul>
      );
    }
  };
  // 发表评论
  handleForm = (e) => {
    const { name, value } = e.target;
    this.setState({
      [name]: value,
    });
  };
  addComment = (e) => {
    const { comments, userName, userContent } = this.state;
    if (userName.trim() === "" || userContent.trim() === "") {
      alert("请输入内容!");
    }
    const newComments = [
      {
        id: Math.random(),
        name: userName,
        content: userContent,
      },
      ...comments,
    ];
    // console.log(newComment);
    this.setState({
      comments: newComments,
    });
    this.setState({
      userName: "",
      userContent: "",
    });
  };
  render() {
    const { userName, userContent } = this.state;
    return (
      <div className="box">
        <label>评论人：</label>
        <input
          type="text"
          className="user"
          value={userName}
          name="userName"
          onChange={this.handleForm}
        ></input>
        <label>评论内容：</label>
        <textarea
          className="content"
          value={userContent}
          name="userContent"
          onChange={this.handleForm}
        ></textarea>
        <button onClick={this.issue} onClick={this.addComment}>
          发表
        </button>
        {this.renderList()}
      </div>
    );
  }
}
```



































































