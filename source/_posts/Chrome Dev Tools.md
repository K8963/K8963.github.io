---
title: Chrome Dev Tools
date: 2021-10-11 12:10:00
comments: false
author: 8963
tags:
  - CSS
categories:
  - 前端
---

Chrome 调试工具 Dev Tools  的使用

<!-- more -->

# Chrome 调试工具

## Tab 介绍

### 基础快捷键

打开 Dev Tools : 快捷键 `F12`

打开命令行菜单：`Ctrl` + `Shift` + `p`

> 比如
>
> 修改 Dev Tools 主题
>
> ![image-20211011130514867](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011130514867.png)
>
> 截屏(screenshot)
>
> ![image-20211011131208571](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011131208571.png)
>
> Dev Tools工具停靠位置(dock)
>
> - Dock to left 
> - Dock to right
> - Dock to Bottom
> - undock 独立窗口

### 常用的Tab

- Elements
- Console
- Source
- Network
- Application

## CSS 调试

### 检查元素 

 快速检查某个元素

![image-20211011131941669](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011131941669.png)

### 查询 DOM 树

快捷键 : `Ctrl` + `F`

查询:

- 文本内容

  ![image-20211011132550845](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011132550845.png)

- css 选择器

  ![image-20211011132546441](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011132546441.png)

- Xpath

  ![image-20211011132541656](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011132541656.png)

> 在 Console 内使用 inspect(element) 方法,快速定位元素位置

## 编辑样式

### 测试伪类

例如:让鼠标永远悬停

![image-20211011133252178](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011133252178.png)

### 修改class

![image-20211011133544908](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011133544908.png)

### 复制样式

![image-20211011133722617](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011133722617.png)

```css
  margin: 0;
  font-family: "PingFang SC",Arial,"Microsoft YaHei",sans-serif;
  -webkit-appearance: none;
  cursor: pointer;
  width: 108px;
  height: 44px;
  line-height: 45px;
  padding: 0;
  background: 0 0;
  background-color: #4e6ef2;
  border-radius: 0 10px 10px 0;
  font-size: 17px;
  color: #fff;
  box-shadow: none;
  font-weight: 400;
  border: none;
  outline: 0;
```

### 样式面板

**Computed**

![image-20211011134046783](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011134046783.png)

**Layout**

![image-20211011134723753](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011134723753.png)

修改查看布局方式

![image-20211011134923489](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011134923489.png)

**Event Listeners**

所有绑定的事件

![image-20211011135029801](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011135029801.png)



## 控制台

快捷键 : `Ctrl` + `Shift` + `J`

$_返回上一条语句的执行结果

\$0 上一个选择器的DOM节点(\$1,\$2...)

`console.time(); ` 返回一段代码的执行时间

![image-20211011212158974](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011212158974.png)

观测变量值

![image-20211011212345823](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011212345823.png)

## JavaScript 调试

 在代码中添加 `debugger` 语句可以在浏览器执行到此处时暂停,可以进行调试.

或者直接在浏览器打断点进行调试

监测变量

![image-20211011212847112](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011212847112.png)



## Network

跳转页面时保留历史请求

![image-20211011213308489](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20211011213308489.png)

`Disable cache` 清除缓存

## Application

最常用的功能就是 : 查看 Cookies,session,localStorage