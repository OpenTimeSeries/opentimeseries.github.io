---
layout: default
title: 脚本
nav_order: 2
parent: 函数
---

在GM中，**脚本（Scripts）**的实质是自定义的函数。

![Script](/assets/images/function/script.png)

一个脚本的形式一般为：

```c
{
    var _num1, _num2;
    _num1 = argument0 + argument1;
    _num2 = argument2;
    return _num1 * _num2;
}
```

1. 首尾最好有花括号。但实际上没有也不会有什么问题。事实上也有人建议 objects 里的代码段也要前后各一个花括号。喜欢写就写，不喜欢写就不写。
2. 第一行在 var 后写一遍脚本中用到的所有变量（代表这些变量是临时变量，脚本执行完毕后，变量将自动销毁），不同变量名用逗号隔开。最后必须以分号结尾，否则会报错。
3. 所使用的变量名以下划线开头，或者全部使用大写字母。（避免命名冲突）
4. 通过 argument 来传递参数。例如，一个脚本，名字叫做 AddFourNumber，以 `sum = AddFourNumber(12, 25, 44, 37);`（自定义函数的用法和 GM 自带的函数一致）调用这个脚本时，Add 的四个参数，12, 25, 44, 37，我们在脚本里就得用 argument 来获取，第一个参数为 argument0，第二个参数为 argument1，以此类推。注意第一个参数是 argument0，并且即使只有一个参数也要写 argument0 而不能写 argument。
5. 通过 return 来返回一个值，这个值即是这个脚本的返回值。
6. 脚本中允许直接使用对象的变量，而不通过 argument 传递（使用的对象的变量不用写在 var 后），但是这样有很大的隐患，因为脚本可以被任何对象使用，但是并不能保证所有的对象都有这个变量。所以除非是专门给某个特定对象使用的脚本，不应当使用脚本外部的变量。

示例：

写一个脚本 VectorValue，以 `VectorValue(x1, y1, x2, y2)` 的使用方法来计算并返回两个向量 (x1, y1) 和 (x2, y2) 的积。

```c
{
    var _product_x, _product_y;
    _product_x = argument0 * argument2;
    _product_y = argument1 * argument3;
    return _product_x + _product_y;
}
```

如果这样调用：

```c
xx = 5;
yy = 6;
ans = VectorValue(xx, yy, 7, 2);
```

这里 ans 就会被赋予向量 (5, 6) 和 (7, 2) 的向量积 47。

当然其实脚本只要一句话，写成 `return argument0 * argument2 + argument1 * argument3;` 就可以实现的，在这里我只是为了写一个例子。

*注意：return 语句不仅代表返回一个值，也代表着函数的结束，只要执行到了 return 语句，不管 return 语句后面还有什么代码，都不会被执行。*

一个脚本可以不接受参数，也可以没有 return 语句（即没有返回值）。但是没有返回值的脚本不能用于赋值，或者运算。

脚本的命名规则一般以自身的用途为基准，如 PlayerMove，SaveGame，InitializeGlobal 之类的，最好遵循**骆驼命名法**。当然也可以使用 GM8 库函数的**蛇形命名**法，如 player_move, game_save, global_init 等。
