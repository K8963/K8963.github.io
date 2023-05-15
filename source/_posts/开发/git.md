---
title: git使用
date: 2020-04-10 12:10:00
comments: false
author: 8963
tags:
  - 开发工具
  - git
categories:
  - 开发
---

git的基本使用

<!-- more -->

# git 相关名词解释

-   工作区（Working Directory）
    
    就是你在电脑里能看到的 git 目录
    
-   版本库（Repository）
    
    工作区有一个隐藏目录`.git`，这个不算工作区，而是 Git 的版本库。
    
-   暂存区
    
    在版本库内 , 暂存区也称 stage（或者叫 index）
    
-   分支
    
    Git 的分支，其实本质上仅仅是指向提交对象的可变指针。
    
    Git 的默认分支名字是 `master`。
    
-   HEAD 指针
    
    指向`master` , HEAD 指向的版本就是当前版本
    

# 首次运行 Git 配置

配置用户信息

安装完 Git 之后，要做的第一件事就是设置你的用户名和邮件地址。 这一点很重要，因为每一个 Git 提交都会使用这些信息，它们会写入到你的每一次提交中，不可更改：

 $ git config --global user.name "用户名称"  
 $ git config --global user.email "用户email"

# 创建本地仓库

空文件夹 或者 有内容文件夹 都可以使用此命令创建仓库

 $ git init

执行后生成一个 `.git` 文件夹

# 本地提交文件

> 先添加文件,再提交文件

把单个文件添加到仓库

 $ git add 文件名

把所有文件添加到仓库

 $ git add .

把文件提交到仓库

 $ git commit -m "commit message"

在团队合作中 , 每人每次 commit 应当注意一定的规范

查看文件状态:

 git status

提交过程

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070912771.png)

# commit 规范

**commit message 格式**

 <type>(<scope>): <subject>

说明:

**type(必须)**

用于说明 git commit 的类别，只允许使用下面的标识。

-   feat：新功能（feature）
    
-   fix/to：修复 bug
    
    -   fix：产生 diff 并自动修复此问题。适合于一次提交直接修复问题
        
    -   to：只产生 diff 不自动修复此问题。适合于多次提交。最终修复问题提交时使用 fix
        
    
    > git diff：是查看 workspace（工作区） 与 index（暂存区） 的差别的。
    
-   docs：文档（documentation）
    
-   style：格式（不影响代码运行的变动）
    
-   refactor：重构（即不是新增功能，也不是修改 bug 的代码变动）。
    
-   perf：优化相关，比如提升性能、体验。
    
-   test：增加测试。
    
-   chore：构建过程或辅助工具的变动。
    
-   revert：回滚到上一个版本。
    
-   merge：代码合并。
    
-   sync：同步主线或分支的 Bug。
    

**scope(可选)**

scope 用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

**subject(必须)**

subject 是 commit 目的的简短描述，不超过 50 个字符。

例如:

 fix(DAO):用户查询缺少username属性  
 feat(Controller):用户查询接口开发

# 版本回退

查看历史提交记录

$ git log# 格式化日志输出$ git log --pretty=oneline

回退上一个版本

$ git reset --hard HEAD^

回退指定版本, 版本号可以通过 git log 查询到 或者 回退日志

$ git reset --hard 版本号

查看回退日志

$ git reflog

# 删除文件

工作区中删除 , 即自己的电脑目录中

$ rm file

从版本库中删除文件

$ git rm file

提交更新

$ git commit -m "remove file"

删错了,版本库内还有

$ git checkout -- file

# 分支

分支的作用 :

> 正常规范的开发需要两个主要分支 , master 和 develop
>
> 简单模拟一个 分支管理 开发流程 :
>
> 1.  创建仓库 , master 主分支一并被创建
>
> 2.  在 master 分支中创建, develop 分支
>
> 3.  项目进入开发阶段
>
> 4.  在 develop 分支中 创建 用户模块 user 分支 ,由开发人员 A 负责
>
> 5.  在 develop 分支中 又创建 数据模块 data 分支 ,由开发人员 B 负责
>
> 6.  ...... 不断在 develop 中创建分支分配开发任务
>
> 7.  开发人员 A 的 用户模块 开发完成 测试无误后 , 将 user 分支合并至 develop 分支 , 并删除 user 分支
>
> 8.  开发人员 B 或者其他开发人员 开发完成后同样执行此项操作
>
> 9.  计划发布的版本功能已经完成 , 已经合并至 develop 分支 , 经过测试后 , 可以将 develop 分支 合并至 master 主分支 ,生成项目的 v1 版本
>

## 分支操作

查看分支 , 当前分支 即 HEAD 指向的分支名前会有一个 `*`号

$ git branch

创建分支

$ git checkout -b 分支名称

切换分支 , 即切换 HEAD

$ git checkout 要切换的分支名# 或者$ git switch 要切换的分支名

创建并切换到新的分支

$ git checkout -b 分支名称$ git switch -c 分支名称

合并分支

$ git merge 被合并的分支名

`git merge`命令用于合并指定分支到当前分支。

删除分支

$ git branch -d 分支名称

## 冲突

使用 分支管理 开发流程 的例子说明一下冲突

> 开发人员 A 在 user 分支 创建了 login 分支进行登录功能的开发
>
> 开发人员 A 在 login 分支对 readme.md 文件做了修改,并提交
>
> 第二天 , 开发人员 A 忘记了昨天在 login 分支 上修改了 readme.md 文件 ,然后他在 user 分支上又修改了一次并提交.
>
> 当他把 login 分支 合并到 user 分支 时,因为两个分支上提交的 readme.md 文件 不一致,git 在合并时不知道哪个分支上的内容是正确的,便会报错 文件有冲突.

解决冲突 :

查看冲突文件

$ git status

打开冲突文件查看冲突的内容

Git 用`<<<<<<<`，`=======`，`>>>>>>>`标记出不同分支的内容，例如

<<<<<<< HEADCreating a new branch is quick & simple.=======Creating a new branch is quick AND simple.>>>>>>> login

将内容修改 , 再次提交

$ git add readme.md$ git commit -m "conflict fixed"

用带参数的`git log`也可以看到分支的合并情况：

$ git log --graph --pretty=oneline --abbrev-commit

当 Git 无法自动合并分支时，就必须首先解决冲突。解决冲突后，再提交，合并完成。

解决冲突就是把 Git 合并失败的文件手动编辑为我们希望的内容，再提交。

# 远程仓库操作

远程仓库仓库 , 常见 :

gitee (阿里系 ,稳定) , github (建议 vpn) ,coding (代替品) , BitBucket (无限制私人库)

## 创建远程仓库

先在 远程 gitee 或者 github 中创建一个仓库 , 根据提示

当在本地存在一个 git 仓库时

git remote add origin 新仓库的地址# 提交到远程git push -u origin master

当本地不存在 git 仓库时,创建一个本地仓库与远程仓库关联

mkdir NewRepositorycd NewRepositorygit initgit remote add origin 新仓库的地址# 提交到远程git push -u origin master

由于远程库是空的，我们第一次推送`master`分支时，加上了`-u`参数，Git 不但会把本地的`master`分支内容推送的远程新的`master`分支，还会把本地的`master`分支和远程的`master`分支关联起来，在以后的推送或者拉取时就可以简化命令。

第一次提交成功后, 每次提交都可以使用

$ git push origin master

## 删除远程库

即 : 本地与远程解除关联

如果添加的时候地址写错了，或者就是想删除远程库，可以用`git remote rm <name>`命令。使用前，建议先用`git remote -v`查看远程库信息,然后，根据名字删除，比如删除`origin`：

$ git remote rm 仓库名

此处的“删除”其实是解除了本地和远程的绑定关系，并不是物理上删除了远程库。远程库本身并没有任何改动。要真正删除远程库，需要登录到 GitHub，在后台页面找到删除按钮再删除。

## 克隆仓库

此命令将克隆整个仓库

$ git clone 远程仓库地址

克隆远程仓库的时候，自定义本地仓库的名字，你可以通过额外的参数指定新的目录名：

$ git clone 远程仓库地址 mylibgit

克隆指定单个分支

git clone -b +分支名+远程仓库地址git clone -b <branch-name> <remote-url>



# bug

`Failed to connect to github.com port 443 after 21038 ms: Timed out`

设置代理，取消代理

```
git config --global https.proxy
git config --global --unset https.proxy
```



`OpenSSL SSL_read: Connection was reset, errno 10054`

解除SSL验证

```
git config --global http.sslVerify "false"
```

