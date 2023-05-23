---
title: Vue2框架问题汇总
date: 2021-05-11 12:59:00
comments: false
author: 8963
tags:
  - vue
categories:
  - 前端
---

vue 生命周期、v-if 和 v-show 的区别、computed 和 watch 的区别、v-for 中 key 的作用、组件传值

<!-- more -->

# 生命周期

总共分为 8 个阶段,创建前\后,更新前\后,销毁前\后

> 创建前\后,beforeCreate/Created
> 在 beforeCreate 阶段,vue 实例的挂载元素 el 和数据对象 data 都为 undefined,还未进行初始化
> 在 Created 阶段,vue 实例数据对象 data 有了,el 为 undefiled,还为初始化

> 载入前/后：beforeMount,mounted
> 在 beforeMount 阶段，vue 实例的$el 和 data 都初始化了，但还是挂载之前为虚拟的 dom 节点，data.message 还未替换。
> 在 mounted 阶段，vue 实例挂载完成，data.message 成功渲染。

> 更新前/后：beforeUpdate.undated
> 当 data 变化时，会触发 beforeUpdate 和 updated 方法

> 销毁前/后：beforeDestroy,Destroyed
> 在执行 destroy 方法后，对 data 的改变不会再触发周期函数，说明此时 vue 实例已经解除了事件监听以及和 dom 的绑定，但是 dom 结构依然存在

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070802609.png)

# v-if 和 v-show 的区别

- v-if 对于元素的显示和隐藏通过操作 dom 节点的创建和销毁来实现
- v-show 无论元素显示或是隐藏 dom 节点都会被创建,但是显示和隐藏通过 css 的属性 display 进行切换.

v-if 的消耗会大于 v-show

# computed 和 watch 的区别

**计算属性 computed**

- 支持缓存,只有依赖数据发生改变时才会重新计算
- 不支持异步，当 computed 内有异步操作时无效，无法监听数据的变化
- computed 属性会默认走缓存,计算属性是基于他们的响应式依赖进行缓存的
- 如果计算属性的值是函数会执行 get 方法,属性值就是函数的返回值；在 computed 中属性都有 set 和 get 方法,当数据发生改变时执行 set 方法.

**监听属性 watch**

- 不支持缓存,当数据发生变化时,会直接执行相应的操作

- 支持异步

- 监听的函数接收两个参数,一个是新值,一个是之前的值

- 监听数据必须是 data 中声明的值,或者是父组件 props 传过来的数据

- 当数据发生变化时,会触发其他操作

  > immediate：组件加载立即触发回调函数执行

  > deep: deep 的意思就是深入观察，监听器会一层层的往下遍历，给对象的所有属性都加上这个监听器，但是这样性能开销就会非常大了，任何修改 obj 里面任何一个属性都会触发这个监听器里的 handler

```javascript
  watch: {
    obj: {
      handler(newName, oldName) {
        this.fullName = newName + ' ' + this.lastName;
      },
      immediate: true,
      deep: true
    }
  }
```

优化:

> 可以使用字符串的形式监听,这样 Vue.js 会一层一层解析下去，直到遇到属性 a，然后才给 a 设置监听函数。

```javascript
  watch: {
    'obj.a': {
      handler(newName, oldName) {
        this.fullName = newName + ' ' + this.lastName;
      },
      immediate: true,
      deep: true
    }
  }
```

# v-for 中 key 的作用

为了给 Vue 一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 key 属性。key 属性的类型只能为 string 或者 number 类型。
key 的特殊属性主要用在 Vue 的虚拟 DOM 算法，在新旧 nodes 对比时辨识 VNodes。

# 双向数据绑定的原理

vue.js 是采用数据劫持结合发布者-订阅者模式的方式,通过 Object.defineProperty()来劫持各个属性的 setter,getter,在数据变动时发布消息给订阅者,触发相应的监听回调.

> 1.需要对 observe 的数据对象进行递归遍历,包括子属性对象的属性都加上 setter 和 getter,那么给这个对象的某个值赋值,就会触发 setter,那么就可以监听到数据变化

> 2.compile 解析模板指令,将模板中的变量替换成数据,然后初始化渲染页面视图,并将每个指令对应的节点绑定更新函数,添加监听数据的订阅者,一旦数据有变动,收到通知更新视图.

> 3.Watcher 订阅者是 Observer 和 Compile 之间通信的桥梁，主要做的事情是:
> ① 在自身实例化时往属性订阅器(dep)里面添加自己
> ② 自身必须有一个 update()方法
> ③ 待属性变动 dep.notice()通知时，能调用自身的 update()方法，并触发 Compile 中绑定的回调，则功成身退。

> MVVM 作为数据绑定的入口，整合 Observer、Compile 和 Watcher 三者，通过 Observer 来监听自己的 model 数据变化，通过 Compile 来解析编译模板指令，最终利用 Watcher 搭起 Observer 和 Compile 之间的通信桥梁，达到数据变化 -> 视图更新；视图交互变化(input) -> 数据 model 变更的双向绑定效果。

# 组件传值

## 父传子

通过 props 传递

```
父组件： <child value = '传递的数据' />

子组件: props['value'],接收数据,接受之后使用和data中定义数据使用方式一样
```

## 子传父

在父组件中绑定一个自定义事件,子组件通过$emit()触发该事件并传值

```
父组件： <child @receive = 'receive' />

子组件: this.$emit('receive','传递的数据')
```

## 兄弟组件

1. 中央通信

   > A. methods :{ 函数{bus.$emit(‘自定义事件名’，数据)} 发送

   > B. created （）{bus.$on(‘A 发送过来的自定义事件名’，函数)} 进行数据接收

2. 通过 vuex
