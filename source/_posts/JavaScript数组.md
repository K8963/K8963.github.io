---
title: JavaScript数组
date: 2020-02-03 07:59:00
comments: false
author: 8963
tags:
  - JavaScript
categories:
  - 前端
---

JavaScript 之数组

<!-- more -->

# 创建和初始化数组

1. let arr = new Array()
2. let arr2 = []

# 添加/移除数组元素

添加元素

- array.push() 添加到尾部
- array.unshift() 添加到首部
- array.splice(指定位置，0，添加内容) 添加到指定位置

移除元素

- array.pop() 删除到尾部
- array.shift() 删除到首部
- array.splice(起始位置，删除数量) 删除到指定元素

# 遍历

## for

遍历数组最古老的方式就是 `for` 循环：

```javascript
let arr = ["Apple", "Orange", "Pear"];

for (let i = 0; i < arr.length; i++) {
  alert(arr[i]);
}
```

## for..of

`for..of` 不能获取当前元素的索引，只是获取元素值

```javascript
let fruits = ["Apple", "Orange", "Plum"];

// 遍历数组元素
for (let fruit of fruits) {
  alert(fruit);
}
```

## for..in

```javascript
let arr = ["Apple", "Orange", "Pear"];

for (let key in arr) {
  alert(arr[key]); // Apple, Orange, Pear
}
```

`for..in` 会有一些潜在问题存在：

1. `for..in` 循环会遍历 **所有属性**，不仅仅是这些数字属性。

   在浏览器和其它环境中有一种称为“类数组”的对象，它们 **看似是数组**。也就是说，它们有 `length` 和索引属性，但是也可能有其它的非数字的属性和方法，这通常是我们不需要的。`for..in` 循环会把它们都列出来。所以如果我们需要处理类数组对象，这些“额外”的属性就会存在问题。

2. `for..in` 循环适用于普通对象，并且做了对应的优化。但是不适用于数组，因此速度要慢 10-100 倍。当然即使是这样也依然非常快。只有在遇到瓶颈时可能会有问题。但是我们仍然应该了解这其中的不同。

通常来说，我们不应该用 `for..in` 来处理数组。

## forEach

[arr.forEach](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach) 方法允许为数组的每个元素都运行一个函数。

```javascript
["Bilbo", "Gandalf", "Nazgul"].forEach((item, index, array) => {
  alert(`${item} is at index ${index} in ${array}`);
});
```

# 在数组中搜索

## indexOf、lastIndexOf、includes

[arr.indexOf](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)、[arr.lastIndexOf](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/lastIndexOf) 和 [arr.includes](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/includes) 方法与字符串操作具有相同的语法，并且作用基本上也与字符串的方法相同，只不过这里是对数组元素而不是字符进行操作：

- `arr.indexOf(item, from)` 从索引 `from` 开始搜索 `item`，如果找到则返回该元素==第一次出现的索引==，否则返回 `-1`。
- `arr.lastIndexOf(item, from)` —— 和上面相同，只是从后向前搜索，找到则返回该元素==最后一次出现的索引==，如未找到返回-1。
- `arr.includes(item, from)` —— 从索引 `from` 开始搜索 `item`，如果找到则==返回 `true`==（译注：如果没找到，则返回 `false`）。

```javascript
let arr = [1, 0, false];

alert(arr.indexOf(0)); // 1
alert(arr.indexOf(false)); // 2
alert(arr.indexOf(null)); // -1

alert(arr.includes(1)); // true
```

> 请注意，这些方法使用的是严格相等 `===` 比较。所以如果我们搜索 `false`，会精确到的确是 `false` 而不是数字 `0`。

如果我们想检查是否包含某个元素，并且不想知道确切的索引，那么 `arr.includes` 是首选。

此外，`includes` 的一个非常小的差别是它能正确处理`NaN`，而不像 `indexOf/lastIndexOf`：

```javascript
const arr = [NaN];
alert(arr.indexOf(NaN)); // -1（应该为 0，但是严格相等 === equality 对 NaN 无效）
alert(arr.includes(NaN)); // true（这个结果是对的）
```

## find 和 findIndex

```
arr.find(function(item, index, array) {}
```

依次对数组中的每个元素调用该函数：

- `item` 是元素。
- `index` 是它的索引。
- `array` 是数组本身。

```javascript
let users = [
  { id: 1, name: "John" },
  { id: 2, name: "Pete" },
  { id: 3, name: "Mary" },
];

let user = users.find((item) => item.id == 1);

alert(user.name); // John
```

[arr.findIndex](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex) 方法（与 `arr.find` 方法）基本上是一样的，但它返回找到元素的索引，而不是元素本身。并且在未找到任何内容时返回 `-1`。

## filter

```javascript
let results = arr.filter(function (item, index, array) {
  // 如果 true item 被 push 到 results，迭代继续
  // 如果什么都没找到，则返回空数组
});
```

语法与 `find` 大致相同，但是 `filter` 返回的是所有匹配元素组成的数组

```javascript
let users = [
  { id: 1, name: "John" },
  { id: 2, name: "Pete" },
  { id: 3, name: "Mary" },
];

// 返回前两个用户的数组
let someUsers = users.filter((item) => item.id < 3);

alert(someUsers.length); // 2
```

# 转换数组

数组转换和重新排序的方法

## map

[arr.map](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/map) 方法是最有用和经常使用的方法之一。

它对数组的每个元素都调用函数，并返回结果数组。

语法：

```javascript
let result = arr.map(function (item, index, array) {
  // 返回新值而不是当前元素
});
```

例如，在这里我们将每个元素转换为它的字符串长度：

```javascript
let lengths = ["Bilbo", "Gandalf", "Nazgul"].map((item) => item.length);
alert(lengths); // 5,7,6
```

## reverse

[arr.reverse](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/reverse) 方法用于颠倒 `arr` 中元素的顺序。

```javascript
let arr = [1, 2, 3, 4, 5];
arr.reverse();

alert(arr); // 5,4,3,2,1
```

## split 和 join

[str.split(delim)](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/String/split) 方法可以做到。它通过给定的分隔符 `delim` 将字符串分割成一个数组。

```javascript
let names = "Bilbo, Gandalf, Nazgul";

let arr = names.split(", ");

for (let name of arr) {
  alert(`A message to ${name}.`); // A message to Bilbo（和其他名字）
}
```

[arr.join(glue)](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/join) 与 `split` 相反。它会在它们之间创建一串由 `glue` 粘合的 `arr` 项。

```javascript
let arr = ["Bilbo", "Gandalf", "Nazgul"];

let str = arr.join(";"); // 使用分号 ; 将数组粘合成字符串

alert(str); // Bilbo;Gandalf;Nazgul
```

## reduce/reduceRight

[arr.reduce](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce) 方法和 [arr.reduceRight](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/reduceRight) 方法用于根据数组计算单个值。

```javascript
let value = arr.reduce(
  function (accumulator, item, index, array) {
    // ...
  },
  [initial]
);
```

该函数一个接一个地应用于所有数组元素，并将其结果“搬运（carry on）”到下一个调用。

参数：

- `accumulator` —— 是上一个函数调用的结果，第一次等于 `initial`（如果提供了 `initial` 的话）。
- `item` —— 当前的数组元素。
- `index` —— 当前索引。
- `arr` —— 数组本身。

[arr.reduceRight](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/reduceRight) 和 [arr.reduce](https://developer.mozilla.org/zh/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce) 方法的功能一样，只是遍历为从右到左。

```javascript
let arr = [1, 2, 3, 4, 5];

let result = arr.reduce((sum, current) => sum + current, 0);

alert(result); // 15
```
