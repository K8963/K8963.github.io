---
title: TypeScript之Flow
date: 2022-03-03 15:10:00
comments: false
author: 8963
tags:
  - TypeScript
categories:
  - 前端
---

# 类型系统

- 强类型、弱类型（类型安全）
- 静态类型、动态类型（类型检查）

## 强类型，弱类型

强类型语言层面限制函数的实参类信息必须与形参类型相同

强类型不允许随意的隐式类型转换，而弱类型是允许的

## 静态类型、动态类型

静态类型，变量在声明时类型就是明确的，且不允许改变

动态类型，变量在运行阶段才明确其类型，且随时可以改变，动态类型语言中变量时没有类型的，变量中存放的值才是有类型的

![image-20220302205518630](F:\8963repository\img\image-20220302205518630.png)



# Flow

JavaScript类型检查工具，使用类型注解来检查类型，flow不需要对每一个变量都添加类型注解，可以根据需求使用

可以通过flow官方的工具去除编码时的类型注解![image-20220302210621347](F:\8963repository\img\image-20220302210621347.png)

## 使用flow

下载

```
yarn init -y
yarn add flow-bin --dev
```

使用对需要进行类型检查的文件前需要添加

```
// @flow
```

关闭vscode的语法检查

![image-20220302211732412](F:\8963repository\img\image-20220302211732412.png)



使用

```
yarn flow init
```

创建flow的配置文件

编写代码使用flow检查

![image-20220302212232279](F:\8963repository\img\image-20220302212232279.png)

第一次使用时需要在后台启动flow的服务，可以使用`flow stop`来停掉flow的服务

## 移除flow的类型注解

安装工具

```
yarn add flow-remove-types --dev
```

- 使用flow工具

```
yarn flow remove-types 代码目录 -d 输出目录
```

![image-20220302213049870](F:\8963repository\img\image-20220302213049870.png)

- 使用babel，通过编译移除类型注解

```
yarn add @babel/core @babel/cli @babel/preset-flow --dev
```

@babel/core  - babel核心模块

@babel/cli  - cli命令行工具

@babel/preset-flow --dev - 转换flow类型注解工具

添加编辑配置文件`.babelrc`

```
{
  "presets": ["@babel/preset-flow"]
}
```

使用

```
yarn babel 代码目录 -d 输出目录
```

## Flow 开发工具插件

https://flow.org/en/docs/editors/ 官方支持的各开发工具的插件

![image-20220303140738069](F:\8963repository\img\image-20220303140738069.png)

## Flow 语法

### 类型推断

```javascript
// @flow
function square(n) {
  return n * n
}
square('100')

```

### 类型注解

推荐尽可能的使用类型注解

声明变量时

```javascript
let x: 类型 = 特定类型数据
let x: number = 1
```

函数返回值的类型注解

```javascript
function foo():number{}
// 如果没有返回值,需要声明为 void
func foo():void{}
```

### 原始类型

- string

- number(数字,NaN,Infinity)

- boolean

- null

- undefined(此类型需要标记为 void)

  ```
  let x: void = undefined
  ```

- symbol

### 数组类型

方式1: 需要指定数组的泛型,数组元素是什么类型的数据

```javascript
const arr: Array<number>
```

方式2: 

```javascript
const arr2:number[]
```

指定数组长度和类型(元组)

```javascript
const foo: [string,number] = ['abc',100]
```

### 对象类型

指定对象的属性名和类型

```javascript
const obj: { foo:string, bar:number} = { foo:'abc', bar:100 } 
```

可选属性,在属性名后面添加一个问号`?`

```javascript
const obj: { foo?:string, bar:number} = { bar:100 } 
```

键值对限制,`[键的类型]:值的类型`

```javascript
const obj:{ [string]:string } = {}
obj.foo = 'abc'
```

### 函数类型

参数限制,返回值限制

```javascript
function foo(a:string,b:number):void{}
```

限制存放函数的变量

```javascript
function foo(callback:(string,number) => void){
	callback('abc',100)
}
foo(function(str,n){})
```

### 特殊类型

字面量类型

```javascript
// a 只能存放 'foo' 这个值
const a:'foo' = 'foo'
// type 只能是一下三种值中的一个
const type: 'success' | 'warning' | 'danger' = 'success'
```

联合类型

```javascript
const b: string|number = 'abc' // 100
```

maybe类型, 可能是某种类型, 添加一个问号`?`

```javascript
const c: ?number = undefined
// 以上等同于
const c: number | null | void = undefined
```

### 任意类型

mixed 与 any

```javascript
function fooM( val: mixed ){}
function fooA( val: any ){}
```

差别: any是弱类型,mixed是强类型

mixed没有明确是哪种类型之前,不可以随意使用

```javascript
// 会报错
function fooM(val: mixed){
	val.substr(1)
}
// 不会报错
function fooM(val: mixed){
	if(typeof val === 'string'){
		val.substr(1)
	}
}
```

any则不需要进行手动类型判断就可以使用



[Flow官方文档 - 所有类型](https://flow.org/en/docs/types/)

[第三方类型整理](https://www.saltycrane.com/cheat-sheets/flow-type/latest/)















