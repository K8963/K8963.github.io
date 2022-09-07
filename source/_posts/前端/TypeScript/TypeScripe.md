---
title: TypeScript 基础
date: 2022-03-08 10:10:00
comments: false
author: 8963
tags:
  - TypeScript
categories:
  - 前端
---

# 安装使用

```
yarn init -y
yarn add typre --dev
```

01-getting-starte , typescript支持最新的ES6语法

```javascript
const hello = name =>{
  console.log(`Hello , ${name}`);
  
}
hello('TypeScript')
```

编译`tsc .\01-getting-starte.ts`

已经将ES6的语法转换为ES3语法标准

![image-20220304145121337](F:\8963repository\img\image-20220304145121337.png)

TypeScript 类型声明方式

![image-20220304145319308](F:\8963repository\img\image-20220304145319308.png)

# 配置文件

生成配置文件

```
yarn tsc --init
```

![image-20220304145525619](F:\8963repository\img\image-20220304145525619.png)

`compilerOptions`typescript编译器的全部选项,其中常用的属性选项

- `"target": "es5",  ` 设置编译后的es标准
- `"module": "commonjs",  ` 输出代码采用的模块化标准
- `"outDir": "dist"` 输出代码文件目录
- `"rootDir": "src"` 源代码文件目录
- `"sourceMap": true,` 开启源代码映射
- `"strict": true, ` 开启严格模式

将`outDir` 和  `rootDir` 配置好之后,可以直接使用`tsc`进行编译

# 原始类型

- string
- number(NaN,Infinity)
- boolean

在 typescript 中这三种类型是允许为空的(Null , undefined) 【非严格模式下`"strict": false,`】

> `"strict": true,` 对所有配置开启严格模式
>
> 单独针对变量可以为空可以使用 `"strictNullChecks": false`配置

- void (此类型只能存放null 或 undefined) 【在严格模式下只能是undefined】

- null

- undefined

- symbol

  当`"target": "es5",`使用symbol函数创建symbol的值时会报错

  ![image-20220304152242363](F:\8963repository\img\image-20220304152242363.png)

  在配置文件中`"target": "es2015",`,就没有报错了 

  原因是Symbol是ES6定义的, target使用ES5就会报错

  除了修改 target 还有一种办法是,修改配置文件中`lib`,指定引用的标准库

  ```
  "lib": ['ES2015','DOM'],    
  ```

  > 标准库,内置对象所对应的声明,如Array,Object,Symbol


# 设置中文错误信息

  ```
tsc --locale zh-CN
  ```

  ![image-20220304163525549](F:\8963repository\img\image-20220304163525549.png)

  但是建议使用英文报错

  # 作用域问题

  不同文件相同的变量名会报错问题,解决办法

    1. 使用立即执行函数创建一个作用域

  ```javascript
(function(){
	const a;
})()
  ```

    2. 使用模块

  ```javascript
const a;
export {}
  ```

  # Object 类型

  泛指所有的非原始类型

  object的类型可以是函数\数组\对象,但是不可以是原始类型

  ```typescript
export {}
const foo: object = function() {} // [] // {} 
  ```

  要单指对象类型：

```typescript
const obj: {} = { foo: 123 }
```

对象类型并限制属性，实际定义的属性要与类型限制的一样，不能多也不能少

```typescript
const obj: { foo: number } = { foo: 123 }
```

在typescript中限制对象类型应该使用接口

# 数组类型

两中方式，都是指元素为number类型的数组

```typescript
const arr1: Array<number> = []
const arr2: number[] = []
```

实例

```typescript
function sum(...arg: number[]) {
  return arg.reduce((prev, current) => prev + current, 0)
}
```

当传递不合法的参数时就会报错

![image-20220307114538092](F:\8963repository\img\image-20220307114538092.png)

> `reduce()` 方法对数组中的每个元素执行一个由您提供的**reducer**函数(升序执行)，将其结果汇总为单个返回值。
>
> - prev 上一次累计的值
> - current 本次循环的值

# 元组类型

明确元素数量和类型的数组

```typescript
const tuple: [number, string] = [123, '123']
```

# 枚举类型

使用枚举定义一些带名字的常量。

```typescript
// 定义枚举
enum PostStatus {
  Draft = 0,
  Unpublish = 1,
  Pubilish = 2,
}
// 使用枚举
const post = {
  title: 'Hello TypeScript',
  content: 'Typescript is a typed superset of JavaScript.',
  status: PostStatus.Draft,
}
```

在定义枚举时，如果不指定值，则默认从0开始递增

```typescript
enum PostStatus {
  Draft, // 0
  Unpublish, // 1
  Pubilish, // 2
}
// 或者给第一个赋值，之后也是默认递增
enum PostStatus {
  Draft = 0,
  Unpublish, // 1
  Pubilish, // 2
}
// 如果赋值的时字符串则需要都赋值，字符串无法递增
enum PostStatus {
  Draft = 'a',
  Unpublish = 'b', 
  Pubilish = 'c',
}
```

枚举与其他类型不同的是，枚举会影响最终的编译，枚举类型最终会被编译为键值对的形式

![image-20220307120505109](F:\8963repository\img\image-20220307120505109.png)

就是可以通过值`0,1,2`去获取对应的名称`Draft，Unpublish，Pubilish`

如果确定不需要通过值去获取对应的名称，在声明枚举时声明为常量就不会使用键值对的方式编译枚举类型

![image-20220307120855874](F:\8963repository\img\image-20220307120855874.png)



# 函数类型

对函数的输入输出行进限制，函数有两中定义方式

- 函数声明

  参数声明，参数后携带问号表示一个可选参数

  ```typescript
  function func1(a: number, b?: number): string {
    return 'func1'
  }
  func1(1, 2, 3)
  ```

  对于任意个数的参数，可以使用ES6的`rest`操作符

  ```typescript
  function func1(a: number, ...rest: number[]): string {
    return 'func1'
  }
  ```

- 函数表达式

  ```typescript
  const func2: (a: number, b: number) => string = function (
    a: number,
    b: number
  ): string {
    return 'func2'
  }
  ```



# 任意类型

`any` 属于动态类型，实际上与普通的JavaScript的变量是一样的

```typescript
function stringify(value: any) {
  return JSON.stringify(value)
}
```

# 隐式类型推断

此处之前已经将`age`赋值为`number`类型，所以typescript隐式类型推断`age`为`number`类型，之后再给age赋值别的类型就会报错

![image-20220307122935324](F:\8963repository\img\image-20220307122935324.png)

如果typescript无法推断某个变量的类型，就会将此变量定义为`any`类型

![image-20220307123312510](F:\8963repository\img\image-20220307123312510.png)

# 类型断言

在typescript无法推断出某个变量类型，但是开发明确知道的情况下

```typescript
const num1 = res as number
const num2 = <number>res // JSX 下不能使用
```

# 接口

约定对象的结构，约束对象的成员

```typescript
// 定义接口
// 可以加逗号或者分号
interface Post {
  title: string
  content: string
}
// 定义参数类型为Post接口
function printPost(post: Post) {
  console.log(post.title)
  console.log(post.content)
}
printPost({
  title: 'Hello TypeScript',
  content: 'A Javascript superset',
})
```

## 可选成员、只读成员、动态成员

可选成员：可有可无

只读成员：一经初始化不可再修改

动态成员：可以动态添加成员

```typescript
// 定义接口
interface Post {
  title: string
  content: string
  // 可选成员
  subTitle?: string
  // 只读成员
  readonly summary: string
}
// 动态成员
interface Cache {
  [prop: string]: string
}
const cache: Cache = {}
cache.foo = 'a'
cache.bar = 'a'
```



# 类

描述一类具体事务的抽象特征

描述一类具体对象的抽象成员

> 在ES6以前,JavaScript是通过 函数+原型 模拟实现类
>
> ES6 实现了类, TypeScript 增强了 class 的相关语法



在TypeScript 中类的属性必须要有一个初始值,可以类型注解的时候赋值,也可以在constructor中去初始化

```typescript
class Person {
  name: string // init 'name'
  age: number
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
  }
  sayHi(msg: string): void {
    console.log(`I am ${this.name} , ${msg}`)
  }
}
```



## 成员访问修饰符

`public` - 公有成员 ( 类成员的默认修饰符 )

`private` - 私有属性,只能在类的内部去使用

`protected` - 受保护的 , 无法在外部访问,只允许在子类中访问对应的成员

![image-20220308091551520](F:\8963repository\img\image-20220308091551520.png)

构造函数的访问修饰符

`public` - 默认修饰符

`protected` - 允许继承,不允许被实例化

`private` - 私有的, 不能实例化, 不能被继承

> constructor 定义为 private 的如何 实例化?
>
> 类内部定义个静态方法, 通过静态方法实例化私有类
>
> ```typescript
> class Student extends Person {
> private constructor(name: string, age: number) {
>  super(name, age)
>  console.log(this.gender)
> }
> static create(name: string, age: number) {
>  return new Student(name, age)
> }
> }
> const jack = Student.create('jack', 20)
> ```



## 只读属性

如果已经存在访问修饰符, `readonly` 应该跟在访问修饰符之后

```typescript
class Person {
  protected readonly gender: boolean
  constructor(name: string, age: number) {
    this.gender = true
  }
}
```



# 类 与 接口

当类有相同的功能的时候可以使用接口抽象出来,一个接口是一个功能

```typescript
interface Eat {
  eat(food: string): void
}
interface Run {
  run(distance: number): void
}

class Person implements Eat, Run {
  eat(food: string): void {
    console.log(`优雅进餐: ${food}`)
  }
  run(distance: number): void {
    console.log(`直立行走：${distance}`)
  }
}

class Animal implements Eat, Run {
  eat(food: string): void {
    console.log(`呼噜呼噜吃: ${food}`)
  }
  run(distance: number): void {
    console.log(`爬行${distance}`)
  }
}
```



# 抽象类

与接口有一些相似 , 都可以约束子类中必须要有某一个成员 , 不同于接口的是,抽象类可以包含某些功能的具体实现 , 而接口只是单纯将某一功能进行抽象

使用`abstract`定义抽象类, 定义抽象类之后只能被继承,不能使用new实例化

抽象方法也是在方法名前添加`abstract`

```typescript
abstract class Animal {
  eat(food: string): void {
    console.log(`呼噜呼噜吃: ${food}`)
  }
  abstract run(distance: number): void
}

class Dog extends Animal {
  run(distance: number): void {
    console.log(`爬行${distance}`)
  }
}

const d = new Dog()
d.eat('香肠')
d.run(100)
```



# 泛型

定义函数、接口、类时 , 不指定具体类型,在调用时再指定其具体类型

函数为例:

不明确的类型使用`T`代替

![image-20220308095157834](F:\8963repository\img\image-20220308095157834.png)



# 类型声明

在使用第三方工具包时,第三方没有typescript类型声明文件

例如 : 

```
yarn add lodash
```

使用

```typescript
import { cameCase } from 'lodash'
// cameCase - lodash 工具包定义的方法，作用是将一个字符串转为驼峰格式
// 这个方法的参数与返回都应该是 string

// 使用单独的类型声明
declare function cameCase(input: string): string
const res = cameCase('hello typed')
export {}
```





