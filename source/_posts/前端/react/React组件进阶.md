---
title: React基础 - 组件进阶
date: 2021-10-22 22:38:00
comments: false
author: 8963
tags: 
  - JavaScript
  - React
categories:
  - 前端
---

组件通讯、props

<!-- more -->

# 组件进阶

## 组件的props

组件是封闭的, 要接收外部数据应该通过 props 来实现, props 可以接收传递给组件的数据.

传递数据: 给组件标签添加属性

接收数据: 函数组件通过`参数props`接收数据, 类组件通过 `this.props` 接收数据

特点：

1. 可以传递任意类型的数据
2. `props` 是只读的对象, 只能读取数据的值, 无法修改对象
3. ==注意 :== 使用类组件时如果写了构造函数, 应该将 `props` 传递给 `super()` , 否则无法在构造函数中 获取到 `props` , 但是这对其他函数(如`render()`)并没有影响.

```javascript
//	函数组件
const Hello = (props) => {
  console.log(props);
  // 调用接收的函数
  props.fn();
  return (
    <div>
      <h1>props:{props.name}</h1>
      {/* 使用接收的jsx表达式 */}
      {props.tag}
    </div>
  );
};

//	类组件
const Hello = (props) => {
  console.log(props);
  // 调用接收的函数
  props.fn();
  return (
    <div>
      <h1>props:{props.name}</h1>
      {/* 使用接收的jsx表达式 */}
      {props.tag}
    </div>
  );
};

ReactDOM.render(
  <Hello
    name="jack"
    age={19}
    color={["red", "green", "blue"]}
    fn={() => {
      console.log("传递一个函数给组件");
    }}
    tag={<p>传递一个p标签给组件</p>}
  />,
  document.getElementById("root")
);
```



## 组件通讯

> 组件是独立且封闭的单元，默认情况下，只能使用组件自己的数据。在组件化过程中，我们将一个完整的功能拆分成多个组件，以更好的完成整个应用的功能。而在这个过程中，多个组件之间不可避免的要共享某些数据。为了实现这些功能，就需要打破组件的独立封闭性，让其与外界沟通。这个过程就是 ==组件通讯==

组件通讯方式

- 父组件 => 子组件
- 子组件 => 父组件
- 兄弟组件

### 父传子

1. 父组件要提供传递给`state`的数据
2. 给子组件标签添加属性，值为state中的数据
3. 子组件中通过props接收父组件中传递的数据

```javascript
class Parent extends React.Component {
  state = { lastName: "王" };
  render() {
    return (
      <div>
        父组件
        <Child lastName={this.state.lastName} />
      </div>
    );
  }
}

class Child extends React.Component {
  render() {
    return <div>父组件的数据:{this.props.lastName}</div>;
  }
}

ReactDOM.render(<Parent />, document.getElementById("root"));
```



### 子传父

思路:利用回调函数，父组件提供回调，子组件调用，将要传递的数据作为回调函数的参数。

1. 父组件提供一个回调函数（用于接收数据）
2. 将该函数作为属性的值，传递给子组件
3. 子组件通过 `props` 调用回调函数

```javascript
class Parent extends React.Component {
  state = {
    data: "",
  };
  getChildMsg = (msg) => {
    console.log("接收到的数据:", msg);
    this.setState({
      data: msg,
    });
  };
  render() {
    return (
      <div>
        父组件接收到子组件的数据:{this.state.data}
        <Child getChildMsg={this.getChildMsg} />
      </div>
    );
  }
}

class Child extends React.Component {
  state = { childMsg: "React" };
  handleClick = () => {
    this.props.getChildMsg(this.state.childMsg);
  };
  render() {
    return (
      <div>
        <button onClick={this.handleClick}>子组件给子组件传递数据</button>
      </div>
    );
  }
}

ReactDOM.render(<Parent />, document.getElementById("root"));
```



### 兄弟组件

将共享状态提升到最近的公共父组件中，由公共父组件管理这个状态

思想:状态提升

公共父组件职责∶

1. 提供共享状态

2. 提供操作共享状态的方法要通讯的子组件

只需通过props接收状态或操作状态的方法

```javascript
class Parent extends React.Component {
  // 提供共享的状态
  state = {
    count: 0,
  };
  addCount = () => {
    this.setState({
      count: this.state.count + 1,
    });
  };
  render() {
    return (
      <div>
        <Child1 count={this.state.count} />
        <Child2 addCount={this.addCount} />
      </div>
    );
  }
}

class Child1 extends React.Component {
  render() {
    return <h1>计数器:{this.props.count}</h1>;
  }
}
class Child2 extends React.Component {
  handleClick = () => {
    this.props.addCount();
  };
  render() {
    return <button onClick={this.handleClick}>+1</button>;
  }
}

ReactDOM.render(<Parent />, document.getElementById("root"));
```



## Context

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070754750.png)

思考:App组件要传递数据给`Child`组件，该如何处理?

处理方式:使用`props`一层层组件往下传递（繁琐)

更好的解决办法：Context ==跨组件传递数据（比如主题、预言等）==

使用Context：

1. 调用`React. createContext()`创建`Provider`(提供数据）和`Consumer`(消费数据）两个组件。
2. 使用`Provider`组件作为父节点。
3. 在`Provider`上设置value的值, 表示要传递的值
4. 使用`Consumer`组件来接收数据

```javascript
// 创建 context
const { Provider, Consumer } = React.createContext();

class App extends React.Component {
  render() {
    return (
      <Provider value="pink">
        <div className="app">
          <Node />
        </div>
      </Provider>
    );
  }
}
class Node extends React.Component {
  render() {
    return (
      <div className="node">
        <SubNode />
      </div>
    );
  }
}
class SubNode extends React.Component {
  render() {
    return (
      <div className="subnode">
        <Child />
      </div>
    );
  }
}
class Child extends React.Component {
  render() {
    return (
      <div className="child">
        <Consumer>
          {(data) => <span> data表示接收到的数据:{data}</span>}
        </Consumer>
      </div>
    );
  }
}
ReactDOM.render(<App />, document.getElementById("root"));
```



## Props 深入

### children 属性

`children`属性︰表示组件标签的子节点。当组件标签有子节点时，props就会有该属性

`children`属性与普通的`props`一样，值可以是任意值（文本、React元素、组件，甚至是函数)

```javascript
const App = (props) => {
  console.log(props);
  props.children[3]();
  return (
    <div>
      <h1>组件标签的子节点：</h1>
      {props.children[0]}
      {props.children[1]}
      {props.children[2]}
    </div>
  );
};
const Test = () => <button>我是一个button组件</button>;

ReactDOM.render(
  <App>
    我是子节点
    <p>我是一个p标签</p>
    <Test />
    {() => {
      console.log("我是一个函数");
    }}
  </App>,
  document.getElementById("root")
);
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070754804.png)



### Props 校验

对于组件来说，`props`是外来的，无法保证组件使用者传入什么格式的数据, 如果传入的数据格式不对，可能会导致组件内部报错

`props`校验∶允许在创建组件的时候，就指定`props`的类型、格式等

作用︰捕获使用组件时因为`props`导致的错误，给出明确的错误提示，增加组件的健壮性

使用:

1. 安装包`prop-types` ( yarn add prop-types / npm i props-types )
2. 导入`prop-types`包
3. 使用`组件名.propTypes ={}`来给组件的props添加校验规则
4. [校验规则](https://reactjs.org/docs/typechecking-with-proptypes.html)通过`PropTypes` 对象来指定

```javascript
import PropType from "prop-types";

const App = (props) => {
  const arr = props.colors;
  const lis = arr.map((item, index) => <li key={index}>{item}</li>);
  return <ul>{lis}</ul>;
};
App.propTypes = {
  colors: PropType.array,
};

ReactDOM.render(
  <App colors={["red", "blue"]}></App>,
  document.getElementById("root")
);
// ReactDOM.render(<App colors={19}></App>, document.getElementById("root"));
```

类型不一致时报错:

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070754910.png)



约束规则:

1. 常见类型: array、bool、func、number、object、stringReact
2. 元素类型:element
3. 必填项: isRequired
4. 特定结构的对象: shape({ })

[校验规则](https://reactjs.org/docs/typechecking-with-proptypes.html)

```javascript
import PropType from "prop-types";
//添加props校验1/属性a的类型; 数值（number)
//属性 fn的类型:  函数（func）并且为必填项
//属性tag的类型:  React元素（element)
//属性filter的类型: 对象（{area: ‘上海',price: 1999})

const App = (props) => {
  return <h1>props 校验</h1>;
};
App.propTypes = {
  a: PropType.number,
  fn: PropType.func.isRequired,
  tag: PropType.element,
  filter: PropType.shape({
    area: PropType.string,
    price: PropType.number,
  }),
};
ReactDOM.render(<App></App>, document.getElementById("root"));
```

### Props 默认值

给props设置默认值，在未传入props 时生效

```javascript
import PropType from "prop-types";
const App = (props) => {
  console.log(props);
  return <h1>props 默认值:{props.pageSize}</h1>;
};
App.defaultProps = {
  pageSize: 10,
};
ReactDOM.render(<App></App>, document.getElementById("root"));
```

## 组件的生命周期

生命周期：组件从被创建到挂载到页面中运行，再到组件不用时卸载的过程

生命周期的每个阶段总是伴随着一些方法调用，这些方法就是生命周期的钩子函数。

钩子函数的作用:为开发人员在不同阶段操作组件提供了时机。

==只有类组件才有生命周期==

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070754602.png)

### 1.创建时(挂载阶段)

执行时机:组件创建时( 页面加载时 )

执行顺序:

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755097.png)

说明：

1. constructor()

   创建组件时，最先执行

   作用：

   - 初始化state
   - 为事件处理程序绑定`this`

2. render()

   每次组件渲染都会触发

   作用:

   - 渲染 UI (注意: 不能调用 `setState()` )

     > 因为 `setState()` 方法在更新state后会调用`render()`渲染ui, 如果在`render`中调用`setState()`会造成递归产生错误. 

3. componentDidMount()

   组件挂载(完成 DOM 渲染) 后

   作用:

   - 发送网络请求
   - DOM 操作   

```javascript
class App extends React.Component {
  constructor(props) {
    super(props);
    console.warn("生命周期函数：constructor！");
  }
  render() {
    console.warn("生命周期函数：render！");
    return (
      <div></div>
    );
  }
  componentDidMount() {
    console.warn("生命周期函数：componentDidMount！");
  }
}
ReactDOM.render(<App></App>, document.getElementById("root"));
```



### 2.更新时

#### 触发`render()`

1. setState()
2. foreUpdate()
3. 组件接收到新的`props`

以上任意一种情况都会触发`render()`重新渲染

```javascript
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
    };
  }
  handleClick = () => {
    // setState()
    // this.setState({
    //   count: this.state.count + 1,
    // });
    // 强制更新
    this.forceUpdate();
  };
  render() {
    console.warn("生命周期函数：render！");
    return (
      <div>
        {/* 传递新的props */}
        <Counter count={this.state.count} />
        <button onClick={this.handleClick}>打豆豆</button>
      </div>
    );
  }
}
class Counter extends React.Component {
  render() {
    console.warn("--子组件--生命周期函数：render！");
    return <h1>统计被打豆豆的次数：{this.props.count}</h1>;
  }
}
```



#### 更新阶段

执行顺序：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755233.png)

说明：

1. render()

   每次组件渲染都会触发

   作用:

   - 渲染 UI (注意: 不能调用 `setState()` )

2. componentDidUpdate()

   组件更新（完成DOM渲染）后

   作用：

   - 发送网络请求

   - DOM操作

     > 注意：如果要`setState()`必须放在一个`if`条件中
     >
     > 如果直接调用 `setState()`更新状态, 也会导致递归更新

```javascript
class Counter extends React.Component {
  render() {
    console.warn("--子组件--生命周期函数：render！");
    return <h1>统计被打豆豆的次数：{this.props.count}</h1>;
  }
  componentDidUpdate(prevProps) {
    console.warn("--子组件--生命周期函数：componentDidUpdate！");
    // 比较更新前后的props是否相同, 来决定是否重新渲染组件
    // console.log("上一次的props:", prevProps, ",当前的props", this.props);
    if (prevProps.count !== this.props.count) {
      this.setState({});
      // 发送Ajax请求
    }
  }
}
```



### 3.卸载时

执行时机:组件从页面中消失

`componentWillUnmount()`

组件卸载(从页面中消失)

作用:

- 执行清理工作(如清理定时器)

```javascript
class Counter extends React.Component {
  componentDidMount() {
    // 开启定时器
    this.timerId = setInterval(() => {
      console.log("定时器正在执行~");
    }, 1000);
  }
  render() {
    return <h1 id="title">统计被打豆豆的次数：{this.props.count}</h1>;
  }
  componentWillUnmount() {
    console.warn("生命周期函数: componentWillUnmount");
    // 清理定时器
    clearInterval(this.timerId);
  }
}
```



### 不常用的钩子函数

旧版的生命周期钩子函数

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755146.jpg)

新版完整的生命周期钩子函数

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755101.png)



## render props 模式

> 组件复用，复用相似的功能，要复用`state`,操作`state`的方法,组件状态逻辑.
>
> 实现组件复用的方法:
>
> 1. render props模式
> 2. 高阶组件 (HOC)

`render prpos` 模式思路分析:

1. 在使用组件时,添加一个值为==函数的props==,通过函数==参数==来获取组件中复用的`state`(需要组件内部来实现)
2. 使用==该函数的返回值==作用为要渲染的UI的内容(需要组件内部要实现)

### 使用复用组件

1. 创建Mouse组件，在组件中提供复用的状态逻辑代码( 1.状态⒉.操作状态的方法)
2. 将要复用的状态作为props.render(state)方法的参数，暴露到组件外部
3. 使用props.render()的返回值作为要渲染的内容

```javascript
class Mouse extends React.Component {
  state = {
    x: 0,
    y: 0,
  };
  handleMouseMove = (e) => {
    this.setState({
      x: e.clientX,
      y: e.clientY,
    });
  };
  componentDidMount() {
    window.addEventListener("mousemove", this.handleMouseMove);
  }
  render() {
    return this.props.render(this.state);
  }
}
class App extends React.Component {
  render() {
    return (
      <div>
        <h1>Render Props 模式</h1>
        <Mouse
          render={(mouse) => (
            <p>
              鼠标的位置{mouse.x},{mouse.y}
            </p>
          )}
        />
      </div>
    );
  }
}
ReactDOM.render(<App></App>, document.getElementById("root"));
```

### 组件的复用

```javascript
class App extends React.Component {
  render() {
    return (
      <div>
        <h1>Render Props 模式</h1>
        <Mouse
          render={(mouse) => (
            <p>
              鼠标的位置{mouse.x},{mouse.y}
            </p>
          )}
        />
        <Mouse
          render={(mouse) => {
            return (
              <img
                src={img}
                alt="img"
                style={{
                  position: "absolute",
                  // 减去图片的一半让鼠标在图片的中间
                  top: mouse.y - 130,
                  left: mouse.x - 130,
                }}
              />
            );
          }}
        />
      </div>
    );
  }
}
```

### 使用children代替render属性

思路其实是一样的

==推荐==

```javascript
class Mouse extends React.Component {
  state = {
    x: 0,
    y: 0,
  };
  handleMouseMove = (e) => {
    this.setState({
      x: e.clientX,
      y: e.clientY,
    });
  };
  componentDidMount() {
    window.addEventListener("mousemove", this.handleMouseMove);
  }
  render() {
    return this.props.children(this.state);
  }
}

class App extends React.Component {
  render() {
    return (
      <div>
        <h1>Render Props 模式</h1>
        <Mouse>
          {({ x, y }) => (
            <p>
              鼠标的位置{x},{y}
            </p>
          )}
        </Mouse>
      </div>
    );
  }
}
```

### 优化操作

1. 给 render props 模式添加 props 效验

   ```javascript
   import PropTypes from "prop-types";
   Mouse.propTypes = {
     children: PropTypes.func.isRequired,
   };
   ```

2. 应该在组件卸载时解除 `mousemove` 事件绑定

   ```javascript
   class Mouse extends React.Component {
     componentWillUnmount() {
       window.removeEventListener("mousemove", this.handleMouseMove);
     }
   }
   ```

## 高阶组件

高阶组件也是实现状态逻辑复用,采用包装模式

高阶组件（HOC，Higher-Order Component）是一个==函数==，接收要包装的组件，返回增强后的组件
高阶组件内部创建一个类组件，在这个类组件中提供复用的状态逻辑代码，通过`peops`将复用的状态传递给被包装组件。

### 使用高阶组件

1. 创建一个函数
2. 指定函数参数，参数应该以大写字母开头(作为要渲染的组件)
3. 在函数内部创建一个类组件，提供复用的状态逻辑代码，并返回
4. 在该组件中，渲染参数组件，同时将状态通过 prop 传递给参数组件
5. 调用该高阶组件，传入要增强的组件，通过返回值拿到增强后的组件，并将其渲染到页面中

```javascript
// 创建高阶组件
function withMouse(WrappedComponent) {
  // 该组件提供复用的状态逻辑
  class Mouse extends React.Component {
    // 鼠标状态
    state = {
      x: 0,
      y: 0,
    };
    handleMouseMove = (e) => {
      this.setState({
        x: e.clientX,
        y: e.clientY,
      });
    };
    // 控制鼠标状态的逻辑
    componentDidMount() {
      window.addEventListener("mousemove", this.handleMouseMove);
    }
    componentWillUnmount() {
      window.removeEventListener("mousemove", this.handleMouseMove);
    }
    render() {
      return <WrappedComponent {...this.state} />;
    }
  }
  return Mouse;
}
// 要增强的组件
const Position = (props) => {
  return (
    <p>
      鼠标当前位置：(x: {props.x}, y: {props.y})
    </p>
  );
};
// 增强后的组件
const MousePosition = withMouse(Position);

class App extends React.Component {
  render() {
    return (
      <div>
        <h1>高阶组件</h1>
        <MousePosition />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("root"));
```

### 复用组件

```javascript
const Img = (props) => (
  <img
    src={img}
    alt=" "
    style={{
      position: "absolute",
      top: props.y - 100,
      left: props.x - 100,
    }}
  ></img>
);
// 增强后的组件
const MouseImg = withMouse(Img);
class App extends React.Component {
  render() {
    return (
      <div>
        <h1>高阶组件</h1>
        <MousePosition />
        <MouseImg />
      </div>
    );
  }
}
```

### 设置 displayName

使用高阶组件复用多个组件时，会使多个组件名称相同，如：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755240.png)

因为默认情况下，React 会使用组件名称作为`displayName`,因此我们需要为高阶组件设置`dispalyName` 便于区分不同的组件

```javascript
function withMouse(WrappedComponent) {
  // 设置displayName
  Mouse.displayName = `${getDisplayName(WrappedComponent)}`;
  return Mouse;
}
// 设置displayName
function getDisplayName(WrappedComponent) {
  return WrappedComponent.displayName || WrappedComponent.name || "Component";
}
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070755678.png)

### 传递props

在高阶组件中存在`props`丢失的问题, 在调用`MousePosition`组件时传入`props.a`, 在`Position`中是无法获取到`props.a`的

因为高阶组件没有往下传递`props`,只传递了`state`

```javascript
const Position = (props) => {
  return (
    <p>
      鼠标当前位置：(x: {props.x}, y: {props.y})
    </p>
  );
};
// 增强后的组件
const MousePosition = withMouse(Position);
class App extends React.Component {
  render() {
    return (
      <div>
        <h1>高阶组件</h1>
        <MousePosition a="1"/>
      </div>
    );
  }
}
```

解决: 渲染`*WrappedComponent*`时,将`state`和`this.props`一起传递给组件

```javascript
// 创建高阶组件
function withMouse(WrappedComponent) {
  // 该组件提供复用的状态逻辑
  class Mouse extends React.Component {
    // 鼠标状态
    state = {
      x: 0,
      y: 0,
    };
    handleMouseMove = (e) => {
      this.setState({
        x: e.clientX,
        y: e.clientY,
      });
    };
    // 控制鼠标状态的逻辑
    componentDidMount() {
      window.addEventListener("mousemove", this.handleMouseMove);
    }
    componentWillUnmount() {
      window.removeEventListener("mousemove", this.handleMouseMove);
    }
    render() {
      return <WrappedComponent {...this.state} {...this.props} />;
    }
  }
  // 设置displayName
  Mouse.displayName = `${getDisplayName(WrappedComponent)}`;
  return Mouse;
}
```

