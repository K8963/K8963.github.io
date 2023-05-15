---
title:Grid布局.md
date:2020-07-23 17:59:00
comments:false
author:8963
tags:
  - CSS
categories:
  - 前端
---

# CSS 布局 - Grid

`Grid` 布局即网格布局，是一种新的 `CSS` 布局模型，比较擅长将一个页面划分为几个主要区域，以及定义这些区域的大小、位置、层次等关系。

## 开启Grid布局

```css
#gridBox {
  display:grid
  /* 或 display:inline-grid */
}
```

这样 `#gridBox` 成为了一个== 网格容器 ==，这个元素的所有直系子元素将成为==网格项目==。

声明 `display：grid` 则该容器是一个块级元素，设置成 `display: inline-grid` 则容器元素为行内元素

# Grid 容器属性

## 列宽 \ 行高

`grid-template-columns` 属性设置列宽,`grid-template-rows` 属性设置行高

属性值:

`px`

设置几列/几行，每列的宽度/高度固定px

`repeat(重复次数, 重复的值)`

 简化重复, 参数repeat(重复次数, 重复的值)

`auto-fill`

自动填充, 列的数量不固定, 只要浏览器能够容纳得下

`fr`

`fr` 单位代表网格容器中可用空间的一等份。

> `grid-template-columns: 200px 1fr 2fr` 
>
> 表示第一个列宽设置为 200px，后面剩余的宽度分为两部分，宽度分别为剩余宽度的 1/3 和 2/3

`minmax()`

两个参数，分别为最小值和最大值, 产生一个长度范围，表示长度就在这个范围之中都可以应用到网格项目中.

> `grid-template-columns: 1fr 1fr minmax(300px, 2fr)` 
>
> 表示第三个列宽最少也是要 300px，但是最大不能大于第一第二列宽的两倍。

`auto`

由浏览器决定长度。

例子：

```css
/* 固定px */
#gridBox {
  display: grid;
  grid-template-columns: 200px 100px 200px;
  grid-template-rows: 50px 50px;
}
/* repeat() - 简化重复 */
#gridBox {
  display: grid;
  grid-template-columns: 200px 100px 200px;
  grid-template-rows: repeat(2,50px);
}
/* auto-fill - 自动填充 */
#gridBox {
  display: grid;
	grid-template-columns: repeat(auto-fill, 200px);
}
/* fr */
#gridBox {
  display: grid;
  grid-template-columns: 200px 1fr 2fr;
}
/* minmax() */
#gridBox {
  display: grid;
  grid-template-columns: 1fr 1fr minmax(300px, 2fr);
}
/* auto 由浏览器决定,实现三列布局 */
#gridBox {
  display: grid;
  grid-template-columns: 100px auto 100px
}
```

## 行间距 \ 列间距

`grid-row-gap` 属性、`grid-column-gap` 属性分别设置行间距和列间距。`grid-gap` 属性是两者的简写形式。

> { grid-row-gap: 10px;grid-column-gap: 20px; }
>
> ===
>
> { grid-gap: 10px 20px; }

## 定义区域

`grid-template-areas` 属性用于定义区域，一个区域由一个或者多个单元格组成

一般与项目属性组合使用 `grid-area` 属性指定项目放在哪一个区域.

```css
.wrapper {
  display: grid;
  grid-template-columns: 120px auto 120px;
  grid-template-areas: ". header header" "sidebar content content";
}
.sidebar {
  grid-area: sidebar;
}
.content {
  grid-area: content;
}

.header {
  grid-area: header;
}
```

> `grid-template-areas: ". header header" "sidebar content content";`
>
> 表示划分出 6 个单元格,并设置每个单元格的内容,  `.`  表示此单元格为空
>
> `grid-area`
>
> 为当前项目指定容器中的位置

## 自动布局算法

`grid-auto-flow` 属性控制着自动布局算法怎样运作，精确指定在网格中被自动布局的元素怎样排列。默认的放置顺序是"先行后列"，即先填满第一行，再开始放入第二行

> grid-auto-flow: row; 默认先行后列
>
> grid-auto-flow: row dense;  尽可能填满表格
>
> grid-auto-flow: column; 先列后行

## 项目内容位置

`justify-items` 属性设置单元格内容的水平位置，`align-items` 属性设置单元格的垂直位置

> 水平位置:左 | 中 | 右 | 拉伸占满单元格的整个宽度（默认值）
>
> justify-items: start | end | center | stretch; 
>
> 垂直位置:上 | 中 | 下 | 拉伸占满单元格的整个宽度（默认值）
>
> align-items: start | end | center | stretch;

## 所有项目位置

`justify-content` 属性是整个内容区域在容器里面的水平位置（左中右），`align-content` 属性是整个内容区域的垂直位置（上中下）。它们都有如下的属性值。

> 水平位置: 
>
> justify-content: start | end | center | stretch | space-around | space-between | space-evenly;  
>
> 垂直位置
>
> align-content: start | end | center | stretch | space-around | space-between | space-evenly; 
>
> - start - 对齐容器的起始边框
> - end - 对齐容器的结束边框
> - center - 容器内部居中
> - space-around - 每个项目两侧的间隔相等。所以，项目之间的间隔比项目与容器边框的间隔大一倍
> - space-between - 项目与项目的间隔相等，项目与容器边框之间没有间隔
> - space-evenly - 项目与项目的间隔相等，项目与容器边框之间也是同样长度的间隔
> - stretch - 项目大小没有指定时，拉伸占据整个网格容器

## 隐式网格 列宽 / 行高

隐式和显式网格：显式网格包含了你在 `grid-template-columns` 和 `grid-template-rows` 属性中定义的行和列。如果你在网格定义之外又放了一些东西，或者因为内容的数量而需要的更多网格轨道的时候，网格将会在隐式网格中创建行和列

假如有多余的网格（也就是上面提到的隐式网格），那么它的行高和列宽可以根据 `grid-auto-columns` 属性和 `grid-auto-rows` 属性设置。它们的写法和`grid-template-columns` 和 `grid-template-rows` 完全相同。

# Grid 项目属性

## 项目的边框

可以指定网格项目所在的四个边框，分别定位在哪根网格线，从而指定项目的位置

- grid-column-start 属性：左边框所在的垂直网格线
- grid-column-end 属性：右边框所在的垂直网格线
- grid-row-start 属性：上边框所在的水平网格线
- grid-row-end 属性：下边框所在的水平网格线

## 定义单个项目

`grid-area` 属性指定项目放在哪一个区域

## 内容位置

`justify-self` 属性设置单元格内容的水平位置（左中右）, `align-self` 属性设置单元格内容的垂直位置（上中下

> justify-self: start | end | center | stretch;  
>
> align-self: start | end | center | stretch;

# Grid布局 与 Flex布局

 **`flex` 布局是一维布局，`Grid` 布局是二维布局**。

`flex` 布局一次只能处理一个维度上的元素布局，一行或者一列。

`Grid` 布局是将容器划分成了“行”和“列”，产生了一个个的网格，我们可以将网格元素放在与这些行和列相关的位置上，从而达到我们布局的目的。

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070814919.png)











