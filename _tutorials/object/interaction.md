---
layout: default
title: 对象间的交流
nav_order: 1
parent: 对象
---

# 成员运算符

两个对象之间要如何实现数据的交流？方法之一就是使用成员运算符`.`。对的，就是一个小数点。他可以在一个对象里使用/改变另一个对象的变量。

例如，在[上一个例子]({{ site.baseurl }}{% link _tutorials/object/object.md %}#对象实例的创建)中，我们如何做到不把代码`speed = 6;`写在objBullet里，而是用objControl来控制objBullet的速度？

只要在objControl的alarm0（计时器0）事件中加上`objBullet.speed = 6;`即可。这句代码要放在`instance_create(100, 200, objBullet);`的后面，至于放在`alarm[0] = 50;`的前面还是后面可以随意。

## 进阶：对单个实例的数据交流

以`对象名.变量名`的形式进行数据交流时，如果此时房间中有多个该对象的实例，譬如上一个例子中，房间中有多个objBullet的实例，`objBullet.speed = 6;`实际上是对所有的objBullet的实例发出了指令。而如果以`spd = objBullet.speed;`来获取数据的话，获得的是游戏中现存的最早被创造的那个objBullet的实例的speed。

在我们的例子中，由于所有objBullet的speed都是6，所以直接`objBullet.speed = 6;`没有问题。

但是现在，我们想要在创建每一个objBullet的实例时，都给它一个随机的2~8的速度，而不是固定的6。

 如果通过`objBullet.speed = random_range(2, 8);`，经过测试，你会发现，每次创建新的实例时，其他已经存在的objBullet的实例的速度也会发生改变——因为他们都是objBullet，所以都会受到`objBullet.speed = random_range(2, 8);`的影响。

 所以要把alarm0事件的代码改成：

```c
inst = instance_create(100, 200, objBullet);
inst.speed = random_range(2, 8);
alarm[0] = 50;
```

通过变量inst来储存最新创建的objBullet的索引，并且对inst发出指令，这样一来，每次执行alarm0事件只会改变最新创建的那个实例的speed。

原理：

在游戏运行时，所有的实例都会被系统分配一个独一无二的**索引（ID，Index）**，譬如屏幕里有四个objBullet，但是他们的索引都各不相同，可能分别是1000001,1000002,1000003,1000004（随便写的），但是实际上游戏运行的时候一个实例究竟被分配哪个索引，我们很难预料，所以一般更多的利用`instance_create`函数会返回被创建的实例的索引的特性，使用一个变量来储存这个新实例的索引。由于索引可以用在成员运算符中，所以就可以对单个实例的变量进行访问/修改。

由于instance_create()函数直接返回实例的索引，所以上述例子可以直接写成：

```c
(instance_create(100, 200, objBullet)).speed = random_range(2,8);    //函数instance_create一定要用括号括起来
```

从而不使用变量去储存索引也是可以的。但是这样每个新的实例就只能被改变一个值了（可用with解决）。

*PS：同一个对象的不同实例之间也可以使用索引互相控制。*

在布置房间时，把鼠标放在一个实例上，状态栏会显示它的索引。

![Index](/assets/images/object/index.png)

在已知索引的情况下，我们也可以直接使用索引来访问/修改这个实例的变量。

例如，上图中实例的索引为100012，我们让别的对象/实例改变它的速度，就可以写：

```c
(100012).speed = 12;    //注意索引一定要用括号括起来
```

# with语句

如果我们不只是想让对象/实例之间进行数据的交流，而是想让某个对象/实例命令另一个对象/实例执行一个函数或者一段代码呢？

```c
with(obj/ID)
{
    xxxx;
    xxxxx;
}
```

作用是让括号里的对象/实例执行花括号里的代码。和[if]({{ site.baseurl }}{% link _tutorials/logic/condition.md %}#if语句)一样，如果只有一个语句可以不用花括号，形如：

```c
with(obj/ID)
    xxxxx;
```

像if, while, for, with等这类在花括号里的语句只有一句时，可以不写花括号。但是究竟是写在同一行里：

```c
if(xxx)xxxx;
```

还是分开两行写：

```c
if(xxx)
    xxxx;
```

这个纯靠个人习惯。一般而言，整个语句较短就写同一行比较清晰，如：

```c
if(x == y) z = x;
```

比较长就分开写比较清晰，如：

```c
if(objBlock.x < view_xview || objBlock.y < view_yview || move == 0)
    instance_create(view_xview + 100, view_yview + 100, objBlockSlip);
```

原则上怎么写更适合阅读就怎么写。

for()语句通常不会写在同一行（因为for(xx1; xx2; xx3)本身就包含了三个语句，比较长）。

---

注意：假设只有一个objA的实例和一个objB的实例。若在objA里写`objB.xx = yy;`，这个yy是**objA的yy**；若在objA里写`with(objB) xx = yy;`，这个yy则是**objB的yy**，等效于`objB.xx = objB.yy;`。如果要在`with(objB) {xxxxx;}`的花括号里使用objA的值，得用`objA.yy`来调用。

但是有时候事情并没有这么简单。

举个例子，屏幕里面有很多个objA的实例，每一个实例的yy的值都不一样。这时候其中一个objA的实例创建了一个objB的实例（即`inst = instance_create(x, y, objB);`，用变量inst储存了这个objB的实例的索引），并且想在`with(inst) {xxxxx;}`里面使用自己的yy而不是其它objA的yy，要怎么做？

GML中提供了关键字**other**来处理这个问题。只要在with里写`other.yy`：

```c
with(inst)
{
    xx = other.yy;
}
```

这里的`other.yy`就会准确无误地调用创建了objB的那个objA的实例的yy。

---

提示：with和成员运算符可以混着用。例如：

```c
inst = instance_create(此处省略...);
inst.speed = 6;
with(inst)
{
    xx = 15;
    inst = instace_create(此处省略...);   //此处的inst和上面的inst不是同一个
}
inst.yy = 6;
```

---

提示：`instance_create`函数的返回值可以作为成员运算符的前缀，那么也自然可以直接作为with的参数：

```c
with(instance_create(x, y, obj))
{
    xxx;
}
```

---

提示：以对象作为成员运算符的前缀时，若该对象的实例数量大于1，则严禁自增自减，即严禁出现下面的情况：

```c
objFruit.x = objFruit.x + 12;
```

或

```c
objFruit.x += 12;
```

一定要写成with结构：

```c
with(objFruit) x += 12;
```

在GML文档第15页有介绍，其原因是：
> GM中以对象作为成员运算符的前缀来调用它的某个变量时，一律调用该对象ID最小的那个实例的变量。

例如，objFruit有三个实例，ID分别是100315，100368，100396，他们的x分别是100，200，300，在执行了`objFruit.x = objFruit.x + 12;`之后，三个objFruit都会跳到x为112的位置，因为ID100315最小，它的x值100会被作为`objFruit.x`的值被调用。而`objFruit.x += 12;`仅仅只是`objFruit.x = objFruit.x + 12;`的缩写而已，并不会导致结果不同。

# 全局变量

全局(global)，即指整个游戏，或者说整个程序。

我们在对象中使用的变量叫做**局部变量(local variables)**，因为局部变量是属于单个实例的，一旦销毁了一个实例（`instance_destroy()`、房间结束、游戏结束等），这个实例的所有变量也会销毁。当从一个房间跳到另一个房间时（`room_goto(房间名);`），或者用`room_restart();`重新开始这个房间，原本的房间就会结束，它的所有实例都会被销毁（除了勾选“保持”的对象的实例。参考[浅谈对象]({{ site.baseurl }}{% link _tutorials/start/object.md %}#面板介绍)）。

而**全局变量(global variables)**，不属于某一个实例，而是属于整个游戏的，不会因为实例的销毁或者房间的结束而销毁。基于这个特性，全局变量可以用于对象/实例之间的数据交流，尤其是**跨房间的数据交流**。

## global

以`global.xx`的形式的变量即是全局变量，小数点是成员运算符，表示这个变量是属于global的。使用方法和正常的变量几乎没有区别，任何一个对象/实例可以访问/改变改变全局变量。

扩展：`global`可以视作是一个特殊的实例，它的索引是-5。即，你可以使用(-5).xxx来调用全局变量。但是with(global)或者with(-5)是不行的，因为global本身不能执行代码。

## globalvar

此方法为全局变量的声明式写法。如果无法理解，请跳过，和global并没有本质上的区别。

什么叫做“声明”？

即通过形如`globalvar 变量名1, 变量名2, 变量名3;`这种形式，在一个变量被使用之前，先把变量名写在`globalvar`的后面陈述一遍。

globalvar声明全局变量的特点是：变量只需要声明一次，一旦声明不需要前缀即可调用。

即，在游戏开始时某个地方写了`globalvar tempx;`之后，就可以在任意地方像

```c
x = tempx;
tempx = 3;
```

这样，不写`global.`这个前缀就可以使用tempx这个全局变量。

在声明过`globalvar val;`之后在对象/实例里使用val都是使用的全局变量，但是如果要想再定义一个对象的局部变量val怎么办呢？利用GM自带的关键字`self`来表示局部变量。

一般情况下，局部变量val，直接写`val`和写作`self.val`是等效的，所以一般不写`self.`。但是在globalvar声明了val的情况下，就必须要用`self.val`来表示局部变量。

为了避免意外的bug，不应当出现变量名字冲突的情况，全局变量应当使用一些特殊的命名方式以避免覆盖掉局部变量。比如，把用globalver方法声明的变量全写**大写字母**。

注意：`global.`和`globalvar`是单向互通的。即：

```c
globalvar NEXT;
NEXT = 3;
global.NEXT = 5;
show_message(string(NEXT) + " " + string(global.NEXT));
```

输出：5 5。即`NEXT`和`global.NEXT`是同一个变量。

但是在只声明`global.NEXT`的情况下并不能使用`NEXT`作为globalvar的变量。这也就是所谓的单向互通，只有`global.`共享`globalvar`的变量，而`globalvar`并不共享`global.`的变量。

## 临时全局变量：var

这个var正是[脚本]({{ site.baseurl }}{% link _tutorials/function/script.md %})一节的var。

var也是变量的声明式写法，和globalvar一样是以`var 变量名1,变量名2;`的方法声明变量的。声明之后，就可以直接用变量名1和变量名2，而不用加什么前缀。

使用var声明的变量有两个特点：

一是**全局性**，即声明变量之后所有实例/对象都可以使用它（们），不需要任何前缀，和globalvar一样。

二是**临时性**，即声明的变量并不是一直存在，而是只有很短的生存期间。

var的生存期间有多短？就是从被声明开始到该代码段结束为止。说直白点，就是一个代码框的代码执行完毕，就销毁其中的var变量。

var变量生存期间那么短，如何体现它的**全局性**？一般还是在with语句体现地比较多：

```c
var count;
for(count = 0; count < 360; count += 20)
    with(instance_create(200, 200, objBullet))
    {
        speed = 6;
        direction = count;    //速度的方向，即运动方向，0为右，90为上，180为左，270为下
    }
```

这个代码可以自己去执行一下试试，是一个由objBullet组成的扩散圆。

在这里由于count只用一次，不需要一直留着，为了节省内存就声明为var变量，在这段代码结束后就会自动销毁count。新建的objBullet需要count的值作为自己的运动方向，却不是访问`other.count`而是访问`count`，这里体现出了var的全局性。
