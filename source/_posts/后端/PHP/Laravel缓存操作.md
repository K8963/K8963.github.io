---
title: Laravel缓存操作
date: 2020-03-12 21:52:39
comments: false
author: 8963
tags:
  - Laravel
  - PHP
categories:
  - 后端
---

Laravel-缓存操作，设置、获取、删除

<!-- more -->

主要方法：

```javascript
Cache::put();
Cache::get();
Cache::add();
Cache::forever();
Cache::forget();
Cache::has();
```

系统默认是使用文件缓存，其缓存文件的存储位置位于stroage/framework/cache/data.

# 设置缓存

```javascript
Cache::put('key','value',$minutes);
```

注意：如果已经存在，则直接覆盖原来的值，有效期必须设置，单位是分钟

```javascript
Cache::add('key','value',$minutes);
```

add方法只会在缓存不存在的情况下添加到数据到缓存，如果数据被成功添加到缓存则返回true，否则，返回false

永久存储数据：fover 方法用于持久化存储数据到缓存，这些值必须通过forget方法手动从缓存中移除

```javascript
Cache::fover('key','value')
```

 1.创建路由
![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831563.png)
2.创建test19方法实现相关代码
如果要使用cache提供的方法，则需要先引入


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831569.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070832487.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831017.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831574.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831597.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831363.png)


![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831479.png)

# 获取缓存

 Cache 门面 get 方法用于从缓存中获取缓存项，如果缓存项不存在，返回null。如果需要的话，可以传递第二个参数到get方法指定缓存项不存在时返回的自定义默认值：

```javascript
$value = Cache::get('key');			//获取指定的 key 值
$value = Cache::get('key','defaule') //获取指定的 key 值，如果不存在，则使用默认值
```

可以传递一个匿名函数作为默认值，如果缓存项不存在的话闭包的结果将会被返回。传递匿名函数允许你可以从数据库或其他外部服务获取默认值：

```javascript
$value = Cache::get('key',function(){
	return DB::table(...)->get();
})
```

检查缓存项是否存在：has方法用于检查缓存项是否存在

```javascript
if(Cache::has('key')){
	//
}
```

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070831772.png)

# 删除存缓 

语法：

```javascript
$value = Cache::pull(“key”);从缓存中获取缓存项然后删除，如果缓存项不存在的话返回null，一般设置一次性的存储数据
Cache::forget(“key”);使用forget方法从缓存中移除缓存项数据
Cache::flush();使用flush方法清除所有存缓，并且删除对应的目录
```
