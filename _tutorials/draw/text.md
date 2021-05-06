---
layout: default
title: 文本
nav_order: 2
parent: 绘制
---

绘制文本的基础就是函数`draw_text(x, y, string);`，该函数在(x, y)位置绘制字符串string。注意：该函数只支持英文字符。绘制文本应当写在**draw事件**中（同样，surface除外）

# 全局设定

GM8中有许多用来设置`draw_text`文本样式的函数。注意这些函数是**全局设定**，一旦设定，整个游戏都会使用该设置。

* `draw_set_font(font)` 设定绘制文本时将要使用的字体（填写Fonts文件夹下的资源名）。-1代表默认字体（Arial 12）。
* `draw_set_halign(halign)` 设定绘制文本的水平对齐方式。选择下面三个中的一个作为值：
  * `fa_left` 左
  * `fa_center` 中
  * `fa_right` 右
* `draw_set_valign(valign)` 设定绘制文本的垂直对齐方式数。选择下面三个中的一个作为值 :
  * `fa_top` 上
  * `fa_middle` 中
  * `fa_bottom` 下
* `draw_set_color(col)` 设置当前绘制颜色。
* `draw_set_alpha(alpha)` 设置当前绘制时的透明通道值。（从0 到1，0代表完全透明，1代表完全不透明）。

*注意：绘制文本与绘制图形共用`draw_set_color`和`draw_set_alpha`，所以切记使用完要设置回默认值。*

`draw_set_halign`和`draw_set_valign`决定了绘制的字符串与`draw_text(x, y, string)`中(x, y)的关系。设置为`fa_left`和`fa_top`时，绘制的字符串的左上角为(x, y)，设置为`fa_center`和`fa_middle`时，绘制的字符串中心位置为(x, y)。

# 扩展函数

基于`draw_text`，GM又给出了一些扩展的文本绘制函数。

* `draw_text_ext(x, y, string, sep, w)` 基本与上面的函数作用相同，但增加了两个功能。sep 代表行间距，设成-1代表使用默认值。w 代表行宽，单位像素。超出行宽的部分会以空格或`-`进行分行。设为-1代表不换行。
* `draw_text_transformed(x, y, string, xscale, yscale, angle)` 在坐标(x,y)，以 xscale, yscale 指定的缩放尺寸和逆时针旋转angle角度的方式绘制文本 string 。
* `draw_text_ext_transformed(x, y, string, sep, w, xscale, yscale, angle)` 功能与上面类似，但加入了行间距 sep 和行宽 w 。可以绘制多行文本。
* `draw_text_color(x, y, string, c1, c2, c3, c4, alpha)` 在坐标(x, y)，左上，右上，右下，左下四个地方指定文本颜色，以透明通道值 alpha（0到1之间）绘制文本 string。
* `draw_text_ext_color(x, y, string, sep, w, c1, c2, c3, c4, alpha)` draw_text_color函数的多行显示版本。
* `draw_text_transformed_color(x, y, string, xscale, yscale, angle, c1, c2, c3, c4, alpha)` 与`draw_text_transformed()`相同，但是多了颜色渐变。
* `draw_text_ext_transformed_color(x, y, string, sep, w, xscale, yscale, angle, c1, c2, c3, c4, alpha)` 与`draw_text_ext_transformed()`相同，但是多了颜色渐变。

# FoxWriting

GM8作为古老的游戏制作引擎，很多功能都十分落后。为了拯救GM8，许多大佬们便站出来为GM8制作了一些扩展插件。本节所讲的就是由Noisyfox大佬所制作的插件FoxWriting，该插件弥补了GM8不能绘制中文的缺陷。

如果你下载的是本教程第一章给出的GM8汉化版，该汉化版自带FoxWriting插件。不过保险起见还是在这里放出FoxWriting的下载地址：[FoxWriting GM中文绘制插件——V1.5](https://www.noisyfox.io/fox-writing-gamemaker.html)。FoxWring的官方文档也在这个链接里。

**资源**->**选择扩展包**，选中**Noisyfox\'s Writing**，单击箭头导入，确定。

![Select Extension](/assets/images/draw/select_extension.png)

![Select FW](/assets/images/draw/select_fw.png)

![Selected](/assets/images/draw/selected.png)

如果你的GM8没有FoxWriting，请从上面的链接中下载，然后点击选择扩展包窗口右下角的安装卸载按钮，找到FoxWriting.gex并安装。

![Install](/assets/images/draw/install.png)

## 载入字体

* `fw_add_font(name, size, bold, italic, stroke)` 载入一个系统字体，name 填写系统字体名，可用字体名参见控制面板->字体，如"华文中宋"，"等线"等。注意在控制面板->字体中的字体名，后面的"常规"，"斜体"，"粗体"等均不属于字体名，字体名应当去除这一部分。size 是字体大小，单位为磅。bold 为是否使用粗体，填 true 或者 false 。italic 为是否使用斜体，填 true 或 false 。stroke 为是否描边，即是否在字体周围增加一像素的黑色描边，填 true 或者 false 。该函数返回新增字体的索引，建议使用`global`变量来储存，如果增加字体失败会返回-1。
* `fw_add_font_from_file(ttf, size, bold, italic, stroke)` 同上，只不过第一个变量变成了字体文件（通常为xxx.ttf）的路径。通常在游戏本体（即.exe）同文件夹下创建Data文件夹，下面再细分Musics，Savedatas，Plugins，Fonts文件夹等，发布游戏时将本体连同Data文件夹一起发布。假设在Data\Fonts下有一个字体文件"宋体.ttf"，那么`fw_add_font_from_file`载入这个字体的第一个参数应该填写`working_directory + "\Data\Font\宋体.ttf"`。其中`working_directory`是GM8内置变量，值为游戏本体（即.exe）所在的文件夹的完整路径，不包含exe本身名字和最后的反斜杠。

## 释放字体

* `fw_delete_font(font)` 将已经载入的字体销毁，释放内存空间，参数font为字体索引号（即`fw_add_font`和`fw_add_font_from_file`的返回值），返回是否成功。在不需要中文绘制或者游戏结束之前，请记住要释放掉所有字体的内存。

## 全局设定

FoxWriting响应`draw_set_color`和`draw_set_alpha`。

* `fw_draw_set_font(font)` 设置绘制文本所使用的字体，参数 font 为字体索引号。
* `fw_draw_set_halign(halign)`，`fw_draw_set_valign(valign)`，与`draw_set_halign`，`draw_set_valign`参数相同，作用相同，但是前者影响`fw_draw_text`，后者影响`draw_text`。
* `fw_draw_set_line_spacing(sep)` 设定绘制多行文本时的行间距。

## 绘制文本

几乎GM有的文本绘制函数FoxWriting都有，对应的函数就是在GM函数前加上fw_，例如`draw_text`对应`fw_draw_text`，`draw_text_color`对应`fw_draw_text_color`。有区别的地方是，FoxWriting的渐变色只能是双色上下渐变，也就是说，GM8文本绘制函数中(c1, c2, c3, c4)的位置，fw只填写两个参数(c1, c2)，分别代表上，下的颜色。

* `fw_draw_text(x, y, str)` 在(x,y)位置绘制字符串 str。需要注意的是该插件并不支持半角井号换行，如果要换行请使用回车符`chr(13)`或者换行符`chr(10)`会让字符串另起一行，这样我们就可以实现多行文本的绘制。
* `fw_draw_text_ext(x, y, str, w)` 与上面的函数相同，但是增加了一个功能，使用参数 w 来控制字符的绘制宽度，代表行宽，超出行宽的部分字符会自动换行。
* `fw_draw_text_transformed(x, y, str, xscale, yscale, angle)` 在坐标(x, y)，以 xscale, yscale 指定的缩放尺寸和逆时针旋转 angle 角度的方式绘制文本 str。
* `fw_draw_text_ext_transformed(x, y, str, w, xscale, yscale, angle)` 功能与上面类似，但加入了行宽 w。可以绘制多行文本。
* `fw_draw_text_color(x, y, str, c1, c2, alpha)` 在坐标(x,y)，上，下，两个地方指定文本颜色，实现从上到下的颜色渐变效果，以阿尔法透明通道值 alpha （0到1之间）绘制文本 str。
* `fw_draw_text_ext_color(x, y, str, w, c1, c2, alpha)` 上面函数的多行显示的变形。
* `fw_draw_text_transformed_color(x, y, str, xscale, yscale, angle, c1, c2, alpha)` 与`fw_draw_text_transformed()`相同，但是多了颜色从上到下的渐变。
* `fw_draw_text_ext_transformed_color(x, y, str, w, xscale, yscale, angle, c1, c2, alpha)` 与 `fw_draw_text_ext_transformed()`相同但是多了颜色渐变。
