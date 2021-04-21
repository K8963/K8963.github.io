---
title: html+css+js 菜单及内容切换
date: 2020-10-02 11:50:25
comments: false 
tags:
  - HTML
  - CSS
  - JavaScript
categories:
  - 前端
---

使用  **事务委托**，**数组map方法**  完成原生菜单及内容切换

<!-- more -->

业务需求：点击菜单切换相应内容，菜单样式也做出相应改变

思路：

- 内容的切换首先想到css的display属性，更改 none 和 block 完成内容的显示和隐藏
- 菜单样式的改变使用添加和移除类名的方法

当用户点击某菜单项时，我们要完成两件事：

1. 切换当前点击的菜单项样式为选中，其它项为不选中，即给此项添加类名 `active` ，其它项移除类名 `active`
2. 将菜单项对应的内容显示，其他项隐藏，即给对应内容display属性设置为 block ，其它项为 none。

如果优雅的完成这些呢，首先解决给菜单项绑定点击事件，我首先想到事件委托，即给菜单项的父元素绑定点击，从而通过父元素监听事件。

每一个内容和菜单项都需要通过一个方法发生改变，要么是显示隐藏，要么是添加移除类名，我想到了数组的map方法，让数组中的每个元素都调用函数处理。

整理一下得此：

注意：

此处菜单项绑定的id名和内容项绑定的类名是一样的，因此公用一个数组 `mainList`。

map函数传入的第二个参数对象，作为该执行回调时使用，传递给函数，用作 "this" 的值。

此处将菜单项的id作为参数传入 switchLi 方法中，通过 this 接收，再经过map判断当前菜单项是否为点击的菜单项完成效果改变。

```javascript
// 菜单切换
let navUl = document.getElementById('navUl')
let mainList = ['li1', 'li2', 'li3']

function switchLi(li) {
  let nodeMain = document.getElementsByClassName(li)[0]
  let nodeLi = document.getElementById(li)
  nodeMain.style.display = "none";
  nodeLi.classList.remove('active')
  if (li == this) {
    nodeMain.style.display = "block";
    nodeLi.classList.add('active')
  }
}
navUl.onclick = (e) => {
  mainList.map(switchLi, e.toElement.id)
}
```

