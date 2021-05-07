---
layout: default
title: 代码
nav_order: 2
parent: 对象
---

# 代码框

## 搜索与替换

![Search And Replace](/assets/images/object/search_and_replace1.png)

![Search And Replace](/assets/images/object/search_and_replace2.png)

## 信息与状态

![Status](/assets/images/object/status.png)

行号为红色时，表示该行代码有误，无法通过编译。状态栏第一行表示错误的情况。

状态栏第二行：

* `10/10：17`，第一个 10 表示光标在第 10 行，第二个 10 表示一共有 10 行，17 表示光标在该行的第 17 个字符位置。
* `INS` 表示当前处于插入模式。按下键盘上的 ins 键（或 insert 键）改为覆盖模式（`OVR`）,光标变成方块状，输入字符会覆盖光标所在的字符。
* `Modified` 表示代码被修改过。
* `10pt` 表示代码框的字体大小。你可以通过按 F7 和 F8 来缩小/增大字体大小。
* `instance_create(x,y,obj)` 是提示第十行的 `instance_create()` 函数所需要的参数。（因为光标停在 `instance_create()` 的括号里。同理在同一行有很多函数时，停在谁的括号里就提示谁的参数）

补图：覆盖模式(OVR)

字母i上的黑色方块就是覆盖模式的光标，输入字符会直接取代i。

![Overlay](/assets/images/object/overlay.png)

## 应用对象

![Target](/assets/images/object/target.png)

应用对象默认为自己（self），即代码是自身执行的。

其他（other）在碰撞事件中起作用，等效于 `with(other){xxxxx;}`，暂且不讲。

应用到对象即把这个代码框的所有代码都交由指定的 obj 执行，等效于 `with(obj){xxxxx;}`;

# 注释

**注释（Comment）**指的是不被程序执行，而是用来解释某段代码功能或用法的语句。

![Comment](/assets/images/object/comment.png)

图中所有绿色的语句都属于注释。

从图中可以看出，注释就是一句或者多句用来解释变量用途、代码段用途的话，便于自己或者他人快速看懂代码。

---

注释方法：单行注释（`//`）

该方法即是上图例子中的注释方法，即在注释语句的最前面写上**双斜杠**。双斜杠的作用范围只有一行，不会影响到下一行代码的运行。

双斜杠不一定要写在一行的开头，例如：

![Line Comment](/assets/images/object/line_comment.png)

---

注释方法：多行注释（`/*  */`）

该方法是将注释内容写在 `/*` 和 `*/` 的中间，并且可以跨行注释，例如：

![Block Comment](/assets/images/object/block_comment.png)

注释调试法是 debug 时经常使用的一种方法。假如你写了一长段代码，但是出错了，没有达到想要的结果。这时候你可以把一部分代码添加 `/*  */` 变成注释，这样它们就不会执行，只留下一部分代码进行检测。如果执行的那一部分没有问题，就换一部分检测。
