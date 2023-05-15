---
title:Vuex核心概念总结
date:2020-11-13 17:22:30
comments:false
author:8963
tags:
  - vuex
  - vue
categories:
  - 前端
---

# Vuex核心概念总结

```javascript
// store.js
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    count: 0,
  },
  mutations: {
    add(state) {
      state.count++;
    },
  },
  actions: {
    addAsync(context) {
      setTimeout(() => {
        context.commit("add");
      }, 1000);
    },
  },
  getters: {
    showNum: (state) => {
      return "当前【" + state.count + "】";
    },
  },
});
```

### State

个人理解：如果将 Store 比作一件仓库，state 就是货物仓，将所有需要存储在 vuex 中的数据存在此处。

在组件中，使用数据（搬运货物）方式：

```javascript
//	第一种方式:直接调用
this.$store.state.全局数据名称
//	第二种方式:计算属性(mapState)
import {mapState} from 'vuex'
  computed：{
    ...mapState(['全局属性'])
  }
```

```javascript
// 在某个组件中，使用上例(store.js)
<template>
	<div>
  	//	（此处可以省略 this ）
  	{{this.$store.state.count}}
  </div>
</template>
```

```javascript
//某组件中
<template>
  <div>
  	{{count}}
  </div>
</template>
<script>
  // 1、导入 mapState 函数
  import {mapState} from 'vuex'
  // 2、通过导入的 mapState 函数，将当前组件的需要的全局数据，映射为当前组建的computed计算属性
  computed：{
    ...mapState({'count'})
  }
</script>
```

> `“...”` 对象展开运算符

### Getter

个人理解：Getter 用于对 Store 中的数据进行加工处理形成的新数据，如仓库对货物进行包装

使用：

```javascript
// 第一种方式：直接调用
this.$store.getters.名称
// 第二种方式：计算属性
import { mapGetters } from "vuex";
  computed: {
    ...mapGetters(["自定义getter"]),
  },
// 使用：<h3>Getter:{{ showNum }}</h3>
```

### Mutations

个人理解：Mutation 用于变更 Store 中的数据，如仓库搬运工，只有他们才有权搬运货运

在 Store.js 中定义 mutations

```javascript
// 组件中触发Mutation
  methods: {
    函数名() {
      this.$store.commit("add"，可选参数);
    },
  },
```

### Action

个人理解：可以使用异步操作的 mutation 搬运工

在 Store.js 中定义 action，触发 action

```javascript
// 第一种：直接调用
this.$store.dispatch('自定义action')
// 第二种：mapAction
// 在组件中，按需导入 mapAction 函数
import { mapActions } from "vuex";
// 将指定函数的 actions 函数映射为当前组件的 methods 函数
  methods: {
    ...mapActions(["自定义action"]),
    函数名() {
      this.自定义action();
    },
  },
```

### Module

个人理解：模块化管理 vuex 数据、操作，大仓库中分小仓库。每个模块拥有自己的 state、mutation、action、getter、甚至是嵌套子模块。

```javascript
// 模块内部的数据,参数说明
const moduleA = {
  state:() => ({
  	count:0
	}),
  mutations: {
    // moduleA模块内部的state
    add(state) {
      state.count++
    },
  },
  actions: {
    //moduleA模块内部的state,commit,全局模块的state
    addAsync({state，commit，rootState}) {
      setTimeout(() => {
        context.commit("add")
      }, 1000)
    }
  },
  getters: {
    // moduleA模块内部的state
    showNum（state, getters, rootState）{
      return '当前【' + state.count + '】'
    }
  }
}
```

模块具体使用后续再详解。