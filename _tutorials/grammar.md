---
layout: post
title: 语法补充
nav_order: 16
---

## exit 语句

我们在之前学到了三种能够中断部分代码执行的语句：

* `continue` 中断循环的一次执行。
* `break` 中断整个循环的执行。
* `return` 中断整个脚本的执行，并且给出返回值。

**exit** 既可以写在脚本里，也可以写在对象的事件里。如果写在脚本里，它的意义是**中断脚本**，相当于一个劣质的 return，因为 exit 不能返回一个值。如果写在事件里，它的意义是**中断当前代码框的执行**。*注意，exit 只退出一个代码框而不是整个事件，当前事件的其他代码框还会正常执行。*

## 父对

在[杀死玩家，记录死亡数]({{ site.baseurl }}{% link _tutorials/make_your_game/data.md %}#杀死玩家记录死亡数)中，我们提到了父对的作用之一，那就是对象会**响应父对的被碰撞检测**。这个被碰撞检测可以是碰撞事件或者碰撞检测函数。

现在，我们来学习一下父对的完整作用。

其一、**继承父对有，而自身没有的事件**。比如，父对有 step 事件，而对象自身没有，那么对象会使用父对的 step 事件作为自己的 step 事件。而如果对象自身也有 step 事件，那就不会使用父对的 step 事件。

其二、**成为父对的实例**。具体来说：

1. **响应父对的成员运算符操作**。例如，对象 objSlipBlock 的父对为 blockParent，那么在调用 `blockParent.speed = 5;` 时，对象 objSlipBlock 的实例也会响应这个调用，从而执行 `speed = 5;`.
2. **响应父对的 with 结构**。例如，对象 objSlipBlock 的父对为 blockParent，那么在调用`with (blockParent){}`时，对象 objSlipBlock 的实例也会响应这个 with 从而执行其中的代码。
3. **响应父对的被碰撞事件以及被碰撞函数检测**。这在[杀死玩家，记录死亡数]({{ site.baseurl }}{% link _tutorials/make_your_game/data.md %}#杀死玩家记录死亡数)中已经讲解过。
4. **会被 `instance_number(父对)` 以及其他与实例相关的函数所统计**。

## break 与 with

break 语句除了中断循环和 switch 以外，还有一个我们没有提到过的功能：**中断 with 结构**。如：

```c
with (objBow)
{
    if (other.x > 400) break;
    image_xscale = -1;
}
```

如果 `other.x > 400` 成立，那么执行 break 跳出 with，不会执行后面的 `image_xscale = -1;`。break 在 with 结构中**几乎不使用**，请参考下一小节理解。

## continue 与 with

continue 在 with 中的作用为**跳到下一个实例**。

怎么理解呢？例如：

```c
with (objBow)
{
    move_towards_point(other.x, other.y, 5);
    if (x > 400) continue;
    image_xscale = -1;
}
```

这会让所有 objBow 的实例朝着执行 with 的那个实例运动，并且所有不满足 `x > 400`，即 `x <= 400` 的 objBow 的实例都执行 `image_xsacle = -1;`。

等等，这和 break 有啥区别？如果我改成：

```c
with (objBow)
{
    move_towards_point(other.x, other.y, 5);
    if (x > 400) break;
    image_xscale = -1;
}
```

会怎么样？答案：如果使用的是 break，那么只有一部分甚至可能没有一个 objBow 的实例会运动，部分 objBow 的实例仍然停留在原地不动。这是为什么呢？

我们知道，每一个对象的实例都有自己独有的 **id** 值。GM 只能一条条地执行代码，所以不能同时把 objBow 的所有实例都设置为 `move_towards_point(other.x, other.y, 5);`，它必然是一个一个实例地按顺序实现的。

为了好理解，我们现在*假设*所有 objBow 的实例的 id 是连续的，是从 1000200 到 1000299 的 100 个 id 值。那么，with (objBow) 的结构实际上等效于：

```c
for (i = 1000200;i <= 1000299;i += 1)
{
    with (i)
    {
        move_towards_point(other.x, other.y, 5);
    }

    if (i.x > 400) continue;     // 或者 if (i.x > 400) break;

    with (i)
    {
        image_xscale = -1;
    }
}
```

当然，实际上 objBow 的实例 id 不可能刚好是全部连续的，但是没有关系，with 结构会自动寻找正确的 id 值。

看到这个熟悉的 for 结构，是不是感觉 break 和 continue 对于 with 的关系就一目了然了呢？

假设从 1000200 到 1000219，这 20 个实例的 x 都小于等于 400，那么这 20 个实例都会执行 `image_xscale = -1;`。之后假设 i 到 1000220 时，`i.x > 400` 第一次成立。如果使用 `continue`，那么跳过本次 `image_xscale = -1;`，然后 i 继续增大到 1000221，继续循环。最后结果是，所有 objBow 的实例都向执行 with 的这个实例运动，并且其中 `x <= 400` 的实例会翻转自己的左右。

但是，如果使用的是 `break`，那么循环就会立刻被中断，直接跳出循环，所以 id 为 1000221 到 1000299 的这一段实例，并没有接受到任何指令，所以既不会运动，也不会改变 `image_xscale`，最后的结果是，这 100 个实例只有 21 个正常运动，79 个在原地不动。

这就是 break 和 continue 的区别。基于这个特性，with 中可以看到使用 continue，但是几乎从来不会出现 break。
