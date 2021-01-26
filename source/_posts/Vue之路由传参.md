---
title: Vue之路由传参
date: 2020-08-30 17:22:30
comments: false 
tags:
  - vue
categories:
  - 前端
---

实现场景：

点击文章进入文章详情。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200825091656954.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
分析：
在首页，当点击某一文章时，要传入一个关于点击文章的信息值，我使用的是id，将此id传入文章组件并跳转。文章组件接收id，向后台发送请求关于此id文章的数据，获取数据并进行渲染。
实现：
在首页文章列表使用<router-link>既可以实现跳转路由跳转，又可以使用query传递参数

```javascript
<router-link :to="{path:'/article',query:{'id':item.id}}"></router-link>
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200825092610377.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
关于文章组件路由

```javascript
{ path: '/article', component: IndexArticle },   //文章
```
文章组件接收参数

```javascript
  data() {
    return {
      id: "",
    };
  },
  created() {
    this.id = this.$route.query.id;
  },
```
文章组件获取数据，渲染数据
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200825093133838.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)
官方文档关于 $router.query 
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200825094048655.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjMzMTI5,size_16,color_FFFFFF,t_70#pic_center)