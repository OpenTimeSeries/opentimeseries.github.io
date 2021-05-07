---
layout: default
title: 命令行
nav_order: 31
---

# CLI 与 GUI

相信大家多少对**图形用户界面**（Graphical User Interface，简称 GUI）一词有所耳闻，当然完全没听说过也没有关系。总的来说，图形用户界面就是指允许用户通过鼠标或触摸板之类的设备，操作屏幕上的图标、菜单等以完成计算机的日常工作，这么一种人与计算机之间交互的形式。

但是在图形用户界面诞生之前，计算机最流行的界面是**命令行界面**（Command-Line Interface，简称 CLI），与我们所熟悉的操作系统不同，命令行界面只有满屏幕的字符，通过键盘输入命令来完成计算机的日常工作。

本质上，GUI 是对 CLI 的封装，GUI 对用户提供图形化界面，转换为命令之后传递给计算机。因此，GUI 上的种种操作基本上都能在 CLI 上找到对应的命令。

# cmd 和 PowerShell

也许你没有听说过 GUI，但是你总该听说过**命令提示符**（Command Prompt），由于它的程序名叫做 cmd.exe，因此通常简称 **cmd**。cmd 是 Windows 下所保留的命令行界面，可以用它来处理几乎所有的 GUI 所提供的功能。**PowerShell** 则是 Windows 上的另一个命令行界面，通常 Windows10 系统中的默认命令行界面就是 PowerShell，它在一定程度上兼容命令提示符，另一方面，PowerShell 对接 .NET，提供了强大的脚本编写环境。

![Command Prompt](/assets/images/command/cmd.png)

> cmd

![PowerShell](/assets/images/command/powershell.png)

> PowerShell

在这里我们并不会去了解命令行界面的具体使用方式，我们只谈谈那些 GM8 中能用的上的部分。

首先，我们想要打开一个 exe，我们只需要**键入它的完整路径**即可，例如：

![Open EXE](/assets/images/command/open_exe.png)

注意路径要加上双引号，因为命令行界面通常把空格当做分隔符。

如果我们想要用一个程序打开一个文件，同样，**我们先键入程序的路径，再键入文件的路径**：

![Open File](/assets/images/command/open_file.png)

由于 GUI 是对 CLI 的封装，因此，我们双击打开程序，实际上就是 GUI 在暗处发出了程序完整路径这条命令，而我们双击打开文件（或者把文件拖动到程序 exe 文件图标上），也是 GUI 在暗处发出了打开程序路径 + 空格 + 文件路径的命令。

如果我们能在 GM8 中读取到 GUI 所发出的命令，那么我们至少可以做到，把文件拖到我们的程序 exe 图标上可以打开这个文件。如果你想要绑定文件打开方式，双击文件就能打开的话，那就是要写注册表的事情了。

# 获取打开命令

* `parameter_count()` 返回命令行参数的数目。
* `parameter_string(n)` 返回命令行第 n 个参数，1 是第一个参数，最后一个是 `parameter_count()`。注意，`parameter_string(0)` 是个特殊值，永远是程序的绝对路径。

所谓的**命令行参数**，就是指命令行中跟在程序路径后的其他部分，以空格作为分隔符。在使用 `parameter_string` 时一定要先判断 `parameter_count`，小心不要越界了。

例如，假设我们的游戏绝对路径是 `E:\Game\MyGame.exe`，然后我们在cmd中使用 `"E:\Game\MyGame.exe" debug -a 32 /c` 来打开它，那么 `parameter_count()` 的值是 4，`parameter_string(1)` 到 `parameter_string(4)` 分别是 `"debug"`, `"-a"`, `"32"`, `"/c"`。

通过这种方式，我们不仅可以实现拖动文件到程序 exe 图标上打开文件，甚至可以接受多个指令做各种各样的事情。要想理解什么叫做接受多个指令做各种各样的事情，个人建议可以上手一下 Linux 试试，多玩几天 Linux 的终端，就会有不少感触。

# 打开外部程序

同样，我们也可以打开外部程序并且给他们赋予命令行参数：

* `execute_program(program, args, wait)` 执行程序 program 并传递参数 args。wait 决定是否等待程序执行完毕，即 wait 为 true 时，当前游戏会暂停并且等待程序执行完毕之后才会继续。
* `execute_shell(program, args)` 在壳层打开程序或文件。program 可以是文件名，将会调用默认打开方式的程序去打开；可以是文件夹路径，将会使用 explorer 打开；也可以是网址，会使用默认浏览器打开网址。
