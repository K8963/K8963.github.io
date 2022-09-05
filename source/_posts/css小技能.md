---
title: CSS 小技能
date: 2021-03-10 12:10:00
comments: false
author: 8963
tags:
  - CSS
categories:
  - 前端
---

目前整理整合：背景图片铺满和模糊、滚动条、四周阴影、旋转

<!-- more -->

# 背景图片铺满和模糊

背景图片不变形铺满容器且不变形

```html
<div class="bg">
  <div class="content">Hi!</div>
</div>
```

css 样式

```css
* {
  padding: 0;
  margin: 0;
}
html,
body {
  width: 100%;
  height: 100%;
}
.bg {
  width: 100%;
  height: 100%;
  background: url(../img/bg.jpg);
  /* 背景图片居中 */
  background-position: center center;
  /* 背景图片铺满不变形 */
  background-size: cover;
}
/* 被选元素的内容后面插入内容,模糊效果 */
.bg::after {
  /* 显示内容 */
  content: "";
  width: 100%;
  height: 100%;
  position: absolute;
  /* 继承 */
  background: inherit;
  /* 模糊程度 */
  filter: blur(2px);
  /* 元素的堆叠顺序 */
  z-index: 1;
}
.content {
  /* 字体及背景样式 */
  width: 50px;
  height: 80px;
  color: rgb(0, 0, 0);
  font-size: 30px;
  font-weight: bold;
  text-align: center;
  line-height: 80px;
  background-color: #d5e8f6;
  border-left: 1px solid #000;
  /* 居中 */
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  /* 元素的堆叠顺序 */
  z-index: 2;
}
```

# 滚动条

```css
.content {
  /* 多余内容以滚动条形式显示 */
  overflow: auto;
  /* 显示y轴滚动条 */
  overflow-y: scroll;
}
/* 修改滚动条样式 */
.content::-webkit-scrollbar {
  width: 4px;
}
.content::-webkit-scrollbar-thumb {
  border-radius: 10px;
  -webkit-box-shadow: inset 0 0 5px rgba(41, 39, 39, 0.2);
  background: rgba(255, 255, 255, 0.3);
}
.content::-webkit-scrollbar-track {
  -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  border-radius: 0;
  background: rgba(34, 34, 34, 0.1);
}
```

滚动条属性

> ::-webkit-scrollbar 滚动条整体部分，可以设置宽度啥的
> ::-webkit-scrollbar-button 滚动条两端的按钮
> ::-webkit-scrollbar-track 外层轨道
> ::-webkit-scrollbar-track-piece 内层滚动槽
> ::-webkit-scrollbar-thumb 滚动的滑块
> ::-webkit-scrollbar-corner 边角
> ::-webkit-resizer 定义右下角拖动块的样式

[参考链接](https://segmentfault.com/a/1190000012800450)

# 四周阴影

外阴影

```css
/* 阴影颜色 x轴 y轴 模糊半径 扩展半径 */
box-shadow: darkgrey 0px 0px 8px 3px;
```

内阴影

```css
/* 阴影颜色 x轴 y轴 模糊半径 扩展半径 内阴影*/
box-shadow: darkgrey 0px 0px 8px 3px inset;
```

# 旋转

模拟方向盘旋转

html、js

```html
<img id="steer_img" src="../img/方向盘.png"></img>
  <script>
    function changeSteer(value){
      document.getElementById("steer_img").style.transform = "rotate(" + value + "deg)";
    }
    changeSteer(-90)
  </script>
```

css

```css
#steer_img {
  transform: rotate(90deg);
  transition: all 1s;
}
```
