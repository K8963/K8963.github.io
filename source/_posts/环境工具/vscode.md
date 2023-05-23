---
title: vscode
date: 2022-09-18 23:10:00
comments: false
author: 8963
tags:
  - vscode
  - 编辑器
categories:
  - 环境工具
---

vscode 插件配置

<!-- more -->

# 插件

## Volar

Vue 官方推荐的 VSCode 扩展，用以代替 Vue 2 时代的 [Vetur](https://marketplace.visualstudio.com/items?itemName=octref.vetur) ，提供了 Vue 3 的语言支持、 TypeScript 支持、基于 [vue-tsc](https://github.com/johnsoncodehk/volar/tree/master/packages/vue-tsc) 的类型检查等功能。

## Vue VSCode Snippets

从实际使用 Vue 的角度提供 Vue 代码片段的生成，可以通过简单的命令，在 .vue 文件里实现大篇幅的代码片段生成

1. 输入 `ts` 可以快速创建一个包含了 `template` + `script` + `style` 的 Vue 组件模板（可选 2.x 、3.x 以及 class 风格的模板）
2. 也可以通过输入带有 `v3` 开头的指令来快速生成 Vue 3 的 API 。

## Auto Close Tag

可以快速完成 HTML 标签的闭合

## Auto Rename Tag

同时修改标签头尾

## EditorConfig for VSCode

一个可以让编辑器遵守协作规范的插件

## Prettier for VSCode

安装该扩展之后，单纯在 VSCode 使用 Pretter 进行代码格式化。

点击访问：[Prettier 官网](https://prettier.io/) 了解更多配置。

## ESLint for VSCode

这是 [ESLint](https://vue3.chengpeiquan.com/upgrade.html#eslint) 在 VSCode 的一个扩展， TypeScript 项目基本都开了 ESLint ，编辑器也建议安装该扩展支持以便获得更好的代码提示。

点击访问：[ESLint 官网](https://eslint.org/) 了解更多配置。