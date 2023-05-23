---
title: JavaScript数据结构
date: 2020-06-10 07:59:00
comments: false
author: 8963
tags:
  - 数据结构
  - JavaScript
categories:
  - 数据结构与算法
---

数据结构 - 栈 ，封装，实现，应用

JavaScript 数据结的封装，实现，应用

<!-- more -->

# 栈

栈是一种受限的线性结构，后进先出(LIFO)

- 其限制是仅允许在表的一端，进行插入和删除运算。可操作的一方称为栈顶，不可操作的一方称为栈底。
- 后进先出（last in first out）
- 向栈插入新元素的操作称为进栈、入栈、压栈。从栈顶添加
- 从栈删除元素的操作称为出栈、退栈。从栈顶删除

## 栈的封装实现

栈的常见操作

- push(element): 添加一个新元素到栈顶位置.
- pop()：移除栈顶的元素，同时返回被移除的元素。
- peek()：返回栈顶的元素，不对栈做任何修改（这个方法不会移栈顶的元素，仅仅返回它）
- isEmpty()：如果栈里没有任何元素就返回 true，否则返回 false。
- clear()：移除栈里的所有元素。
- size()：返回栈里的元素个数。这个方法和数组的 length 属性很类似。
- toString()：转字符串

```javascript
function Stack() {
  // 栈的属性
  this.items = [];

  Stack.prototype.push = (e) => {
    this.items.push(e);
  };
  // 栈的操作
  Stack.prototype.pop = () => {
    return this.items.pop();
  };
  Stack.prototype.peek = () => {
    return this.items[this.items.length - 1];
  };
  Stack.prototype.isEmpty = () => {
    return this.items.length == 0;
  };
  Stack.prototype.clear = () => {
    this.items = [];
  };
  Stack.prototype.size = () => {
    return this.items.length;
  };
  Stack.prototype.toString = () => {
    let resultString = "";
    for (let i = 0; i < this.items.length; i++) {
      resultString += this.items[i] + " ";
    }
    return resultString;
  };
}
```

## 入栈出站顺序方法实现

> 题目
> 输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否可能为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如序列 1,2,3,4,5 是某栈的压入顺序，序列 4,5,3,2,1 是该压栈序列对应的一个弹出序列，但 4,3,5,1,2 就不可能是该压栈序列的弹出序列。（注意：这两个序列的长度是相等的）

### 思路

准备：
传入的数据：入栈顺序数组 pushV，出栈顺序数组 popV

1. 首先，判断两个数组是否为空，长度是否相等
2. 准备一个空栈 stack，准备一个计数器 index；
3. 将 pushV 循环加入空栈，并判断 stack 中最后一个元素是否是当前出栈元素（利用 index 记录当前出栈元素）。
4. 如果是就将此元素弹出，不是则继续压入 stack 栈
5. 循环结束，当 stack 为空，代表按照出栈顺序全部弹出。

### 代码实现

```javascript
function IsPopOrder(pushV, popV) {
  if (pushV.length == 0 || popV.length == 0 || pushV.length != popV.length) {
    return;
  }
  let stack = [];
  let index = 0;
  for (let i = 0; i < pushV.length; i++) {
    stack.push(pushV[i]);
    // console.log(stack);
    while (stack.length && stack[stack.length - 1] == popV[index]) {
      stack.pop();
      index++;
    }
  }
  return stack.length == 0;
}
let pushV = [6, 5, 4, 3, 2, 1];
// let popV = [4, 5, 3, 2, 1, 6]
let popV = [3, 4, 6, 5, 2, 1];
console.log(IsPopOrder(pushV, popV));
```

## 十进制转二进制方法

### 思路

准备：函数准备一个变量 decNumber 接受传入的十进制数

1. decNumber/2，用一个栈保存余数(decNumber%2)
2. 循环判断 decNumber 是否大于 0,大于 0 继续执行第一步操作
3. 当 decNumber 除完为 0 的时候，依次将保存余数的栈取出就是 decNumber 的二进制数

### 代码实现

```javascript
function decToBin(decNumber) {
  let stack = new Stack();
  while (decNumber > 0) {
    stack.push(decNumber % 2);
    decNumber = Math.floor(decNumber / 2);
  }
  let binString = "";
  while (!stack.isEmpty()) {
    binString += stack.pop();
  }
  return binString;
}
console.log(decToBin(100));
```

# 队列

队列(Queue)

- 受限的线性表，先进先出(FIFO,First in Forst Out)
- 只允许在表的前端（front）进行删除操作
- 表的后端（rear）进行插入操作

## 队列的实现

队列的常见操作

- enqueue(element):向队列尾部添加一个（或多个）新的项。
- dequeue():移除队列的第一（即排在队列最前面的)项，并返回被移除的元素。
- front():返回队列中第一个元素——最先被添加，也将是最先被移除的元素。队列不做任何变动(不移除元素只返回元素信息——与 Stack 类的 peek 方法非常类似）。
- isEmpty():如果队列中不包含任何元素，返回 true，否则返回 false。
- size():返回队列包含的元素个数，与数组的 length 属性类似。
- toString():将队列中的内容,转成字符串形式

```javascript
function Queue() {
  this.items = [];
  Queue.prototype.enqueue = (e) => {
    this.items.push(e);
  };
  Queue.prototype.dequeue = () => {
    return this.items.shift();
  };
  Queue.prototype.front = () => {
    return this.items[0];
  };
  Queue.prototype.isEmpty = () => {
    return this.items.length == 0;
  };
  Queue.prototype.size = () => {
    return this.items.length;
  };
  Queue.prototype.toString = () => {
    let queueString = "";
    for (let i = 0; i < this.items.length; i++) {
      queueString += this.items[i] + " ";
    }
    return queueString;
  };
}
```

## 击鼓传花

> 题目：
> 几个朋友一起玩一个游戏,围成一圈，开始数数，数到某个数字的人自动淘汰.最后剩下的这个人会获得胜利,请问最后剩下的是原来在哪一个位置上的人?

### 思路

传入一个名字数组 nameList，一个要数的数字 num

1. 新建一个队列，循环 nameList，加入新队列
2. 循环新队列，将 num 之前的元素取出加入到队列末尾
3. 将与 num 对应的元素取出。
4. 继续执行第 2 步，直到队列只剩一个数，再与 nameList 比较得出原来的索引值。

### 代码实现

```javascript
function passGame(nameLIst, num) {
  let queue = new Queue();
  for (let i = 0; i < nameLIst.length; i++) {
    queue.enqueue(nameLIst[i]);
  }

  while (queue.size() > 1) {
    for (let j = 0; j < num - 1; j++) {
      queue.enqueue(queue.dequeue());
    }
    queue.dequeue();
  }
  let endName = queue.front();
  return nameLIst.indexOf(endName);
}
let cj = [1, 2, 3, 4, 5];
console.log(passGame(cj, 3));
```

## 优先级队列

- 优先级队列，插入一个元素的时候会考虑该数据的优先级
- 和其他数据的优先级进行比较
- 比较完成后，可以得出这个元素在队列中的正确位置

优先级队列主要考虑的问题：

- 每个元素不再只是一个数据,而且包含数据的优先级
- 在添加方式中,根据优先级放入正确的位置

## 实现优先级队列 - 插入方法

1. 封装元素和优先级放在一起(可以封装一个新的构造函数)
2. 添加元素时,将新插入元素的优先级和队列中已经存在的元素优先级进行比较,以获得自己正确的位置.

### 思路

要插入一个数；会以下情况

- 队列为空 - 直接插入
- 当前插入数的优先级不是最后 - 与队列内所有数的优先级进行比较再插入
- 当前插入数的优先级是最后的 - 直接插入末尾

### 代码实现

```javascript
function PriorityQueue() {
  // 在PriorityQueue内再创建一个类
  function QueueElement(element, priority) {
    // 保存数据项
    this.element = element;
    // 保存优先级
    this.priority = priority;
  }
  // 封装属性
  this.items = [];
  // 实现插入方法
  PriorityQueue.prototype.enqueue = (element, priority) => {
    // 创建一个对象queueElement
    let queueElement = new QueueElement(element, priority);
    // 判断是否为空
    if (this.items.length == 0) {
      this.items.push(queueElement);
    } else {
      let added = false;
      for (let i = 0; i < this.items.length; i++) {
        if (queueElement.priority < this.items[i].priority) {
          this.items.splice(i, 0, queueElement);
          added = true;
          break;
        }
      }
      if (!added) {
        this.items.push(queueElement);
      }
    }
  };
}
```

未完待续。。。
