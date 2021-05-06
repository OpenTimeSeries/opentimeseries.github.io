---
layout: default
title: Debug技巧
nav_order: 4
---

当我们的游戏报错了，或者游戏运行的实际效果出现了不符合我们的设想的情况，这种代码上的缺陷我们称之为**bug**。而**调试**（debug）就是指发现，定位，解决bug的过程。

很遗憾的是，*编程语言并非AI*，他无法参透使用者的意图，几乎不可能给出准确的bug原因。但是，任何一个IDE，都或多或少提供了一些调试信息和调试手段，这将是我们定位和解决bug的重要途径。

# 看懂报错

如果我们的游戏出现了代码上的逻辑错误，例如非法的语法，不正确的参数量等，GM8就会给我们一个**Error Messages**，例如：

![Error Messages](/assets/images/debug/error_messages.png)

```
ERROR in
action number 2
of Create Event
for object objTest:

Error in code at line 2:
   if(a == b)
           ^
at position 10: Cannot compare arguments.
```

我们来一点一点地分析这个报错：

1. 第四行“for object **objTest**”告诉我们，错误发生在对象objTest中。
2. 第三行“of **Create** Event”进一步定位到objTest的创建事件。
3. 第二行"action number **2**"表示出错的是第二个代码段：

    ![Code](/assets/images/debug/code.png)

4. 第六行“Error in code at line **2**”告诉我们，出错的代码是在第2行：

    ![Line](/assets/images/debug/line.png)

5. 第七行`if(a == b)`是告诉我们出错的代码。
6. 第八行有个`^`，他指示了错误发生的位置。
7. 第九行的前半段“at position **10**”和`^`作用相同，告诉我们错误发生的位置是从左数第10个字符处。注意空格也算字符。
8. 第九行的后半段指示了错误发生的原因。在本例中，错误原因是“**Cannot compare arguments**”，这个错误的发生原因是判等的两边类型不同，即a和b中有一个是实数，有一个是字符串，二者无法比较，因此会报此错误。

# 一些令人摸不着头脑的报错

## 位于事件Trigger Event: \<Deleted\>

![Trigger](/assets/images/debug/trigger.png)

这是GM8本身的一个bug，所谓的Trigger Event: \<Deleted\>其实是**ICC**（instance creation code）或者**RCC**（room creation code）。

## Error defining an external function

![External](/assets/images/debug/external.png)

这是指的是`external_define`这个函数执行失败了。要么就是exe目录下缺少了dll，要么就是`external_define`定义的函数与dll内实际函数不同。

## Unexpected error occured when running the game

![Unexpected](/assets/images/debug/unexpected.png)

这种已经不是报错了，而是游戏崩溃了。通常来说，游戏崩溃的原因可能是使用了一个非常大的整数，超出了GM8能承受的界限。或者游戏使用了一张非常大的图像，导致游戏运行时没能成功加载图像。

# 了解调试信息窗口

通常，我们面临第二种bug，即游戏运行的实际效果不符合设想的情况要远远多于报错的情况，并且调试难度高不少。要寻找代码可能出现问题的位置，我们需要学会如何使用调试信息窗口。

![Debug Information](/assets/images/debug/debug_information.png)

首先来看到最下方状态栏的`50 fps | 168 inst | mouse id: 100354`，`50 fps`指的是游戏当前运行帧率为50帧，`168 inst`指的是当前房间内一共有168个实例，`mouse id: 100354`指的是鼠标位置上的实例的id为100354。

其次我们来看窗口的主体部分，是一个监控表达式的列表。“Expression”是要监控的表达式，“Value”是该表达式当前步的值。你可以点击右上角的加号新增表达式，点击循环符号修改当前表达式，点击叉号删除当前表达式，最后一个按钮会清空监控列表。要注意的一个事实是，任意一个可以计算出值的表达式都可以作为“Expression”。它可以是一个变量，比如`global.frozen`；也可以是一个算式，比如`12+5`；也可以是个函数，比如`power(2, 4)`，等等。另外，也可以通过鼠标寻找一个实例的id，然后使用`(id).x`来监控特定实例的变量。

再来看到左边的那些按钮，它们分别是继续游戏，暂停游戏，向前一步，重启游戏，结束游戏。通过**暂停游戏+向前一步**，我们可以仔细地观察游戏每一步的状态。

最后，来看到Tools下提供的工具：

![Tools](/assets/images/debug/tools.png)

## Execute Code

立刻执行一段代码。这是一个非常好用的功能，能够随时随地执行任意代码，如果有语法错误，只是提示“Compile Error”，并不会终止游戏。

这里介绍给大家一种很好用的思路：

如果我们想知道实例inst1是否与另一个实例inst2发生了碰撞，我们想要监控`place_meeting(x, y, inst2)`是不可能的，监控列表并不知道这个函数要交给谁来执行。因此一种实现方式是，通过Execute Code执行`with(inst1)isCollided = place_meeting(x, y, inst2);`，然后再监控`inst1.isCollided`即可。不过缺陷是不会自动刷新，需要再次Execute Code才会刷新值，因此更适合暂停游戏下使用。当然，这里只是提供一种可行的思路，希望各位能举一反三，发掘出更多用途。

## Set Speed

设置游戏运行帧率。

## Show Global Variables

显示所有的全局变量及其值。

## Show Local Varivales

显示某个实例所有的变量及其值。

## Show Instances

显示所有实例的id及其对象名。

## Show Messages

如果你在代码中使用`show_debug_message(str)`，那么str就会出现在Show Messages打开的窗口中。与`show_messages(str)`不同，`show_debug_message(str)`不会主动弹窗阻拦游戏进程，因此更适合debug下使用。

# if(debug_mode)

`debug_mode`是GM8内置的常量，它在Debug模式下为true，在普通游戏时为false。因此我们可以通过`if(debug_mode)`增加许多调试工具，例如无敌模式，无限跳跃，鼠标移动角色位置，绘制判定域，等等，任何可能有助于调试的代码都可以考虑加在`if(debug_mode)`下，未来发布的时候也不用删除，直接发布就行，玩家那边是不会触发的。

# 注释调试法

当你无法定位一个bug的所在位置时，最好的办法莫过于注释调试法。即将大部分代码都注释掉，仅留下一部分代码，运行检测其正确性，如果没问题，就从注释中解除一部分代码，继续测试其正确性，以此类推，直到找到不正确的位置。

# 资源重名

资源重名会引起串位，我们知道，GM8中任何资源名其本质就是一个整数，如果一个精灵和一个对象重名，那么在`instance_create`时，传递给函数的很可能就是精灵的索引而不是对象的索引，这样`instance_create`就会去找另一个相同索引的对象，造成一些莫名其妙的bug。要检测工程内是否有重名资源，可以使用**脚本**->**检查资源名称**。

![Scripts](/assets/images/debug/scripts.png)

资源重名还有另一种情况，就是**资源名和变量名重名**。由于资源名有绝对的优先级，因此GM8不会将其视为变量。不过这个bug很好找，资源名都是黄色的，你看到变量里有个黄色的变量那肯定是重名了。

# 未初始化

我们知道，资源索引都是从0开始的。而GM8提供一个功能，将未初始化的变量赋值为0，他可以关闭，但是由于GM8的设计缺陷我们很难不使用这个功能。

由此会引发另一种看起来很莫名其妙的bug。假如你代码中有类似于：`speed = inst.speed`，但是此时实例并没有初始化inst这个值，那么GM8会给inst赋值为0，这句代码就成了`speed = (0).speed`，也就是将索引为0的对象的速度赋值到当前实例的速度，再比如`sprite_index = spr`，但是spr未初始化，那么实例就会以索引为0的精灵作为其精灵。当然，不仅仅是赋值，任何一个使用资源索引的地方都可能会出现这个问题。通常，我们不会不去初始化一个变量，但是我们可能会被GM8的事件顺序坑，也就是我们原本以为是赋值再调用，但是GM8实际的运行逻辑可能就是先调用再赋值了。

# 良好的编程习惯

[良好的编程习惯]({{ site.baseurl }}{% link _extensions/programming.md %})一方面（缩进，换行，空格等）有助于提高代码的阅读性，让你能快速看懂每个部分是在做什么，另一方面（高内聚，低耦合等）有助于快速定位bug的所在位置。
