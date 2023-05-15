---
itle:vue路由
date:2022-05-01 12:59:00
comments:false
author:8963
tags:
  - vue3
  - vue路由
categories:
  - 前端
---

vue路由

<!-- more -->

安装依赖

```
npm i vue-router@next -S
```



# 目录结构

```
src
│ # 路由目录
├─router
│   # 路由入口文件
├───index.ts
│   # 路由配置
├───routes.ts
│ # 项目入口文件
├───modules
│ # 路由模块
└─main.ts
```

# 引用路由

```typescript
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: Array<RouteRecordRaw> = [
  // ...
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

export default router
```

`base` 是 History 模式在进行路由切换时的基础路径，默认是 `/` 根目录，如果的项目不是部署在根目录下，而是二级目录、三级目录等多级目录，就必须指定这个 base ，否则路由切换会有问题。

# 路由懒加载

```
const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'home',
    component: () => import('@views/home.vue'),
  },
]
```

起到懒加载配置作用的就是 `component` 接收的值 `() => import('@views/home.vue')` ，其中 `@views/home.vue` 就是路由的组件。

# 路由的渲染

所有路由组件，要在访问后进行渲染，都必须在父级组件里带有 `<router-view />` 标签。

如果站点带有全局公共组件，比如有全站统一的页头、页脚，只有中间区域才是路由，那么可以这样配置：

```vue
<template>
  <!-- 全局页头 -->
  <Header />

  <!-- 路由 -->
  <router-view />

  <!-- 全局页脚 -->
  <Footer />
</template>
```

如果有一部分路由带公共组件，一部分没有，比如大部分页面都需要有侧边栏，但登录页、注册页不需要，就可以这么处理：

```vue
<template>
  <!-- 登录 -->
  <Login v-if="route.name === 'login'" />

  <!-- 注册 -->
  <Register v-else-if="route.name === 'register'" />

  <!-- 带有侧边栏的其他路由 -->
  <div v-else>
    <!-- 固定在左侧的侧边栏 -->
    <Sidebar />

    <!-- 路由 -->
    <router-view />
  </div>
</template>
```

也可以通过 路由元信息来管理这些规则。

# 获取路由信息

Vue 3 用啥都要导入，所以获取当前路由信息的正确用法是先导入路由 API ：

```js
import { useRoute } from 'vue-router'
```

再在 `setup` 里定义一个变量来获取当前路由：

```js
const route = useRoute()
```

如果要在 `<template />` 里使用路由，记得把 `route` 在 `setup` 里 return 出去。

```js
// 获取路由名称
console.log(route.name)

// 获取路由参数
console.log(route.params.id)

// 获取路由记录
const matched = route.matched

// 获取该记录的路由个数
const max = matched.length

// 获取倒数第二个路由（也就是当前路由的父级路由）
const parentRoute = matched[max - 2]
```

# 操作路由

导入

```js
import { useRoute } from 'vue-router'
const route = useRoute()
```

接下来就可以通过定义好的变量 `router` 去操作路由了：

```js
// 跳转首页
router.push({
  name: 'home',
})

// 返回上一页
router.back()
```

# 使用 router-link 

`router-link` 是一个全局组件，可直接在 `<template />` 里直接使用，无需导入，基础的用法在 Vue 2 和 Vue 3 里是一样。

## 基础跳转

最基础的用法就是把它当成一个 `target="_self"` 的 `a` 标签使用，但无需重新刷新页面，因为是路由跳转，它的体验和使用 `router` 去进行路由导航的效果完全一样。

```vue
<template>
  <router-link to="/home">首页</router-link>
</template>
```

等价于 `router` 的 `push`：

```js
router.push({
  name: 'home',
})
```

## 带参数的跳转

使用 `router` 的时候，可以轻松的带上参数去那些有 ID 的内容页、用户资料页、栏目列表页等等。

比如要访问一篇文章 `https://example.com/article/123` ，用 `push` 的写法是：

```js
router.push({
  name: 'article',
  params: {
    id: 123,
  },
})
```

在 `router-link` 里应该：

```js
<template>
  <router-link
    class="link"
    :to="{
      name: 'article',
      params: {
        id: 123,
      },
    }"
  >
    这是文章的标题
  </router-link>
</template>

```

# 路由元信息配置

有时候的项目需要一些个性化配置，比如：

1. 每个路由给予独立的标题；
2. 管理后台的路由，部分页面需要限制一些访问权限；
3. 通过路由来自动生成侧边栏、面包屑；
4. 部分路由的生命周期需要做缓存（ Keep Alive ）;

```typescript
const routes: Array<RouteRecordRaw> = [
  {
    path: '/login',
    name: 'login',
    component: () => import('@views/login.vue'),
    meta: {
      title: '登录',
      isDisableBreadcrumbLink: true,
      isShowBreadcrumb: false,
      addToSidebar: false,
      sidebarIcon: '',
      sidebarIconAlt: '',
      isNoLogin: true,
    },
  },
]
```

主要功能

| 字段                    | 类型    | 含义                                                         |
| :---------------------- | :------ | :----------------------------------------------------------- |
| title                   | string  | 用于在渲染的时候配置浏览器标题；                             |
| isDisableBreadcrumbLink | boolean | 是否禁用面包屑链接（对一些没有内容的路由可以屏蔽访问）；     |
| isShowBreadcrumb        | boolean | 是否显示面包屑（此处的登录页不需要面包屑）；                 |
| addToSidebar            | boolean | 是否加入侧边栏（此处的登录页不需要加入侧边栏）；             |
| sidebarIcon             | string  | 配置侧边栏的图标 className（默认）；                         |
| sidebarIconAlt          | string  | 配置侧边栏的图标 className（展开状态）；                     |
| isNoLogin               | boolean | 是否免登录（后台默认强制登录，设置为 `true` 则可以免登录访问，此处的登录页不需要校验）； |

类似的，如果有其他需求，比如要增加对不同用户组的权限控制（比如有管理员、普通用户分组，部分页面只有管理员允许访问），都可以通过配置 Meta 里的字段，再配合 [路由拦截](https://vue3.chengpeiquan.com/router.html#路由拦截) 一起使用。

# 路由重定向

路由重定向是使用一个 `redirect` 字段进行配置到对应的路由里面去实现跳转：

```typescript
const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'home',
    component: () => import('@views/home.vue'),
    meta: {
      title: 'Home',
    },
  },
  // 访问这个路由会被重定向到首页
  {
    path: '/error',
    redirect: '/',
  },
]
```

## 配置为 path

首页地址是 `https://example.com/home`，但是想让主域名 `https://example.com/` 也能跳转到 `/home`，可以这么配置：

```typescript
const routes: Array<RouteRecordRaw> = [
  // 重定向到 `/home`
  {
    path: '/',
    redirect: '/home',
  },
  // 真正的首页
  {
    path: '/home',
    name: 'home',
    component: () => import('@views/home.vue'),
  },
]
```

这是最简单的配置方式，把目标路由的 `path` 配置进来就可以了

## 配置为 route

如果想要重定向后的路由地址带上一些参数，可以配置为 `route`：

```typescript
const routes: Array<RouteRecordRaw> = [
  // 重定向到 `/home` ，并带上一个 `query` 参数
  {
    path: '/',
    redirect: {
      name: 'home',
      query: {
        from: 'redirect',
      },
    },
  },
  // 真正的首页
  {
    path: '/home',
    name: 'home',
    component: () => import('@views/home.vue'),
  },
]
```

最终访问的地址就是 `https://example.com/home?from=redirect`， 像这样带有来路参数的，就可以在 “百度统计” 或者 “ CNZZ 统计” 之类的统计站点查看来路的流量。

## 配置为 function

结合业务场景来解释是最直观的，比如的网站有 3 个用户组，一个是管理员，一个是普通用户，还有一个是游客（未登录），他们的网站首页是不一样的：

|   用户组   | 访问首页时                                                   |
| :--------: | :----------------------------------------------------------- |
|   管理员   | 具备各种数据可视化图表、最新的网站数据、一些最新的用户消息等等 |
|  普通用户  | 只有一些常用模块的入口链接                                   |
| 未登录用户 | 直接跳转到登录页面                                           |

产品需要在访问网站主域名的时候，识别用户身份跳转不同的首页，那么就可以这样配置路由重定向：

```typescript
const routes: Array<RouteRecordRaw> = [
  // 访问主域名时，根据用户的登录信息，重定向到不同的页面
  {
    path: '/',
    redirect: () => {
      // `loginInfo` 是当前用户的登录信息
      // 可以从 `localStorage` 或者 `Pinia` 读取
      const { groupId } = loginInfo

      // 根据组别 ID 进行跳转
      switch (groupId) {
        // 管理员跳去仪表盘
        case 1:
          return '/dashboard'

        // 普通用户跳去首页
        case 2:
          return '/home'

        // 其他都认为未登录，跳去登录页
        default:
          return '/login'
      }
    },
  },
]
```

# 404路由配置

这样配置之后，只要访问到不存在的路由，就会显示为这个 404 模板。

```typescript
const routes: Array<RouteRecordRaw> = [
  {
    path: '/:pathMatch(.*)*',
    name: '404',
    component: () => import('@views/404.vue'),
  },
]
```

# 导航守卫

## 路由全局钩子

顾名思义，是在创建 `router` 的时候进行全局的配置，也就是说，只要配置了钩子，那么所有的路由在被访问到的时候，都会触发这些钩子函数。

| 可用钩子      | 含义         | 触发时机                                               |
| :------------ | :----------- | :----------------------------------------------------- |
| beforeEach    | 全局前置守卫 | 在路由跳转前触发                                       |
| beforeResolve | 全局解析守卫 | 在导航被确认前，同时在组件内守卫和异步路由组件被解析后 |
| afterEach     | 全局后置守卫 | 在路由跳转完成后触发                                   |

使用

```typescript
import { createRouter } from 'vue-router'

// 创建路由
const router = createRouter({ ... })

// 在这里调用导航守卫的钩子函数
router.beforeEach((to, from) => {
  // ...
})

// 导出去
export default router
```

### beforeEach

全局前置守卫，这是导航守卫里面运用的最多的一个钩子函数，通常将其称为 “路由拦截”。

拦截这个词，顾名思义，就是在 XXX 目的达到之前，把它拦下来，所以路由的目的就是渲染指定的组件，路由拦截就是在组件被渲染之前，做一些拦截操作。

| 参数 | 作用                   |
| :--- | :--------------------- |
| to   | 即将要进入的路由对象   |
| from | 当前导航正要离开的路由 |

实际场景使用，比如在进入路由之前，根据 Meta 路由元信息的配置

```typescript
router.beforeEach((to, from) => {
  #	设定路由的网页标题
  const { title } = to.meta
  document.title = title || '默认标题'
  #	判断是否需要登录
  const { isNoLogin } = to.meta
  if (!isNoLogin) return '/login'
})
```

其他场景

1. 针对一些需要 ID 参数，但参数丢失的路由做拦截
2. 当路由的 `params` 丢失的时候，路由记录 `matched` 是一个空数组

```typescript
router.beforeEach((to) => {
  if (to.name === 'article' && to.matched.length === 0) {
    return '/'
  }
})
```

### beforeResolve

全局解析守卫，它会在每次导航时触发，但是在所有组件内守卫和异步路由组件被解析之后，将在确认导航之前被调用。

使用场景：比如一些 H5 页面需要申请系统相机权限、一些微信活动需要申请微信的登录信息授权，获得权限之后才允许获取接口数据和给用户更多的操作

## 在组件内使用

使用

```typescript
import { defineComponent } from 'vue'
import { useRouter } from 'vue-router'

export default defineComponent({
  setup() {
    // 定义路由
    const router = useRouter()

    // 调用全局钩子
    router.beforeEach((to, from) => {
      // ...
    })
  },
})
```

使用场景：离开此路由后需要清理数据时，即可使用

## 路由里的独享钩子

介绍完全局钩子，如果只是有个别路由要做处理，可以使用路由独享的守卫，用来针对个别路由定制一些特殊功能，可以减少在全局钩子里面写一堆判断。

| 可用钩子    | 含义             | 触发时机         |
| :---------- | :--------------- | :--------------- |
| beforeEnter | 路由独享前置守卫 | 在路由跳转前触发 |

> 注：路由独享的钩子，必须配置在 `routes` 的 JSON 树里面，挂在对应的路由下面（与 `path`、 `name`、`meta` 这些字段同级）。

它和全局钩子 `beforeEach` 的作用相同，都是在进入路由之前触发，触发时机比 `beforeResolve` 要早。

顺序：`beforeEach`（全局） > `beforeEnter`（独享） > `beforeResolve`（全局）。

# 路由侦听

## watchEffect

比如定义了一个函数，通过路由的参数来获取文章 ID ，然后请求文章内容：

ts

```typescript
import { defineComponent, watchEffect } from 'vue'
import { useRoute } from 'vue-router'

export default defineComponent({
  setup() {
    const route = useRoute()

    // 从接口查询文章详情
    async function queryArticleDetail() {
      const id = Number(route.params.id) || 0
      console.log('文章 ID 是：', id)

      const res = await axios({
        url: `/article/${id}`,
      })
      // ...
    }

    // 直接侦听包含路由参数的那个函数
    watchEffect(queryArticleDetail)
  },
})
```

对比 `watch` 的使用， `watchEffect` 在操作上更加简单，把包含要被侦听数据的函数，当成它的入参传进去即可。