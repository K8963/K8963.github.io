---
title: Chrome 调试工具
date: 2021-04-10 12:10:00
comments: false
author: 8963
tags:
  - 开发工具
  - debug
categories:
  - 环境工具
---

Chrome 调试工具的基本使用

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
> ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070902680.png)
>
> 截屏(screenshot)
>
> ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070902833.png)
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

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903709.png)

### 查询 DOM 树

快捷键 : `Ctrl` + `F`

查询:

- 文本内容

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903752.png)

- css 选择器

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903350.png)

- Xpath

  ![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903930.png)

> 在 Console 内使用 inspect(element) 方法,快速定位元素位置

## 编辑样式

### 测试伪类

例如:让鼠标永远悬停

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903492.png)

### 修改class

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903928.png)

### 复制样式

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070909302.png)

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

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903561.png)

**Layout**

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903522.png)

修改查看布局方式

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903306.png)

**Event Listeners**

所有绑定的事件

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903607.png)



## 控制台

快捷键 : `Ctrl` + `Shift` + `J`

$_返回上一条语句的执行结果

\$0 上一个选择器的DOM节点(\$1,\$2...)

`console.time(); ` 返回一段代码的执行时间

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903159.png)

观测变量值

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903169.png)

## JavaScript 调试

 在代码中添加 `debugger` 语句可以在浏览器执行到此处时暂停,可以进行调试.

或者直接在浏览器打断点进行调试

监测变量

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903537.png)



## Network

跳转页面时保留历史请求

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070903586.png)

`Disable cache` 清除缓存

## Application

最常用的功能就是 : 查看 Cookies,session,localStorage