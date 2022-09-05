---
title: React 原理
date: 2021-11-07 01:38:00
comments: false
tags: 
  - JavaScript
  - React
categories:
  - 前端
---

- setState() 异步更新数据
- JXS 语法转化过程
- React 组件更新机制
- 组件性能优化
- 虚拟DOM、Diff算法

<!-- more -->

# React 原理

## setState() 方法

### 更新数据

- `setState()` 是异步更新数据的
- 后面的`setState()` 是不依赖于前面的`setState()` 
- 可以调用多次`setState()` ,但是只会触发一次`render`重新渲染

```javascript
class App extends React.Component {
  state = {
    count: 1,
  };
  handleAdd = (e) => {
    this.setState({
      count: this.state.count + 1,
    });
    // setSate()已执行完，但此处输出 1
    console.log("count:" + this.state.count);
    // 由于setState()是异步的，再次调用setState()，页面的count还是2
    this.setState({
      count: this.state.count + 1,
    });
  };
  render() {
    return (
      <div>
        <h1>计数:{this.state.count}</h1>
        <button onClick={this.handleAdd}>+1</button>
      </div>
    );
  }
}
```

解决当调用两次`setState()`，第一次`setState()`并不影响第二次`setState()`值的问题.

```javascript
class App extends React.Component {
  state = {
    count: 1,
  };
  handleAdd = (e) => {
    this.setState((state, props) => {
      return { count: state.count + 1 };
    });
    this.setState((state, props) => {
      return { count: state.count + 1 };
    });
  };
  render() {
    return (
      <div>
        <h1>计数:{this.state.count}</h1>
        <button onClick={this.handleAdd}>+1</button>
      </div>
    );
  }
}
```

`setState()` 经过这样的处理之后，调用两次`setSate()`页面上`count`的值为2.`setState()`回调函数内`state`和`props`都是最新的

### 回调函数

`setState(updater[,callback])`

第二参数回调函数，会在状态更新完成、重新渲染后立即执行某个操作，可以获取到最新的state，操作DOM等操作。

`setState()`的回调函数与`componentDidUpdate()`有一定的相似之处.在某些情况下可以代替使用

```javascript
class App extends React.Component {
  state = {
    count: 1,
  };
  handleAdd = (e) => {
    this.setState(
      (state, props) => {
        return { count: state.count + 1 };
      },
      () => {
        console.log("状态更新完成：" + this.state.count);
        console.log(document.getElementById("title").innerHTML);
        document.title = "更新后的count为：" + this.state.count;
      }
    );
  };
  render() {
    return (
      <div>
        <h1 id="title">计数:{this.state.count}</h1>
        <button onClick={this.handleAdd}>+1</button>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
```



![image-20211107001528622](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211107001528622.png)

## JSX语法的转化过程

- JSX 仅仅是`createElement()`方法的语法糖(简化语法)
- JSX 语法被`@babel/preset-react`插件编译为`createElement()`方法
- React 元素:是一个对象,用来描述页面上的内容

![image-20211107002508782](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211107002508782.png)

代码演示:

```javascript
const element1 = <h1 className="title1">Hello JSX!</h1>;
const element2 = React.createElement(
  "h1",
  {
    className: "title2",
  },
  "Hello JSX!"
);

console.log(element1);
console.log(element2);
```

![image-20211107003338618](../../../../All/React/黑马/img/image-20211107003338618.png)



## 组件更新机制

`setState()`的两个作用:1.修改 state 2.更新组件UI

父组件重新渲染时,也会重新渲染子组件.但是只会渲染==当前组件子树==



![](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211107003612195.png)

代码体现

```javascript
class App extends React.Component {
  state = {
    color: "#369",
  };
  getBG() {
    return Math.floor(Math.random() * 256);
  }
  changeBG = (e) => {
    this.setState(() => {
      return {
        color: `rgb(${this.getBG()},${this.getBG()},${this.getBG()})`,
      };
    });
  };
  render() {
    console.log("根组件");
    return (
      <div className="app" style={{ backgroundColor: this.state.color }}>
        <button onClick={this.changeBG}>根组件 - 切换样式状态</button>
        <div className="app-wrapper">
          <Parent1 />
          <Parent2 />
        </div>
      </div>
    );
  }
}
// 左侧
class Parent1 extends React.Component {
  state = {
    count: 0,
  };
  handleClick = () => {
    this.setState((state) => {
      return { count: state.count + 1 };
    });
  };
  render() {
    console.log("左侧 - 父组件");
    return (
      <div className="parent">
        <h2>
          左侧
          <button onClick={this.handleClick}>点我({this.state.count})</button>
        </h2>
        <div className="parent-wrapper">
          <Child1_1 />
          <Child1_2 />
        </div>
      </div>
    );
  }
}
class Child1_1 extends React.Component {
  render() {
    console.log("左侧 - 子组件1");
    return <p>子组件1-1</p>;
  }
}
class Child1_2 extends React.Component {
  render() {
    console.log("左侧 - 子组件2");
    return <p>子组件1-2</p>;
  }
}

// 右侧
class Parent2 extends React.Component {
  state = {
    count: 0,
  };
  handleClick = () => {
    this.setState((state) => {
      return { count: state.count + 1 };
    });
  };
  render() {
    console.log("右侧 - 父组件");
    return (
      <div className="parent">
        <h2>
          右侧
          <button onClick={this.handleClick}>点我({this.state.count})</button>
        </h2>
        <div className="parent-wrapper">
          <Child2_1 />
          <Child2_2 />
        </div>
      </div>
    );
  }
}
class Child2_1 extends React.Component {
  render() {
    console.log("右侧 - 子组件1");
    return <p>子组件2-1</p>;
  }
}
class Child2_2 extends React.Component {
  render() {
    console.log("右侧 - 子组件2");
    return <p>子组件2-2</p>;
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
```



## 组件性能优化

### 减轻state

减轻state :只存储→组件渲染相关的数据（比如: count /列表数据 / loading等)

注意:不用做渲染的数据不要放在state 中，比如定时器id等

对于这种需要在多个方法中用到的数据，应该放在this 中

```javascript
class Hello extends Comment{
  componentDidMount() {
    // 定时器id应该存储在this中，而不是state
    this.timerId = setInterval(()=>{},2000)
  }
  compoentWithUnmount() {
    clearInterval(this.timerId);
  }
  render(){}
}
```



### 避免不必要的重新渲染

组件更新机制︰父组件更新会引起子组件也被更新，子组件没有任何变化时也会重新渲染

使用钩子函数`shouldComponentUpdate(nextProps, nextState)`可以免不必要的重新渲染，`nextProps, nextState`表示最新的`props、state`

通过返回值决定该组件是否重新渲染，返回true表示重新渲染，false表示不重新渲染触发时机∶更新阶段的

钩子函数，组件重新渲染前执行（ shouldComponentUpdate =>render )

```javascript
shouldComponentUpdate(nextProps, nextState) {
  // 组件不会重新渲染
  // return false;
  // 最新的state
  console.log("nextState", nextState);
  // 更新前的state
  console.log("this.state", this.state);
  // 这样可以通过对比更新前后state是否相同判断是否更新组件
  return true;
}
```

![image-20211107111032805](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211107111032805.png)

随机数案例：

```javascript
class App extends React.Component {
  state = {
    number: 0,
  };
  handleClick = (e) => {
    this.setState(() => {
      return { number: Math.floor(Math.random() * 3) };
    });
  };
  shouldComponentUpdate(nextProps, nextState) {
    console.log("nextState", nextState, ",", "this.state", this.state);
    return nextState.number === this.state.number ? false : true;
  }
  render() {
    console.log("组件更新了");
    return (
      <div>
        <h1>随机数{this.state.number}</h1>
        <button onClick={this.handleClick}>生产随机数</button>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
```

![image-20211107114203413](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211107114203413.png)



## 纯组件

纯组件: PureComponent与React.Component功能相似

区别: PureComponent内部自动实现了shouldComponentUpdate钩子,不需要手动比较

原理:纯组件内部通过分别对比前后两次props和state的值,来决定是否重新渲染组件

```javascript
class App extends React.PureComponent {
  state = {
    number: 0,
  };
  handleClick = (e) => {
    this.setState(() => {
      return { number: Math.floor(Math.random() * 3) };
    });
  };
  render() {
    console.log("组件更新了");
    return (
      <div>
        <h1>随机数{this.state.number}</h1>
        <button onClick={this.handleClick}>生产随机数</button>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
```



### 浅层对比

说明:纯组件内部的对比是shallow compare (浅层对比)

- 值类型来说:比较两个值是否相同(直接赋值即可,没有坑)

- 引用类型来说:只比较对象的引用(地址)是否相同

> 注意: `state`或`props`中属性值为引用类型时,应该创建新数据,不要直接修改原数据!

```javascript
class App extends React.PureComponent {
  state = {
    obj: {
      number: 0,
    },
  };
  handleClick = (e) => {
    const newObj = { ...this.state.obj, number: Math.floor(Math.random() * 3) };
    this.setState(() => {
      return { obj: newObj };
    });
  };
  render() {
    console.log("组件更新了");
    return (
      <div>
        <h1>随机数{this.state.obj.number}</h1>
        <button onClick={this.handleClick}>生产随机数</button>
      </div>
    );
  }
}
```

## 虚拟DOM和Diff算法

> React更新视图只要state变化就重新渲染视图
>
> React中通过==虚拟DOM配合Diff算法==实现部分更新

虚拟DOM：本质就是一个JS对象，用来描述页面上的内容，其实就是我们说的React元素

**Diff 执行过程**

1. 初次渲染时，React会根据初始state ( Model )，创建一个虚拟DOM对象（树)。

2. 根据虚拟DOM生成真正的DOM，渲染到页面中。

   ![image-20211108123325819](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211108123325819.png)

3. 当数据变化后( setState( )，重新根据新的数据，创建新的虚拟DOM对象(树)。

4. 与上一次得到的虚拟DOM对象，使用Diff算法对比(找不同），得到需要更新的内容。

5. 最终，React只将变化的内容更新( patch )到DOM中，重新渲染到页面。



![image-20211108123345135](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211108123345135.png)





















