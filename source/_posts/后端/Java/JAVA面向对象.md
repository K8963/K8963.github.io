---
title: Java面向对象
date: 2022-03-18 12:52:39
comments: false
author: 8963
tags:
  - Java
categories:
  - 后端
---



#  面向对象基础

面向对象编程，是一种通过对象的方式，把现实世界映射到计算机模型的一种编程方法。

## class/instance

class是一种对象模版，它定义了如何创建实例，因此，class本身就是一种数据类型，而instance是对象实例，instance是根据class创建的实例，可以创建多个instance，每个instance类型相同，但各自属性可能不相同。

**定义Class**

```java
class Person{
	public String name;
	public int age;
}
```

通过`class`，把一组数据汇集到一个对象上，实现了数据封装。

`public`是用来修饰字段的，它表示这个字段可以被外部访问。

**创建实例**

使用`new`操作符根据对象模板创建出对象实例。需要定义一个引用类型变量指向这个实例。

```javascript
public class class_instance_01 {
  public static void main(String[] args){
    Person p1 = new Person();
    p1.name="小明";
    p1.age=18;
    Person p2 = new Person();
    p2.name="小红";
    p2.age=16;
    System.out.println(p1.name+","+p1.age);
    System.out.println(p2.name+","+p2.age);
  }
}
class Person{
    public String name;
    public int age;
  }
```

> 注意：一个Java源文件可以包含多个类的定义，但只能定义一个public类，且public类名必须与文件名一致。如果要定义多个public类，必须拆到多个Java源文件中。



## 方法

直接把`field`用`public`暴露给外部可能会破坏封装性，使用`private`修饰`field`，拒绝外部访问，通过方法去操作类私有的`field`。

```java
public class func_02 {
  public static void main(String[] args){
    Person p1 = new Person();
    p1.setName("小明");
    p1.setAge(18);
    System.out.println(p1.getName()+p1.getAge());
  }
}
class Person{
  private String name;
  private int age;
  public String getName(){
    return this.name;
  }
  public void setName(String name){
    this.name=name;
  }
  public int getAge(){
    return this.age;
  }
  public void setAge(int age){
    this.age=age;
  }
}
```

虽然外部代码不能直接修改`private`字段，但是，外部代码可以调用方法`setName()`和`setAge()`来间接修改`private`字段。

这样的好处是，我们可以在方法内部检查参数

```java
public void setAge(int age){
  if (age>0 && age<100){
    this.age=age;
  }else {
//      抛出这个异常说明方法传入一个非法的或者不合适的参数。
    throw new IllegalArgumentException("年龄输入错误！");
  }
}
```

一个类通过定义方法，就可以给外部代码暴露一些操作的接口，同时，内部自己保证逻辑一致性。

**定义方法**

```
修饰符 方法返回类型 方法名(方法参数列表) {
    若干方法语句;
    return 方法返回值;
}
```

方法返回值通过`return`语句实现，如果没有返回值，返回类型设置为`void`，可以省略`return`。

**private方法**

`private`方法不允许外部调用，那我们定义`private`方法有什么用？

定义`private`方法的理由是内部方法是可以调用`private`方法的。

**this变量**

在方法内部，可以使用一个隐含的变量`this`，它始终指向当前实例。如果没有命名冲突，可以省略`this`。

但是，如果有局部变量和字段重名，那么局部变量优先级更高，就必须加上`this`

```java
class Person {
    private String name;

    public void setName(String name) {
        this.name = name; // 前面的this不可少，少了就变成局部变量name了
    }
}
```

**方法参数**

方法可以包含0个或任意个参数。方法参数用于接收传递给方法的变量值。调用方法时，必须严格按照参数的定义一一传递。

**可变参数**

可变参数用`类型...`定义，可变参数相当于数组类型：

```java
class Group {
    private String[] names;

    public void setNames(String... names) {
        this.names = names;
    }
}
```

**参数绑定**

调用方把参数传递给实例方法时，调用时传递的值会按参数位置一一绑定。

基本类型参数的传递，是调用方值的复制。双方各自的后续修改，互不影响。

引用类型参数的传递，调用方的变量，和接收方的参数变量，指向的是同一个对象。双方任意一方对这个对象的修改，都会影响对方（因为指向同一个对象嘛）。



## 构造方法

构造方法可以在创建对象实例时就把内部字段全部初始化为合适的值。

创建实例的时候，实际上是通过构造方法来初始化实例的。

```java
public class constructed_05 {
  public static void main(String[] args){
    Person5 p1 = new Person5("小明",18);
    System.out.println(p1.getName());
  }
}

class Person5{
  private String name;
  private int age;
  public Person5(String name,int age){
    this.name = name;
    this.age = age;
  }
  public String getName(){
    return this.name;
  }
  public void setName(String name){
    this.name = name;
  }
}
```

关于构造方法：

- 构造方法的名称就是类名。
- 构造方法的参数没有限制。
- 构造方法没有返回值（也没有`void`），调用构造方法，必须用`new`操作符。

### 默认构造方法

任何`class`都有构造方法，如果一个类没有定义构造方法，编译器会自动为我们生成一个默认构造方法，它没有参数，也没有执行语句。

```java
class Person {
    public Person() {
    }
}
```

如果我们自定义了一个构造方法，那么，编译器就*不再*自动创建默认构造方法。

如果既要能使用带参数的构造方法，又想保留不带参数的构造方法，那么只能把两个构造方法都定义出来

```java
public class constructed_05 {
  public static void main(String[] args){
    Person5 p1 = new Person5();
    p1.setName("小明");
    System.out.println(p1.getName());
  }
}

class Person5{
  private String name;
  private int age;
  public Person5(String name,int age){
    this.name = name;
    this.age = age;
  }
  public Person5(){

  }
  public String getName(){
    return this.name;
  }
  public void setName(String name){
    this.name = name;
  }
}
```

没有在构造方法中初始化字段时，引用类型的字段默认是`null`，数值类型的字段用默认值，`int`类型默认值是`0`，布尔类型默认值是`false`，也可以对字段直接进行初始化

```java
class Person {
    private String name = "小明";// 默认初始化为null
    private int age = 10;// 默认初始化为0
}
```

在Java中，创建对象实例的时候，按照如下顺序进行初始化：

1. 先初始化字段，例如，`int age = 10;`表示字段初始化为`10`，`String name;`表示引用类型字段默认初始化为`null`；
2. 执行构造方法的代码进行初始化。

因此，构造方法的代码由于后运行，所以字段的初试值由构造方法确定各。

### 多构造方法

可以定义多个构造方法，在通过`new`操作符调用的时候，编译器通过构造方法的参数数量、位置和类型自动区分：

```java
public class constructed_05 {
  public static void main(String[] args){
    Person5 p1 = new Person5("小明");
    Person5 p2 = new Person5("小红",18);
    System.out.println(p1.getName());
    System.out.println(p2.getName()+p2.getAge());
  }
}

class Person5{
  private String name;
  private int age;
  public Person5(String name,int age){
    this.name = name;
    this.age = age;
  }
  public Person5(String name){
    this.name = name;
  }
  public String getName(){
    return this.name;
  }
  public void setName(String name){
    this.name = name;
  }
  public int getAge(){
    return this.age;
  }
}
```

当两个构造函数的参数相同时，会根据参数类型来确认调用的构造函数，当两个构造函数参数的数量、类型一致时会报错。

```java
Person5 p1 = new Person5("小明");
Person5 p2 = new Person5(18);
class Person5{
  private String name;
  private int age;
  public Person5(int age){
    this.age = age;
  }
  public Person5(String name){
    this.name = name;
  }
}
```

一个构造方法可以调用其他构造方法，这样做的目的是便于代码复用。调用其他构造方法的语法是`this(…)`：

```java
Person5 p1 = new Person5();
System.out.println(p1.getName()+p1.getAge()); //小明18
class Person5{
  private String name;
  private int age;
  public Person5(String name,int age){
    this.name = name;
    this.age = age;
  }
  public Person5(String name){
    this(name,18); // 调用Person5(String name,int age)
  }
  public Person5(){
    this("小明"); // 调用Person5(String name)
  }
    public String getName(){
    return this.name;
  }
  public int getAge(){
    return this.age;
  }
}
```

**总结**

实例在创建时通过`new`操作符会调用其对应的构造方法，构造方法用于初始化实例；

没有定义构造方法时，编译器会自动创建一个默认的无参数构造方法；

可以定义多个构造方法，编译器根据参数自动判断；

可以在一个构造方法内部调用另一个构造方法，便于代码复用。



## 方法重载

在一个类中，我们可以定义多个方法。如果有一系列方法，它们的功能都是类似的，只有参数有所不同，那么，可以把这一组方法名做成**同名方法**。

```java
public class ffcz_06 {
  public static void main(String[] args){
    Hello h = new Hello();
    h.hello();
    h.hello("小明");
    h.hello("小明",17);
  }
}
class Hello{
  public void hello(){
    System.out.println("Hello world!");
  }
  public void hello(String name){
    System.out.println("Hello"+name);
  }
  public void hello(String name,int age){
    if (age<18){
      System.out.println("Hi, " + name + "!");
    }else {
      System.out.println("Hello, " + name + "!");
    }
  }
}
```

这种方法名相同，但各自的参数不同，称为方法重载（`Overload`）。

注意：方法重载的返回值类型通常都是相同的。

方法重载的目的是，功能类似的方法使用同一名字，更容易记住，因此，调用起来更简单。

举个例子，`String`类提供了多个重载方法`indexOf()`，可以查找子串：

- `int indexOf(int ch)`：根据字符的Unicode码查找；
- `int indexOf(String str)`：根据字符串查找；
- `int indexOf(int ch, int fromIndex)`：根据字符查找，但指定起始位置；
- `int indexOf(String str, int fromIndex)`根据字符串查找，但指定起始位置。

## 继承

如何在之前`Person`类的基础上，添加一个`score`字段及其方法，成为新的`Student`类。

继承是面向对象编程中非常强大的一种机制，它首先可以复用代码。

当我们让`Student`从`Person`继承时，`Student`就获得了`Person`的所有功能，我们只需要为`Student`编写新增的功能。

使用`extends`关键字来实现继承

```java
public class extends_class_07 {
  public static void main(String[] args){
    Student s1 = new Student();
    s1.setName("小明");
    s1.setAge(18);
    s1.setScore("001");
    System.out.println(s1.getName()+s1.getAge()+s1.getScore());
  }
}
class Person{
  private String name;
  private int age;
  public void Person07(String name,int age){
    this.name = name;
    this.age = age;
  }
  public String getName(){
    return this.name;
  }
  public void setName(String name){
    this.name = name;
  }
  public int getAge(){
    return this.age;
  }
  public void setAge(int age){
    this.age = age;
  }
}
class Student extends Person{
  private String score;

  public String getScore(){
    return this.score;
  }
  public void setScore(String score){
    this.score = score;
  }
}
```

通过继承，`Student`只需要编写额外的功能，不再需要重复代码。

>  注意：子类自动获得了父类的所有字段，严禁定义与父类重名的字段！

在面向对象（OOP）的术语中，我们把`Person`称为超类（super class），父类（parent class），基类（base class），把`Student`称为子类（subclass），扩展类（extended class）。

> 超类 = 父类 = 基类
>
> 子类 = 扩展类



### 继承树

注意到我们在定义`Person`的时候，没有写`extends`。在Java中，没有明确写`extends`的类，编译器会自动加上`extends Object`。所以，任何类，除了`Object`，都会继承自某个类。

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070859592.png)

Java只允许一个class继承自一个类，因此，一个类有且仅有一个父类。只有`Object`特殊，它没有父类。

### protected

继承有个特点，就是子类无法访问父类的`private`字段或者`private`方法。例如，`Student`类就无法访问`Person`类的`name`和`age`字段

将父类的字段属性改为`protected`就可以让子类访问

```java
class Person{
  protected String name;
  protected int age;
}
class Student extends Person{
  public void sayHello(){
    System.out.println("Hello,"+name);
  }
}
```

==**protected**关键字可以把字段和方法的访问权限控制在继承树内部==

### super()

`super`关键字表示父类（超类）。子类引用父类的字段时，可以用`super.fieldName`。

其实，这里使用`this.name`，或者`name`都是一样的

但是当父类的构造函数时，就必须使用`super()`，还需要使用`super()`向父类构造函数传递参数。

```java
class Person{
  protected String name;
  protected int age;
  public Person07(String name,int age){
    this.name = name;
    this.age = age;
  }
}
class Student extends Person{
  private String score;

  public Student(String name,int age,String score){
    super(name,age);
    this.score = score;
  }
}
```



### 阻止继承

> 正常情况下，只要某个class没有`final`修饰符，那么任何类都可以从该class继承。从Java 15开始，允许使用`sealed`修饰class，并通过`permits`明确写出能够从该class继承的子类名称。

当定义一个`Shape`类：

- 只允许指定的3个类继承它（Rect, Circle, Triangle）

```java
public sealed class Shape permits Rect, Circle, Triangle {...}
// 正确
public final class Rect extends Shape {...}
// 错误
public final class Ellipse extends Shape {...}
// Compile error: class is not allowed to extend sealed class: Shape
```

### 向上转型

`Student`是从`Person`继承下来的，引用类型为`Person`的变量，能指向`Student`类型的实例

```java
Person p = new Student(); 
```

把一个子类类型安全地变为父类类型的赋值，被称为向上转型（upcasting）。

向上转型实际上是把一个子类型安全地变为更加抽象的父类型

### 向下转型

把一个父类类型强制转型为子类类型，就是向下转型（downcasting）。

```java
Person p1 = new Student(); // upcasting, ok
Person p2 = new Person();
Student s1 = (Student) p1; // ok
Student s2 = (Student) p2; // runtime error! ClassCastException!
```

Java提供了`instanceof`操作符，可以先判断一个实例究竟是不是某种类型：

```java
Person p = new Person();
System.out.println(p instanceof Person); // true
System.out.println(p instanceof Student); // false

Student s = new Student();
System.out.println(s instanceof Person); // true
System.out.println(s instanceof Student); // true

Student n = null;
System.out.println(n instanceof Student); // false
```

`instanceof`实际上判断一个变量所指向的实例是否是指定类型，或者这个类型的子类。如果一个引用变量为`null`，那么对任何`instanceof`的判断都为`false`。

利用`instanceof`，在向下转型前可以先判断：

```java
Person p = new Student();
if (p instanceof Student) {
    // 只有判断成功才会向下转型:
    Student s = (Student) p; // 一定会成功
}
```



### 总结

- 继承是面向对象编程的一种强大的代码复用方式；
- Java只允许单继承，所有类最终的根类是`Object`；
- `protected`允许子类访问父类的字段和方法；
- 子类的构造方法可以通过`super()`调用父类的构造方法；
- 可以安全地向上转型为更抽象的类型；
- 可以强制向下转型，最好借助`instanceof`判断；
- 子类和父类的关系是is，has关系不能用继承。



## 多态

在继承关系中，子类如果定义了一个与父类方法签名完全相同的方法，被称为覆写（Override）。

如：

```java
class Person {
    public void run() {
        System.out.println("Person.run");
    }
}
class Student extends Person {
    @Override
    public void run() {
        System.out.println("Student.run");
    }
}
```

Override和Overload不同的是，如果方法签名不同，就是Overload，Overload方法是一个新方法；

如果方法签名相同，并且返回值也相同，就是`Override`。

加上`@Override`可以让编译器帮助检查是否进行了正确的覆写。

>  注意：方法名相同，方法参数相同，但方法返回值不同，也是不同的方法。在Java程序中，出现这种情况，编译器会报错。

Java的实例方法调用是基于运行时的实际类型的动态调用，而非变量的声明类型。这个非常重要的特性在面向对象编程中称之为==多态==。它的英文拼写非常复杂：Polymorphic。

```java
public class overrided_08 {
  public static void main(String[] args) {
    Person08 p = new Student08();
    p.run();
  }
}
class Person08{
  public void run(){
    System.out.println("Person.run");
  }
}
class Student08 extends Person08{
  @Override
  public void run(){
    System.out.println("Student.run");
  }
}
```



==多态==是指，针对某个类型的方法调用，其真正执行的方法取决于运行时期实际类型的方法。

多态这种不确定性的方法调用，究竟有什么作用？

假设我们定义一种收入，需要给它报税，那么先定义一个`Income`类：

```java
public class overrided_08 {
  public static void main(String[] args) {
    Income[] incomes = new Income[] {
        new Income(3000),
        new Salary(7500),
        new StateCouncilSpecialAllowance(15000)
    };
    System.out.println(totalTax(incomes));
  }
  public static double totalTax(Income... incomes) {
    double total = 0;
    for (Income income: incomes) {
      total = total + income.getTax();
    }
    return total;
  }
}
//税收
class Income {
  protected double income;

  public Income(double income) {
    this.income = income;
  }

  public double getTax() {
    return income * 0.1; // 税率10%
  }
}
//减去基数
class Salary extends Income{
  public Salary(double income) {
    super(income);
  }
  @Override
  public double getTax(){
    if (income<=500){
      return 0;
    }else {
      return (income - 5000) * 0.2;// 多于5000部分收20%税率
    }
  }
}
//津贴
class StateCouncilSpecialAllowance extends Income {
  public StateCouncilSpecialAllowance(double income) {
    super(income);
  }
  @Override
  public double getTax() {
    return 0;
  }
}
```

可见，多态具有一个非常强大的功能，就是允许添加更多类型的子类实现功能扩展，却不需要修改基于父类的代码。

### 覆写Object方法

因为所有的`class`最终都继承自`Object`，而`Object`定义了几个重要的方法：

- `toString()`：把instance输出为`String`；
- `equals()`：判断两个instance是否逻辑相等；
- `hashCode()`：计算一个instance的哈希值。

```java
class Person {
    ...
    // 显示更有意义的字符串:
    @Override
    public String toString() {
        return "Person:name=" + name;
    }

    // 比较是否相等:
    @Override
    public boolean equals(Object o) {
        // 当且仅当o为Person类型:
        if (o instanceof Person) {
            Person p = (Person) o;
            // 并且name字段相同时，返回true:
            return this.name.equals(p.name);
        }
        return false;
    }

    // 计算hash:
    @Override
    public int hashCode() {
        return this.name.hashCode();
    }
}
```

### 调用super()

在子类的覆写方法中，如果要调用父类的被覆写的方法，可以通过`super`来调用。

```java
class Person {
    protected String name;
    public String hello() {
        return "Hello, " + name;
    }
}

Student extends Person {
    @Override
    public String hello() {
        // 调用父类的hello()方法:
        return super.hello() + "!";
    }
}
```

### final

继承可以允许子类覆写父类的方法。如果一个父类不允许子类对它的某个方法进行覆写，可以把该方法标记为`final`。

用`final`修饰的方法不能被`Override`

类的实例字段用`final`修饰的字段在初始化后不能被修改,可以在构造方法中初始化final字段

```java
class Person {
    public final String name;
  	public Person(String name) {
        this.name = name;
    }
    public final String hello() {
        return "Hello, " + name;
    }
}

Student extends Person {
    // compile error: 不允许覆写
    @Override
    public String hello() {
    }
}
```

`final`修饰符有多种作用：

- `final`修饰的方法可以阻止被覆写；
- `final`修饰的class可以阻止被继承；
- `final`修饰的field必须在创建对象时初始化，随后不可修改。

## 抽象类

如果父类的方法本身不需要实现任何功能，仅仅是为了定义方法签名，目的是让子类去覆写它，那么，可以把父类的方法声明为抽象方法.

把一个方法声明为`abstract`，表示它是一个抽象方法，本身没有实现任何方法语句。

因为这个抽象方法本身是无法执行的，所以，`Person`类也无法被实例化。必须把`Person`类本身也声明为`abstract`，才能正确编译它

```Java
abstract class Person {
    public abstract void run();
}
```

无法实例化的抽象类有什么用？

因为抽象类本身被设计成只能用于被继承，因此，抽象类可以强迫子类实现其定义的抽象方法，否则编译会报错。因此，**抽象方法实际上相当于定义了“规范”**。

```java
abstract class Person11{
  public abstract void run();
}
class Student11 extends Person11{
  @Override
  public void run(){
    System.out.println("run!run!run!");
  }
}
```

### 面向抽象编程

当我们定义了抽象类`Person`，以及具体的`Student`、`Teacher`子类的时候，我们可以通过抽象类`Person`类型去引用具体的子类的实例，我们对其进行方法调用，并不关心`Person`类型变量的具体子类型。

这种尽量引用高层类型，避免引用实际子类型的方式，称之为面向抽象编程。

面向抽象编程的本质就是：

- 上层代码只定义规范（例如：`abstract class Person`）；
- 不需要子类就可以实现业务逻辑（正常编译）；
- 具体的业务逻辑由不同的子类实现，调用者并不关心。

```java
Person s = new Student();
Person t = new Teacher();
```

### 练习

用抽象类给一个有工资收入和稿费收入的小伙伴算税。

```java
public class abstract_lx_12 {
  public static void main(String[] args) {
    Gzsr gz = new Gzsr(5000);
    Gaof gf = new Gaof(3000);
    System.out.println(gz.getTax());
    System.out.println(gf.getTax());
  }
}
abstract class Inconme{
  protected double income;
  public Inconme(double income){
    this.income = income;
  }
  public abstract double getTax();
}
class Gzsr extends Inconme{
  public Gzsr(double income){
    super(income);
  }
  @Override
  public double getTax(){
    return income * 0.1;
  }
}
class Gaof extends Inconme{
  public Gaof(double income){
    super(income);
  }
  @Override
  public double getTax(){
    return income * 0.05;
  }
}
```

## 接口

在抽象类中，抽象方法本质上是定义接口规范：即规定高层类的接口，从而保证所有子类都有相同的接口实现，如果一个抽象类没有字段，所有方法全部都是抽象方法，就可以把该抽象类改写为接口：`interface`。

```java
abstract class Person {
    public abstract void run();
    public abstract String getName();
}
// 接口
interface Person {
    void run();
    String getName();
}
```

所谓`interface`，就是比抽象类还要抽象的纯抽象接口，因为它连字段都不能有，接口定义的所有方法默认都是`public abstract`，所以这两个修饰符不需要写出来。

```java
interface Person12{
  void run();
  String getName();
}
class Student12 implements Person12{
  private String name;
  public Student12(String name){
    this.name = name;
  }
  public void run(){
    System.out.println("Run "+this.name);
  }
  public String getName(){
    return this.name;
  }
}

```

一个类可以实现多个`interface`

```java
class Student implements Person, Hello { // 实现了两个interface
    ...
}
```

### default 方法

在接口中，可以定义`default`方法。

```java
interface Person12{
  String getName();
  default void run(){
    System.out.println("run"+getName());
  }
}
class Student12 implements Person12{
  private String name;
  public Student12(String name){
    this.name = name;
  }
  public String getName(){
    return this.name;
  }
}
```



### 术语

注意区分术语：

Java的接口特指`interface`的定义，表示一个接口类型和一组方法签名，而编程接口泛指接口规范，如方法签名，数据格式，网络协议等

抽象类和接口的对比如下：

|            | abstract class       | interface                   |
| :--------- | :------------------- | :-------------------------- |
| 继承       | 只能extends一个class | 可以implements多个interface |
| 字段       | 可以定义实例字段     | 不能定义实例字段            |
| 抽象方法   | 可以定义抽象方法     | 可以定义抽象方法            |
| 非抽象方法 | 可以定义非抽象方法   | 可以定义default方法         |

### 接口继承

一个`interface`可以继承自另一个`interface`。`interface`继承自`interface`使用`extends`，它相当于扩展了接口的方法。

```java
interface Hello{
  void hello();
}
interface Person extends Hello{
  void run();
  String getName();
}
```

公共逻辑适合放在`abstract class`中，具体逻辑放到各个子类，而接口层次代表抽象程度。可以参考Java的集合类定义的一组接口、抽象类以及具体子类的继承关系：

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070859072.png)

## 静态字段和静态方法

### 静态字段

在一个`class`中定义的字段，我们称之为实例字段。

用`static`修饰的字段，称为静态字段：`static field`。

实例字段在每个实例中都有自己的一个独立“空间”，但是静态字段只有一个共享“空间”，所有实例都会共享该字段。

```java
public class static_13 {
  public static void main(String[] args) {
    Person13 p = new Person13("小明",21);
    Person13 p2 = new Person13("小红",20);
    p.number = 88;
    System.out.println(p2.number);
    p2.number = 66;
    System.out.println(p.number);
  }
}
class Person13{
  public String name;
  public int age;
  public static int number;
  public Person13(String name,int age){
    this.name = name;
    this.age = age;
  }
}
```

对于静态字段，无论修改哪个实例的静态字段，效果都是一样的：所有实例的静态字段都被修改了，原因是静态字段并不属于实例

![](https://cdn.jsdelivr.net/gh/K8963/Imageshack@main/blog/202209070915600.png)

推荐用类名来访问静态字段。可以把静态字段理解为描述`class`本身的字段（非实例字段）。

```java
Person.number = 99;
System.out.println(Person.number);
```

### 静态方法

用`static`修饰的方法称为静态方法。

调用实例方法必须通过一个实例变量，而调用静态方法则不需要实例变量，通过类名就可以调用。

```java
public class Main {
    public static void main(String[] args) {
        Person.setNumber(99);
        System.out.println(Person.number);
    }
}

class Person {
    public static int number;

    public static void setNumber(int value) {
        number = value;
    }
}
```

静态方法属于`class`而不属于实例，因此，静态方法内部，无法访问`this`变量，也无法访问实例字段，它只能访问静态字段。

静态方法经常用于工具类。例如：

- Arrays.sort()
- Math.random()

静态方法也经常用于辅助方法。注意到Java程序的入口`main()`也是静态方法。

### 接口的静态字段

因为`interface`是一个纯抽象类，所以它不能定义实例字段。但是，`interface`是可以有静态字段的，并且静态字段必须为`final`类型

```java
public interface Person {
    public static final int MALE = 1;
    public static final int FEMALE = 2;
}
// 简写
public interface Person {
    // 编译器会自动加上public statc final:
    int MALE = 1;
    int FEMALE = 2;
}
```



## 包

在Java中使用`package`来解决名字冲突。

Java定义了一种名字空间，称之为包：`package`。一个类总是属于某个包，类名（比如`Person`）只是一个简写，真正的完整类名是`包名.类名`。

没有定义包名的`class`，它使用的是默认包，非常容易引起名字冲突

> 注意：包没有父子关系。java.util和java.util.zip是不同的包，两者没有任何继承关系。

### 包作用域

位于同一个包的类，可以访问包作用域的字段和方法。不用`public`、`protected`、`private`修饰的字段和方法就是包作用域

`Person`类定义在`hello`包下面：

```java
package hello;

public class Main {
    public static void main(String[] args) {
        Person p = new Person();
        p.hello(); // 可以调用，因为Main和Person在同一个包
    }
}

public class Person {
    // 包作用域:
    void hello() {
        System.out.println("Hello!");
    }
}
```

### import

在一个`class`中，我们总会引用其他的`class`。

在写`import`的时候，可以使用`*`，表示把这个包下面的所有`class`都导入进来（但不包括子包的`class`）

`import static`的语法，它可以导入可以导入一个类的静态字段和静态方法：

Java编译器最终编译出的`.class`文件只使用*完整类名*，因此，在代码中，当编译器遇到一个`class`名称时：

- 如果是完整类名，就直接根据完整类名查找这个`class`；
- 如果是简单类名，按下面的顺序依次查找：
  - 查找当前`package`是否存在这个`class`；
  - 查找`import`的包是否包含这个`class`；
  - 查找`java.lang`包是否包含这个`class`。

如果按照上面的规则还无法确定类名，则编译报错。

如果有两个`class`名称相同，例如，`mr.jun.Arrays`和`java.util.Arrays`，那么只能`import`其中一个，另一个必须写完整类名。

### 小结

Java内建的`package`机制是为了避免`class`命名冲突；

JDK的核心类使用`java.lang`包，编译器会自动导入；

JDK的其它常用类定义在`java.util.*`，`java.math.*`，`java.text.*`，……；

包名推荐使用倒置的域名，例如`org.apache`。



## 作用域

我们经常看到`public`、`protected`、`private`这些修饰符。在Java中，这些修饰符可以用来限定访问作用域。

**public**

定义为`public`的`class`、`interface`可以被其他任何类访问：

**private**

定义为`private`的`field`、`method`无法被其他类访问

`private`访问权限被限定在`class`的内部，而且与方法声明顺序无关，建议把`private`的声明放到最后。

由于Java支持嵌套类，如果一个类内部还定义了嵌套类，那么，嵌套类拥有访问`private`的权限。

**protected**

`protected`作用于继承关系。定义为`protected`的字段和方法可以被子类访问，以及子类的子类。

包作用域是指一个类允许访问同一个`package`的没有`public`、`private`修饰的`class`，以及没有`public`、`protected`、`private`修饰的字段和方法。

```java
package abc;
// package权限的类:
class Hello {
    // package权限的方法:
    void hi() {
    }
}
```

只要在同一个包，就可以访问`package`权限的`class`、`field`和`method`

### 局部变量

在方法内部定义的变量称为局部变量，局部变量作用域从变量声明处开始到对应的块结束。方法参数也是局部变量。

### final

Java还提供了一个`final`修饰符。`final`与访问权限不冲突

- 用`final`修饰`class`可以阻止被继承
- 用`final`修饰`method`可以阻止被子类覆写
- 用`final`修饰`field`可以阻止被重新赋值
- 用`final`修饰局部变量可以阻止被重新赋值

### 最佳实践

如果不确定是否需要`public`，就不声明为`public`，即尽可能少地暴露对外的字段和方法。

把方法定义为`package`权限有助于测试，因为测试类和被测试类只要位于同一个`package`，测试代码就可以访问被测试类的`package`权限方法。

一个`.java`文件只能包含一个`public`类，但可以包含多个非`public`类。如果有`public`类，文件名必须和`public`类的名字相同。

### 小结

Java内建的访问权限包括`public`、`protected`、`private`和`package`权限；

Java在方法内部定义的变量是局部变量，局部变量的作用域从变量声明开始，到一个块结束；

`final`修饰符不是访问权限，它可以修饰`class`、`field`和`method`；

一个`.java`文件只能包含一个`public`类，但可以包含多个非`public`类。

## 内部类

被定义在另一个类的内部，所以称为内部类（Nested Class）。Java的内部类分为好几种

### Inner Class 

一个类定义在另一个类的内部，这个类就是Inner Class

```
class Outer {
    class Inner {
        // 定义了一个Inner Class
    }
}
```

与普通类有个最大的不同，就是Inner Class的实例不能单独存在，必须依附于一个Outer Class的实例

```java
public static void main(String[] args) {
    Outer o = new Outer("小明");
    Outer.Inner inner = o.new Inner();
    inner.hello();
}
```

Inner Class还可以修改Outer Class的`private`字段

### Anonymous Class

还有一种定义Inner Class的方法，它不需要在Outer Class中明确地定义这个Class，而是在方法内部，通过匿名类（Anonymous Class）来定义。