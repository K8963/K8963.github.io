---
title:Echarts 常用总结
date:2021-04-10 12:10:00
comments:false
author:8963
tags:
  - echarts
  - JavaScript
  - 可视化
categories:
  - 前端
---

Echarts 常用：标题、图例、坐标轴、柱状图、饼图等

<!-- more -->

# 标题

```javascript
title: {
  text: '学生生源地来源分布图',
  subtext: '模拟数据',
  // x 设置水平安放位置，默认左对齐，可选值：'center' ¦ 'left' ¦ 'right' ¦ {number}（x坐标，单位px）
  x: 'center',
  / y 设置垂直安放位置，默认全图顶端，可选值：'top' ¦ 'bottom' ¦ 'center' ¦ {number}（y坐标，单位px）
  y: 'top',
  // itemGap设置主副标题纵向间隔，单位px，默认为10，
  itemGap: 30,
  backgroundColor: '#EEE',
  // 主标题文本样式设置
  textStyle: {
    fontSize: 26,
    fontWeight: 'bolder',
    color: '#000080'
  },
  // 副标题文本样式设置
  subtextStyle: {
    fontSize: 18,
    color: '#8B2323'
  }
},
```

# 图例 legend

```javascript
legend: {
  // icon字段控制形状 类型包括 circle，rect ，roundRect，triangle，diamond，pin，arrow，none
  icon: "circle",
  // orient 设置布局方式，默认水平布局，可选值：'horizontal'（水平） ¦ 'vertical'（垂直）
  orient: 'vertical',
  // x 设置水平安放位置，默认全图居中，可选值：'center' ¦ 'left' ¦ 'right' ¦ {number}（x坐标，单位px）
  x: 'left',
  // y 设置垂直安放位置，默认全图顶端，可选值：'top' ¦ 'bottom' ¦ 'center' ¦ {number}（y坐标，单位px）
  y: 'center',
  padding:[0,50,0,0],   //可设定图例[距上方距离，距右方距离，距下方距离，距左方距离]
  itemWidth: 24,   // 设置图例图形的宽
  itemHeight: 18,  // 设置图例图形的高
  textStyle: {
  	color: '#666'  // 图例文字颜色
  },
  // itemGap设置各个item之间的间隔，单位px，默认为10，横向布局时为水平间隔，纵向布局时为纵向间隔
  itemGap: 30,
  backgroundColor: '#eee',  // 设置整个图例区域背景颜色
  data: ['北京','上海','广州','深圳','郑州']
},
```

# 坐标轴

X 轴

```javascript
xAxis: [
  {
    type: "category",
    // type:坐标轴类型。
    /*可选：
     1.'value' 数值轴，适用于连续数据；
     2.'category' 类目轴，适用于离散的类目数据，为该类型时必须通过 data 设置类目数据； 
     3.'time' 时间轴，适用于连续的时序数据，与数值轴相比时间轴带有时间的格式化，在刻度计算上也有所不同，例如会根据跨度的范				围来决定使用月，星期，日还是小时范围的刻度；
     4.'log' 对数轴。适用于对数数据。*/
    //x轴下面的数据
    data: ["上海", "北京"],
    axisTick: {
      show: false, //是否显示网状线 默认为true
      alignWithLabel: true,
    },
    //用于设置x下面的字体
    axisLabel: {
      show: true, //这里的show用于设置是否显示x轴下的字体 默认为true
      interval: 0, //可以设置成 0 强制显示所有标签。如果设置为 1，表示『隔一个标签显示一个标签』，如果值为 2，表示隔两个标签显示一个标签，以此类推。
      textStyle: {
        //textStyle里面写x轴下的字体的样式
        color: "#333",
        fontSize: 13,
      },
    },
    //用于设置x轴线
    axisLine: {
      show: true, //这里的show用于设置是否显示x轴那一条线 默认为true
      lineStyle: {
        //lineStyle里面写x轴那一条线的样式
        color: "#6FC6F3",
        width: 2, //轴线的粗细 我写的是2 最小为0，值为0的时候线隐藏
      },
    },
  },
];
```

Y 轴

```javascript
yAxis: [
  {
    min: 0, //y轴的最小值
    max: 100, //y轴最大值
    interval: 20, //值之间的间隔
    //上面的三个值可以根据自己需求随意设置 不设置时会根据图中的值自动生成相应的值

    type: "value",
    /* type坐标轴类型:[ default: 'value' ]
　　　　可选：1.'value' 数值轴，适用于连续数据。
　　　　2.'category' 类目轴，适用于离散的类目数据，为该类型时必须通过 data 设置类目数据。
       3.'time' 时间轴，适用于连续的时序数据，与数值轴相比时间轴带有时间的格式化，在刻度计算上也有所不同，例如会根据跨度的范围来决定使用月，星期，日还是小时范围的刻度。
       4.'log' 对数轴。适用于对数数据。*/
    splitLine: { show: false }, //去除网状线 默认为true
    //用于设置y轴的字体
    axisLabel: {
      show: true, //这里的show用于设置是否显示y轴下的字体 默认为true
      textStyle: {
        //textStyle里面写y轴下的字体的样式
        color: "#333",
        fontSize: 13,
      },
    },
    //用于设置y轴的轴线
    axisLine: {
      show: true, //这里的show用于设置是否显示y轴那一条线 默认为true
      lineStyle: {
        //lineStyle里面写y轴那一条线的样式
        color: "#6FC6F3",
        width: 2, //轴线的粗细 我写的是2 最小为0，值为0的时候线隐藏
      },
    },
  },
];
```

y 轴显示不全

```javascript
grid: {
    top: '15%',  // 组件离容器上侧的距离,百分比字符串或整型数字
    left: '5%',    // 组件离容器左侧的距离,百分比字符串或整型数字
    right: '5%',
    bottom: '3%',
    containLabel: true //grid 区域是否包含坐标轴的刻度标签，
},
```

# 柱状图

柱体样式

```javascript
series: [{
	name: '销量',
	type: 'bar',
	data: [5, 20, 36, 10, 10, 20],
	barWidth: 15,   //柱状宽度
	itemStyle: {    //柱状颜色和圆角
		color: '#F43368',
		barBorderRadius: [5, 5, 0, 0], // （顺时针左上，右上，右下，左下）
	},
}],
```

# 饼图

饼图颜色

```javascript
series :{
  name:'time',
  type:'pie',
  hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果。
  radius :[68, 90],//饼图的半径，实心圆可以改为[0,90]
  center : ['25%', '57%'],//饼图的中心（圆心）坐标，
  label: {
    normal: {
      show: false,//是否在圆内显示所有分类的名称
      position: 'center',
      color: 'rgba(57, 58, 75, 1)',
      fontSize: 24,
      fontWeight: 'bold',
    },
    emphasis: {
    	show: false, //是否在hover某个分类的时候显示该分类在圆内
    }
  },
  data:[],
  itemStyle: {
    normal:{
      color:function(params) {/定义圆分类的颜色
      //自定义颜色
      var colorList = [
      '#309BFF', '#D9D9D9', 'rgba(250, 204, 20, 1)', 'rgba(217,217,217,1)', '#0025CE', '#5704FF'
      ];
       return colorList[params.dataSIndex]
      }
    }
  }
}
```

标识线及字体颜色

```javascript
labelLine:{
  normal:{
    length:5,  // 改变标示线的长度
    lineStyle: {
    	color: "red"  // 改变标示线的颜色
    }
  },
},
label: {
  normal: {
    textStyle: {
    	color: 'red'  // 改变标示文字的颜色
    }
  }
},

```



# 折线图

折线拐点

```javascript
series: [
  {
    name: "实际",
    data: [620, 732, 941, 834, 1690, 1030, 920],
    type: "line",
    // 设置折线上圆点大小
    symbolSize: 8,
    // 设置拐点为实心圆
    symbol: "circle",
    itemStyle: {
      normal: {
        // 拐点上显示数值
        label: {
          show: true,
        },
        borderColor: "red", // 拐点边框颜色
        lineStyle: {
          width: 5, // 设置线宽
          type: "dotted", //'dotted'虚线 'solid'实线
          // 使用rgba设置折线透明度为0，可以视觉上隐藏折线
          color: "rgba(0,0,0,0)",
        },
      },
    },
  },
];
//	折线颜色
color: ['#00EE00', '#FF9F7F','#FFD700']
```

工具

```javascript
//工具框，可以选择
toolbox: {
  feature: {
    saveAsImage: { } //下载工具
  }
}
```

# visualMap

```
lt（小于，less than），

gt（大于，greater than），

lte（小于等于 less than or equals），

gte（大于等于，greater than or equals）来表达边界
```

https://blog.csdn.net/weixin_57871623/article/details/121207451



https://www.runoob.com/echarts/echarts-visualmap.html
