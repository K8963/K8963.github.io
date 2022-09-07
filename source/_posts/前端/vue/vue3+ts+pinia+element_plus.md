---
title: vue3+ts+pinia+element_plus
date: 2022-05-01 12:59:00
comments: false
author: 8963
tags:
  - vue3
  - pinia
  - TypeScript
  - element_plus
categories:
  - 前端
---

vue 生命周期、v-if 和 v-show 的区别、computed 和 watch 的区别、v-for 中 key 的作用、组件传值

<!-- more -->

# 创建项目

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070804686.png)

# 项目初始化

> 目录结构
> -   public
> -   src
>     -   api
>     -   assets
>     -   components
>     -   config
>     -   router
>     -   store
>     -   styles
>     -   views
>     -   App.vue
>     -   env.d.ts
>     -   main.ts
> -   .env
> -   .env.development
> -   .env.production
> -   index.html
> -   package.json
> -   tsconfig.json
> -   tsconfig.node.json
> -   vite.config.ts

## 定义别名

`vite.config.ts`

```ts
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  alias: {
    '@': path.resolve(__dirname, 'src'),
  },
})
```

# element-plus

```
npm i element-plus --save
```

`main.ts`

```
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
const app = createApp(App)

app.use(ElementPlus)
```

# router

```
npm i vue-router@next -S
```

`routers/index.ts`

```ts
import { createRouter, createWebHashHistory } from 'vue-router'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [{ path: '/', component: () => import('views/home.vue') }],
})

export default router
```

引入，`main.js`

```
import router from "@/router";
createApp(App).use(router).mount("#app");
```

## 路由模块化

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070804391.png)

# axios

axios、进度条、序列化

```
npm i axios nprogress qs
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070804623.png)

`index.ts`

```typescript
import axios, {
  AxiosInstance,
  AxiosError,
  AxiosRequestConfig,
  AxiosResponse,
} from 'axios'
import { ElMessage } from 'element-plus'

import {
  showFullScreenLoading,
  tryHideFullScreenLoading,
} from '@/config/serviceLoading'
import { AxiosCanceler } from './utils/axiosCancel'
import { checkStatus } from './utils/checkStatus'

import { ResultData } from './interface'
import { ResultEnum } from './enums/httpEnum'

const axiosCanceler = new AxiosCanceler()

const config = {
  // 默认地址
  baseURL: import.meta.env.VITE_API_URL as string,
  // 设置超时时间（10s）
  timeout: ResultEnum.TIMEOUT as number,
  // 跨域时候允许携带凭证
  // withCredentials: true,
}

class RequestHttp {
  service: AxiosInstance
  public constructor(config: AxiosRequestConfig) {
    // 实例化axios
    this.service = axios.create(config)

    /**
     * @description 请求拦截器
     * 客户端发送请求 -> [请求拦截器] -> 服务器
     * token校验(JWT) : 接受服务器返回的token,存储到vuex/本地储存当中
     */
    this.service.interceptors.request.use(
      (config: AxiosRequestConfig) => {
        // * 将当前请求添加到 pending 中
        axiosCanceler.addPending(config)
        showFullScreenLoading()
        // const token: string = globalStore.token
        const token: string = ''
        return { ...config, headers: { Authorization: token } }
      },
      (error: AxiosError) => {
        Promise.reject(error)
      }
    )

    /**
     * @description 响应拦截器
     *  服务器换返回信息 -> [拦截统一处理] -> 客户端JS获取到信息
     */
    this.service.interceptors.response.use(
      (response: AxiosResponse) => {
        const { data, config } = response
        // * 在请求结束后，移除本次请求
        axiosCanceler.removePending(config)
        tryHideFullScreenLoading()

        // globalStore.setToken('')
        // router.replace({
        //   path: '/login',
        // })

        // 请求失败
        if (data.code && data.code !== ResultEnum.CODE_SUCCESS) {
          ElMessage.error(data.msg)
          return Promise.reject(data)
        } else {
          ElMessage({
            type: 'success',
            message: response.data.msg,
          })
        }
        // * 成功请求
        return data
      },
      async (error: AxiosError) => {
        const { response } = error
        tryHideFullScreenLoading()
        // 根据响应的错误状态码，做不同的处理
        if (response) return checkStatus(response.status)
        // 服务器结果都没有返回(可能服务器错误可能客户端断网)，断网处理:可以跳转到断网页面
        // if (!window.navigator.onLine) return router.replace({ path: '/500' })
        return Promise.reject(error)
      }
    )
  }

  // * 常用请求方法封装
  get<T>(url: string, params?: object, _object = {}): Promise<ResultData<T>> {
    return this.service.get(url, { params, ..._object })
  }
  post<T>(url: string, params?: object, _object = {}): Promise<ResultData<T>> {
    return this.service.post(url, params, _object)
  }
  put<T>(url: string, params?: object, _object = {}): Promise<ResultData<T>> {
    return this.service.put(url, params, _object)
  }
  delete<T>(url: string, params?: any, _object = {}): Promise<ResultData<T>> {
    return this.service.delete(url, { params, ..._object })
  }
}

export default new RequestHttp(config)
```

实际参照`template\vue3+ts+pinia+element_plus`

# pinia

pinai、pinai持久化

```
npm i pinia pinia-plugin-persist
```

`config\piniaPersist.ts`

```typescript
import { PersistOptions } from 'pinia-plugin-persist'

// pinia持久化参数配置
const piniaPersistConfig = (key: string) => {
  const persist: PersistOptions = {
    enabled: true,
    strategies: [
      {
        key,
        storage: localStorage,
      },
    ],
  }
  return persist
}

export default piniaPersistConfig
```

`store\index.ts`

```typescript
import { defineStore } from 'pinia'
import { createPinia } from 'pinia'
import piniaPersist from 'pinia-plugin-persist'
import piniaPersistConfig from '@/config/piniaPersist'

// defineStore 调用后返回一个函数，调用该函数获得 Store 实体
export const GlobalStore = defineStore({
  // id: 必须的，在所有 Store 中唯一
  id: 'GlobalState',
  // state: 返回对象的函数
  state: () => ({
    // Token
    token: '',
    // userInfo
    userInfo: '',
  }),
  getters: {},
  actions: {
    // set token
    setToken(token: string) {
      this.token = token
    },
    // set userInfo
    setUserInfo(userInfo: any) {
      this.userInfo = userInfo
    },
  },
  persist: piniaPersistConfig('GlobalState'),
})

// piniaPersist(持久化)
const pinia = createPinia()
pinia.use(piniaPersist)

export default pinia
```

# sass

```
npm i sass -D
```

`styles`目录保存各种样式

`index.scss`作为出口组织这些样式，同时编写一些全局样式

最后在`main.js`导入

```
import "styles/index.scss";
```

## 主题切换

使用scss

定义主题变量

`src\styles\theme\theme.scss`

```scss
$themes: (
  // 日间默认 如 font_color1，font_color2 一套主题设置两种颜色，项目需要集中颜色就定义这个主题下有多少颜色

  light: (font_color1: rgb(196, 193, 193),
    font_color2: rgb(110, 109, 109),
    background_color1: rgb(255, 0, 21),
    background_color2: rgb(87, 87, 226),
    border_color1: rgb(231, 181, 181),
    border_color2: rgb(9, 255, 0),
    content_color1:rgb(0, 0, 0),
    content_color2:rgb(255, 255, 250),
  ),

  // 夜间暗黑
  dark: (font_color1: rgb(226, 222, 222),
    font_color2: rgb(255, 255, 255),
    background_color1: rgb(87, 87, 226),
    background_color2: rgb(255, 0, 21),
    border_color1: rgb(9, 255, 0),
    border_color2: rgb(231, 181, 181),
    content_color1:rgb(255, 255, 250),
    content_color2:rgb(0, 0, 0),
  )
);
```

scss处理变量函数`src\styles\theme\handle.scss`

```scss
@import "./theme.scss"; // 引入上面定义的themes.scss 日间和夜间主题

//遍历主题map

@mixin themeify {
  @each $theme-name,
  $theme-map in $themes {
    $theme-map: $theme-map !global;
    //这步是判断html的 自定义属性 data-theme的值  #{}是sass的插值表达式
    //& sass嵌套里的父容器标识   @content是混合器插槽，像vue的插槽一样
    [admin-theme="#{$theme-name}"] & {
      @content;
    }
  }
}

//声明一个根据Key获取颜色的function
@function themed($key) {
  @return map-get($theme-map, $key);
}

//获取背景颜色
@mixin background_color($color) {
  @include themeify {
    background-color: themed($color);
  }
}

//获取字体颜色
@mixin font_color($color) {
  @include themeify {
    color: themed($color);
  }
}

//获取边框颜色
@mixin border_color($color) {
  @include themeify {
    border-color: themed($color);
  }
}

// 获取内容容器的颜色、
@mixin content_color($color) {
  @include themeify {
    // 内容的背景色
    background-color: themed($color);
    // 还可以接着写代码、 比如透明度什么的
  }
}
```

`vite.config.ts`

```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },
  plugins: [vue()],
  css: {
    //css预处理
    preprocessorOptions: {
      scss: {
        additionalData: '@import "@/styles/theme/handle";',
      },
    },
  },
})
```

使用

header组件，切换按钮

```vue
<template>
  <div>
    <el-header>
      <button @click="toggleTheme(1)">默认主题</button>
      <button @click="toggleTheme(0)">暗黑主题</button>
    </el-header>
    <router-view />
  </div>
</template>

<script lang="ts" setup>

const toggleTheme = (index: number) => {
  window.document.documentElement.setAttribute(
    'admin-theme',
    index ? 'dark' : 'light'
  )
}
</script>

<style lang="scss" scoped>
@import './style/main.scss';
</style>
```

页面使用：

```vue
<template>
  <div>
    <p>这里是页面</p>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  setup() {
    return {}
  },
})
</script>

<style lang="scss" scoped>
// 举个例子 P标签 文字颜色 边框颜色 和背景颜色
p {
  @include font_color('font_color1');
  @include border_color('border_color1');
  @include content_color('content_color1');
}
</style>
```

效果

# prettierrc

```javascript
// @see: https://www.prettier.cn
module.exports = {

  // 超过最大值换行

  printWidth: 130,

  // 缩进字节数

  tabWidth: 2,

  // 使用制表符而不是空格缩进行

  useTabs: true,

  // 结尾不用分号(true有，false没有)

  semi: false,

  // 使用单引号(true单双引号，false双引号)

  singleQuote: false,

  // 更改引用对象属性的时间 可选值"<as-needed|consistent|preserve>"

  quoteProps: 'as-needed',

  // 在对象，数组括号与文字之间加空格 "{ foo: bar }"

  bracketSpacing: true,

  // 多行时尽可能打印尾随逗号。（例如，单行数组永远不会出现逗号结尾。） 可选值"<none|es5|all>"，默认none

  trailingComma: 'none',

  // 在JSX中使用单引号而不是双引号

  jsxSingleQuote: false,

  //  (x) => {} 箭头函数参数只有一个时是否要有小括号。avoid：省略括号 ,always：不省略括号

  arrowParens: 'avoid',

  // 如果文件顶部已经有一个 doclock，这个选项将新建一行注释，并打上@format标记。

  insertPragma: false,

  // 指定要使用的解析器，不需要写文件开头的 @prettier

  requirePragma: false,

  // 默认值。因为使用了一些折行敏感型的渲染器（如GitHub comment）而按照markdown文本样式进行折行

  proseWrap: 'preserve',

  // 在html中空格是否是敏感的 "css" - 遵守CSS显示属性的默认值， "strict" - 空格被认为是敏感的 ，"ignore" - 空格被认为是不敏感的

  htmlWhitespaceSensitivity: 'css',

  // 换行符使用 lf 结尾是 可选值"<auto|lf|crlf|cr>"

  endOfLine: 'auto',

  // 这两个选项可用于格式化以给定字符偏移量（分别包括和不包括）开始和结束的代码

  rangeStart: 0,

  rangeEnd: Infinity,

  // Vue文件脚本和样式标签缩进

  vueIndentScriptAndStyle: false,

}
```

# 参考

[https://juejin.cn/post/6926822933721513998#heading-5](https://juejin.cn/post/6926822933721513998#heading-5)