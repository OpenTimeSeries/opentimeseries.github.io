---
layout: default
title: 图像
nav_order: 1
parent: 绘制
---

本节位于GML汉化文档43-44页。

---

## 精灵的绘制

GM用来绘制精灵的函数，大都以 draw_sprite_ 开头，例如上一节提到的 `draw_sprite_ext`。其中 ext 指 extend，即“扩展，延伸”。

这些函数常用的参数有：

* sprite，指填入一个精灵名或索引。索引一般指用变量储存的值，如 `first = sprBlock3; draw_sprite(first, ...);`。
* subimg，即 sub-image，子图，填入子图索引。填 -1 表示使用当前索引，等效于填入 `image_index`。注意使用 draw_系列函数不会影响 `image_speed`，如果精灵是动态图，那么 subimg 填写 -1 时绘制的也是动态图。
* x，y，将图像绘制在 (x, y) 的位置，其中图像的原点与 (x, y) 重合。
* xscale, ysacle，缩放的比例，1 为不缩放。
* rot，即rotate，精灵旋转的角度，类似于 `image_angle`。
* alpha，绘制精灵的透明度，类似于 `image_alpha`。
* color，混合颜色，填写 `c_white` 表示原样绘制，类似于 `image_blend`。混色是个复杂的话题，需要专门讲解，现在可以暂时理解为蒙上一层颜色。注意填写 `c_white` 图像会原样绘制，并不是没有发生混色，而是根据混色的原理，任意色+白色=原色。

接下来介绍函数：

* `draw_sprite(sprite, subimg, x, y)` 在坐标 (x, y) 绘制精灵 sprite 子图像 subimg 。
* `draw_sprite_stretched(sprite, subimg, x, y, w, h)` 将精灵 sprite 扩展填充至左上角坐标为 (x, y)，宽度高度分别为 w, h 的方形区域内。
* `draw_sprite_tiled(sprite, subimg, x, y)` 将精灵 sprite 作为图块在整个房间内进行绘制。其中一个图像的原点与 (x, y) 重合，如下图：

    ![Stretched](/assets/images/draw/stretched.png)

* `draw_sprite_part(sprite, subimg, left, top, width, height, x, y)` 绘制图像 sprite 的一部分，这部分由四个参数决定，左上角坐标 (left, top)（以图像左上角为原点），右下角坐标 (left + width, top + height)，然后将这部分图像绘制在 (x, y) 的位置，其中新图像的左上角 (0, 0)，也就是原图像的 (left, top) 与 (x, y) 重合。
* `draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, color, alpha)`  扩展参数的精灵绘制函数。
* `draw_sprite_stretched_ext(sprite, subimg, x, y, w, h, color, alpha)` 绘制精灵拉伸如此精灵填充在 x，y，宽 w，高 h 的区域里。
* `draw_sprite_tiled_ext(sprite, subimg, x, y, xscale, yscale, color, alpha)` 绘制精灵贴图，精灵填充整个房间。
* `draw_sprite_part_ext(sprite, subimg, left, top, width, height, x, y, xscale, yscale, color, alpha)` 按照 left, top, width, height 尺寸绘制精灵子图的部分。
* `draw_sprite_general(sprite, subimg, left, top, width, height, x, y, xscale, yscale, rot, c1, c2, c3, c4, alpha)` 常规绘制函数，它按照 left, top, width, height 尺寸，四角混合颜色（左上 c1，右上 c2，右下 c3，左下 c4）绘制精灵子图的部分。最好在学习混色之后再使用。

## 背景图片的绘制

* `draw_background(back, x, y)` 在坐标 (x, y) 绘制背景 back 。
* `draw_background_stretched(back, x, y, w, h)` 将背景 back 扩展填充至左上角坐标为 (x, y)，宽度高度分别为 w, h 的方形区域内。
* `draw_background_tiled(back, x, y)` 将背景 back 作为图块在整个房间内进行绘制。其中一个图像的原点与 (x, y) 重合。
* `draw_background_part(back, left, top, width, height, x, y)` 绘制背景 back 的一部分。
* `draw_background_ext(back, x, y, xscale, yscale, rot, color, alpha)` 扩展参数的背景绘制函数。
* `draw_background_stretched_ext(back, x, y, w, h, color, alpha)` 绘制背景拉伸以范围。
* `draw_background_tiled_ext(back, x, y, xscale, yscale, color, alpha)` 绘制背景贴图填充整个房间。
* `draw_background_part_ext(back, left, top, width, height, x, y, xscale, yscale, color, alpha)` 按照 left, top, width, height 尺寸绘制显示背景的部分。
* `draw_background_general(back, left, top, width, height, x, y, xscale, yscale, rot, c1, c2, c3, c4, alpha)` 常规绘制函数，它按照 left, top, width, height 尺寸，四角混合颜色（左上 c1，右上 c2，右下 c3，左下 c4）绘制背景的部分。注意旋转以左上为中心。

## 基础形状绘制

本节位于 GML 汉化文档 45-46 页。

---

GM提供了一些基础形状的绘制函数，例如线，三角形，圆等。绘制基础形状比绘制图像要复杂一点，因为在绘制基础形状之前，你需要先设定**绘制参数**：

* `draw_set_color(col)` 设置当前绘制颜色。
* `draw_set_alpha(alpha)` 设置当前绘制时的透明通道值（从 0 到 1，0 代表完全透明，1 代表完全不透明）。

参数 col 可以填写 GM8 提供的常量，如下：

* `c_aqua` 水色
* `c_black` 黑色
* `c_blue` 蓝色
* `c_dkgray` 深灰
* `c_fuchsia` 紫红
* `c_gray` 灰色
* `c_green` 绿色
* `c_lime` 石灰色
* `c_ltgray` 浅灰
* `c_maroon` 赤褐色
* `c_navy` 深蓝
* `c_olive` 茶青色
* `c_orange` 橙色
* `c_purple` 紫色
* `c_red` 红色
* `c_silver` 银色
* `c_teal` 茶绿色
* `c_white` 白色
* `c_yellow` 黄色

你也可以使用 `make_color_rgb(red, green, blue)` 和 `make_color_hsv(hue, saturation, value)` 的返回值，关于这两个函数的参数请参考[颜色系统]({{ site.baseurl }}{% link _tutorials/rgb_hsv.md %})。

另外，你也可以使用 `$` 代表十六进制颜色，比如 `$D1124A`，但是注意，GM 的颜色十六进制并不是传统 RGB 的顺序，而是 BGR 顺序，也就是说，`$0000FF` 不是蓝色而是红色。

注意，这两个函数是**全局设置**，一旦调用，整个游戏所有地方都会使用你设置的值。所以，要养成绘制结束后设置回默认值的好习惯：

```c
draw_set_color(c_blue);
draw_set_alpha(0.5);
绘制的内容。。。
draw_set_color(c_white);
draw_set_alpha(1);
```

除了对颜色和透明度的设置，对于圆形有一个特别的设置：

* `draw_set_circle_precision(precision)` 设置绘制圆的精度，就是由多少段组成，精度必须在 4-64 之间并被 4 整除，这也被使用在椭圆和圆角方形中。参数 precision 填不同值的效果如下：

    ![Precision](/assets/images/draw/precision.png)

GM 提供了以下基本图形的绘制：

* `draw_point(x, y)` 在坐标 (x, y) 上绘制一个使用当前颜色的点。
* `draw_line(x1, y1, x2, y2)` 从坐标 (x1, y1) 到 (x2, y2) 绘制一条直线。
* `draw_line_width(x1, y1, x2, y2, w)` 从坐标 (x1, y1) 到 (x2, y2) 绘制一条直线，宽为 w。
* `draw_rectangle(x1, y1, x2, y2, outline)` 在指定坐标之间绘制一个矩形。outline 指定是只描绘边框（真 true），还是要填充整个区域（假 false）。
* `draw_roundrect(x1, y1, x2, y2, outline)` 在指定坐标之间绘制一个圆角矩形。outline 指定是只描绘边框（真 true），还是要填充整个区域（假 false）。
* `draw_triangle(x1, y1, x2, y2, x3, y3, outline)` 在指定坐标之间绘制一个三角形。outline 指定是只描绘边框（真 true），还是要填充整个区域（假 false）。
* `draw_circle(x, y, r, outline)` 以坐标 (x, y) 为圆心，r 为半径绘制一个圆形。outline 指定是只描绘边框（真 true），还是要填充整个区域（假 false）。
* `draw_ellipse(x1, y1, x2, y2, outline)` 绘制一个椭圆。outline 指定是只描绘边框（真 true），还是要填充整个区域（假 false）。
* `draw_arrow(x1, y1, x2, y2, size)` 绘制一个从坐标 (x1, y1) 到 (x2, y2) 的箭头。size 指定箭头的尺寸，单位像素。
* `draw_button(x1, y1, x2, y2, up)` 绘制一个按钮，up 指定按钮状态为上（1）还是下（0）。
* `draw_path(path, x, y, absolute)` 通过这个函数你可以从房间坐标 (x, y) 开始绘制一条指定的路径 path。如果 absolute 为真，路径就会以原先设定的位置进行绘制，而 x 和 y 就被无视 了。
* `draw_healthbar(x1, y1, x2, y2, amount, backcol, mincol, maxcol, direction, showback, showborder)` 绘制一个血条。（或者其他任何一种表现数值变化的颜色条，比如：攻击力）。(x1, y1) 和 (x2, y2) 代表整个条的范围。amount 代表条内颜色填充程度的百分比（从 0 到 100）。backcol 为条的背景颜色，mincol 和maxcol 代表条从 0 到 100 之间的颜色变化。中间值在两端颜色之间渐变。direction 代表条的绘制方向。0 代表从左边开始，1 代表从右边开始，2 代表从上开始，3 代表从下开始。showback 指定是否显示背景框，showborder 指定是否显示边框。

同样的，绘制基本图形的深度也与实例保持一致，并且后绘制的图案会覆盖在先绘制的图案上。
