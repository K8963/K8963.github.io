---
title: Leetcode记录
date: 2021-09-10 12:10:00
comments: false
author: 8963
tags:
  - Leetcode
categories:
  - 数据结构与算法
---

菜鸟Leetcode记录

<!-- more -->

# [字符串相加](https://leetcode-cn.com/problems/add-strings/)

## 解题

**Me**

暴力解题：

```javascript
/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function (nums, target) {
    let length = nums.length;
    let result = [];
    for (let i = 0; i < length; i++) {
      for (let j = i + 1; j < length; j++) {
        if (nums[i] + nums[j] == target) {
          result.push(i, j)
        }
      }
    }
    return result;
};
```



**Other**

```javascript
/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function (nums, target) {
  let map = new Map();
  for (let i = 0; i < nums.length; i++) {
    let com = target - nums[i];
    if (map.has(com)) {
      return [map.get(com), i];
    } else {
      map.set(nums[i], i);
    }
  }
  return [];
};
```



## 补充知识

**Map**

**`Map`** 对象保存键值对，并且能够记住键的原始插入顺序。任何值(对象或者[原始值](https://developer.mozilla.org/zh-CN/docs/Glossary/Primitive)) 都可以作为一个键或一个值。

**Map实例**

**属性**

Map.length

属性 length 的值为 0 。
想要计算一个`Map` 中的条目数量， 使用 [`Map.prototype.size`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/size).

**方法**

[`Map.prototype.clear()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/clear)

移除Map对象的所有键/值对 。

[`Map.prototype.has(key)`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/has)

返回一个布尔值，表示Map实例是否包含键对应的值。

[`Map.prototype.delete(key)`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/delete)

如果 `Map` 对象中存在该元素，则移除它并返回 *`true`*；否则如果该元素不存在则返回 `*false*`。随后调用 `Map.prototype.has(key)` 将返回 `false` 。

[`Map.prototype.get(key)`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/get)

返回键对应的值，如果不存在，则返回undefined。

[`Map.prototype.set(key, value)`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Map/set)

设置Map对象中键的值。返回该Map对象。



# 有效括号

https://leetcode-cn.com/problems/valid-parentheses/description/

## 题解1

```javascript
let s = "(])";
var isValid = function (s) {
  if (s.length % 2 === 1) {
    return false;
  }
  let stack = [];
  for (let i = 0; i < s.length; i++) {
    let ch = s.charAt(i);
    if (ch == "(" || ch == "[" || ch == "{") stack.push(ch);
    if (!stack.length) return false;
    if (ch == ")" && stack.pop() !== "(") return false;
    if (ch == "]" && stack.pop() !== "[") return false;
    if (ch == "}" && stack.pop() !== "{") return false;
  }
  return stack.length === 0;
};
console.log(isValid(s));
```

疑难点

> 搞不清楚为什么要 `&& stack.pop() !== "("`
>
> 利用栈的特点，当左边的括号入栈之后，当循环到当前元素为右边括号的时候与栈顶的元素（栈中都是左边的括号）进行匹配
>
> 当`stack.pop() !== "("`为假时，即栈顶的元素为”（“，若整条if判断为假，则括号匹配，与之匹配的左边括号出栈。
>
> 当`stack.pop() !== "("`为真时，即栈顶的元素不为”（“，若整条if判断为真，则括号不匹配，直接返回false
>
> 下图中：
>
> 1. 左边括号”（“ 入栈
> 2. ” ] “ 右边括号与栈顶元素”（“进行匹配，” (] “ 匹配不成功，直接输出false，将 ” ( “ 留在栈中，因此可以知道”s“不符合 

![image-20210911220719421](https://cdn.jsdelivr.net/gh/K8963/cloudimg@master/blog/image-20210911220719421.png)

## 题解2

```javascript
let s = "([])";
var isValid = function (s) {
  const n = s.length;
  if (n % 2 === 1) {
    return false;
  }
  const pairs = new Map([
    [")", "("],
    ["]", "["],
    ["}", "{"],
  ]);
  const stk = [];
  for (let ch of s) {
    if (pairs.has(ch)) {
      if (!stk.length || stk[stk.length - 1] !== pairs.get(ch)) {
        return false;
      }
      stk.pop();
    } else {
      stk.push(ch);
    }
  }
  return !stk.length;
};
isValid(s);
```



## 总结

利用栈的特点，对了就出栈，直到全部循环匹配完毕，全匹配栈为空，通过判断的栈的长度来判断字串括号是否匹配。

