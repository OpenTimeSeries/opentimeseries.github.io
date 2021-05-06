---
layout: default
title: 简单输入输出
nav_order: 3
parent: 函数
---

本节对应GML汉化文档的67-68页。

---

GM中要想给玩家提供信息，或者从玩家处获取信息，该使用什么函数呢？

* `show_message(str)` 显示一个对话框以输出信息。参数为一个字符串。弹出窗口时游戏会自动暂停。

例如，在房间的RCC（Room\'s creation code，房间创建代码）里写上：

```c
show_message("Here is first room");
```

然后运行游戏：

![Message](/assets/images/function/message.png)

emmm，字好像有点小，但是没关系，我们可以设置字体大小。

* `message_text_font(name, size, color, style)` 设置弹出框里文字的字体。

    name是指windows通常字体名字，如"Arial"，"Gigi"，"Meiryo"，记住要用双引号。可以在控制面板->外观和个性化->字体查看有哪些字体名字。

    size是指字体大小。

    color是指形如`c_red`，`c_green`，`c_blue`的系统自带常量，具体可以使用哪些颜色，请参阅GML汉化文档的第46页。如果你懂得混色的原理（见第十章），你也可以用`make_color_rgb(red, green, blue)`来自定义颜色，用他的返回值作为color参数。

    style是指字体样式，0表示默认，1表示粗体，2表示斜体，3表示粗斜体。

    该函数是永久有效地设置字体，一旦执行，之后游戏的所有弹窗都会使用这个字体。

在上面的例子中，我们加上（注意，要写在`show_message`前面）：

```c
message_text_font("Mistral", 15, c_red, 0);
```

![Font Code](/assets/images/function/font_code.png)

![Font Example](/assets/images/function/font_example.png)

---

* `string(val)` 返回实数val转换的字符串。

例如：

```c
show_message(string(5));
```

就会在弹出窗口中显示5。此处string(5)等效于"5"。即上述代码等效于：

```c
show_message("5");
```

---

字符串可以用加号相加。如：

```c
a = 5;
b = 4;
show_message("a+b is " + string(a+b) + "!");
```

就会在弹出窗口中显示：a+b is 9!

![String Add](/assets/images/function/string_add.png)

*提示：*

a = 5时无论是`show_message(string(a));`还是`show_message(a);`都是可以通过编译的。

同理：`show_message("16");`，`show_message(16);`也是一样的效果。

但是不建议省略string函数或者省略双引号。提及此，只是避免各位看到别人这么写的时候不知道这是什么情况。

---

* `get_integer(str, def)` 弹出窗口获取一个实数。str是显示的信息，def是默认参数。

例如：

```c
message_text_font("Arial", 15, c_red, 0);
a = get_integer("Input first number.", 5);
b = get_integer("Input second number.", 5);
show_message("Their sum is " + string(a + b) + "!");
```

效果：

![Input](/assets/images/function/input1.png)

![Input](/assets/images/function/input2.png)

![Input](/assets/images/function/input3.png)

---

* `get_string(str, def)` 弹出窗口获取一个字符串。str是显示的信息，def是默认参数。效果与`get_integer`类似。

---

* `message_input_font(name, size, color, style)` 设置弹出框中输入框文字的字体。参数同`message_text_font`。

---

* `show_question(str)` 弹出一个窗口，显示一个字符串，并且提供两个按钮：yes，no，玩家按下yes返回1，按下no返回0。

一般这样用：

```c
if(show_question("A question here"))
{
    xxxx;    // 玩家点yes后执行的代码
}
else
{
    // 可以没有else部分，如果要先判断玩家按no，则可以在show_question前加上逻辑非（!）
    xxxx;    // 玩家点no后执行的代码
}
```

比如询问玩家是否退出游戏：

```c
if(show_question("Exit game?"))
{
    game_end();   //game_end()函数用于结束游戏
}
```
