---
title: Flex布局
date: 2020-09-13 15:18:39
comments: false 
tags:
  - CSS
categories:
  - 前端
---

css布局之flex

<!-- more -->

来源：[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)

## 容器属性

- flex-direction

  决定主轴的方向

  ![w09vKe.jpg](https://s1.ax1x.com/2020/09/13/w09vKe.jpg)

- flex-wrap

  定义换行

  ```css
  .box{
    flex-wrap: nowrap | wrap | wrap-reverse;
  }
  <!-- 
  nowarp：默认不换行
  wrap：（123456789）第一行在上方
  wrap-reverse：（912345678）第一行在下方
  -->
  ```

- flex-flow

  `flex-direction`属性和`flex-wrap`属性的简写形式，默认值为`row nowrap`。

  ```css
  .box {
      // flex-flow: <flex-direction> || <flex-wrap>;
      flex-flow: row wrap;
  }
  ```

- justify-content

  主轴对齐方式
  
  ![w09zbd.jpg](https://s1.ax1x.com/2020/09/13/w09zbd.jpg)

- align-items

  交叉轴对齐方式

  ![](https://s1.ax1x.com/2020/09/13/w09xDH.jpg)

- align-content

  多根轴线的对齐方式。
  ![](https://s1.ax1x.com/2020/09/13/w09OgO.jpg)
## 项目属性

- order

  定义排列顺序，数值越小越靠前，默认为0

- flex-grow

  定义项目放大比例，默认为0

  ![](https://s1.ax1x.com/2020/09/13/w09XvD.jpg)

- flex-shrink

  定义项目放大比例

  ![](https://s1.ax1x.com/2020/09/13/w0CpVA.jpg)

- flex-basis

  定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为`auto`，即项目的本来大小。

  它可以设为跟`width`或`height`属性一样的值（比如350px），则项目将占据固定空间。

- flex

  是`flex-grow`, `flex-shrink` 和 `flex-basis`的简写，默认值为`0 1 auto`。后两个属性可选。

  ```css
  .item {
    // flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]
    flex:0 1 auto;
    // 放大比例0 ; 缩小比例1 ; 占据主轴空间1
  }
  ```

- align-self

  允许单个项目与其他项目不一致，可覆盖`align-items`属性。默认值为auto

  ```css
  .item {
    align-self: auto | flex-start | flex-end | center | baseline | stretch;
  }
  ```