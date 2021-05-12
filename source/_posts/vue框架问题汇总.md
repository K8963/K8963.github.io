---
title: vue框架问题汇总
date: 2021-05-11 12:59:00
comments: false 
tags:
  - vue
categories:
  - 前端
---



- vue生命周期
- v-if 和 v-show 的区别
- computed和watch的区别
- v-for中 key的作用
- 组件传值

<!-- more -->



# 生命周期

总共分为8个阶段,创建前\后,更新前\后,销毁前\后

> 创建前\后,beforeCreate/Created
> 在beforeCreate阶段,vue实例的挂载元素el和数据对象data都为undefined,还未进行初始化
> 在Created阶段,vue实例数据对象data有了,el为undefiled,还为初始化

> 载入前/后：beforeMount,mounted
> 在beforeMount阶段，vue实例的$el和data都初始化了，但还是挂载之前为虚拟的dom节点，data.message还未替换。
> 在mounted阶段，vue实例挂载完成，data.message成功渲染。

> 更新前/后：beforeUpdate.undated
> 当data变化时，会触发beforeUpdate和updated方法

> 销毁前/后：beforeDestroy,Destroyed
> 在执行destroy方法后，对data的改变不会再触发周期函数，说明此时vue实例已经解除了事件监听以及和dom的绑定，但是dom结构依然存在

![](https://upload-images.jianshu.io/upload_images/13119812-5890a846b6efa045.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

# v-if 和 v-show 的区别

 - v-if 对于元素的显示和隐藏通过操作dom节点的创建和销毁来实现
 - v-show 无论元素显示或是隐藏dom节点都会被创建,但是显示和隐藏通过css的属性display进行切换.

v-if的消耗会大于v-show

# computed和watch的区别

**计算属性 computed**
 - 支持缓存,只有依赖数据发生改变时才会重新计算
 - 不支持异步，当computed内有异步操作时无效，无法监听数据的变化
 - computed属性会默认走缓存,计算属性是基于他们的响应式依赖进行缓存的
 - 如果计算属性的值是函数会执行get方法,属性值就是函数的返回值；在computed中属性都有set和get方法,当数据发生改变时执行set方法.

**监听属性 watch**
 - 不支持缓存,当数据发生变化时,会直接执行相应的操作
 - 支持异步
 - 监听的函数接收两个参数,一个是新值,一个是之前的值
 - 监听数据必须是data中声明的值,或者是父组件props传过来的数据
 - 当数据发生变化时,会触发其他操作
    > immediate：组件加载立即触发回调函数执行 

    > deep: deep的意思就是深入观察，监听器会一层层的往下遍历，给对象的所有属性都加上这个监听器，但是这样性能开销就会非常大了，任何修改obj里面任何一个属性都会触发这个监听器里的 handler
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
> 可以使用字符串的形式监听,这样Vue.js会一层一层解析下去，直到遇到属性a，然后才给a设置监听函数。
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
# v-for中 key的作用

为了给Vue一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 key 属性。key属性的类型只能为 string或者number类型。
key 的特殊属性主要用在Vue的虚拟DOM算法，在新旧nodes对比时辨识VNodes。

# 双向数据绑定的原理
vue.js是采用数据劫持结合发布者-订阅者模式的方式,通过Object.defineProperty()来劫持各个属性的setter,getter,在数据变动时发布消息给订阅者,触发相应的监听回调.

> 1.需要对observe的数据对象进行递归遍历,包括子属性对象的属性都加上setter和getter,那么给这个对象的某个值赋值,就会触发setter,那么就可以监听到数据变化

> 2.compile解析模板指令,将模板中的变量替换成数据,然后初始化渲染页面视图,并将每个指令对应的节点绑定更新函数,添加监听数据的订阅者,一旦数据有变动,收到通知更新视图.

> 3.Watcher订阅者是Observer和Compile之间通信的桥梁，主要做的事情是:
>  ①在自身实例化时往属性订阅器(dep)里面添加自己
>  ②自身必须有一个update()方法
>  ③待属性变动dep.notice()通知时，能调用自身的update()方法，并触发Compile中绑定的回调，则功成身退。

> MVVM作为数据绑定的入口，整合Observer、Compile和Watcher三者，通过Observer来监听自己的model数据变化，通过Compile来解析编译模板指令，最终利用Watcher搭起Observer和Compile之间的通信桥梁，达到数据变化 -> 视图更新；视图交互变化(input) -> 数据model变更的双向绑定效果。

# 组件传值

## 父传子
通过props传递
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

    > B. created （）{bus.$on(‘A发送过来的自定义事件名’，函数)} 进行数据接收
2. 通过vuex