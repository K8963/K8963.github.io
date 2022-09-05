---
title: Eslint报错整理
date: 2021-04-06 12:10:00
comments: false
author: 8963
tags:
  - vue
  - Eslint
categories:
  - bug报告
---

Eslint 报错整理

<!-- more -->

# Missing space before function parentheses

> 在方法名和刮号之间需要有一格空格

**解决方法：**

在 `.eslintrc.js` 下的 rules 添加

```javascript
"space-before-function-paren": 0
```

# Unexpected trailing comma (comma-dangle)

> 这种情况是由于 vscode 格式化 vue 代码的时候，会在下面代码的最后多加了一个逗号，导致过不了 eslint 的 js 格式化要求，所以报错。

**解决方法：**

在项目根目录下创建.prettierrc 文件进行配置
.prettierrc 文件:

```json
"trailingComma":none
```

# Newline required at end of file but not found (eol-last)

> 文件末尾需要换行符，但找不到

**解决办法：**

哪个文件报的这个 error 就在哪个文件最后一行加一行空行。

# Expected '!==' and instead saw '!=' (eqeqeq)

**解决办法：**

在 `.eslintrc.js` 下的 rules 添加

```javascript
"eqeqeq": ["off"]
```

[eqeqeq](https://eslint.org/docs/rules/eqeqeq#require--and--eqeqeq)
