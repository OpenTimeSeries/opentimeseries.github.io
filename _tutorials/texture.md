---
layout: default
title: 纹理
nav_order: 25
---

GM8提供一类函数用以绘制**纹理**（texture），纹理这个词可以说是很形象了，相信各位至少都见过大理石上的纹理吧——什么，你说没见过？没事，我百度一张图片给你看看：

![Tone](/assets/images/texture/tone.jpg)

纹理既包括通常意义上物体表面的纹理即使物体表面呈现凹凸不平的沟纹，同时也包括在物体的光滑表面上的彩色图案。纹理一词出自建模，通常来讲，建好的模型是只有形状的纯色物体，通过把一张图像进行适当处理，覆盖在模型的表面上，使其更加具有真实感，就像是物体自身就有的纹理一样，因此通常称这些图像为纹理（或纹理贴图，材质等多种翻译）。

>![Texture](/assets/images/texture/texture.png)
>
> 纹理贴图
>
>![Model](/assets/images/texture/model.png)
>
> 已经覆盖上纹理贴图的模型

要如何把一张纹理覆盖在三维模型的表面呢？答案是在纹理上定位多个点，这些点通过互相连接把纹理分成许许多多的小三角形，然后在三维模型的表面找到纹理上每个点所对应的点，将这些点一一对齐之后，纹理中每个小三角形里的内容也会被拉伸收缩以适应新的小三角形。

我们在 GM8 中要做的事情也是类似的，只不过我们是在二维上做这件事情。

如果，我们把一张图片，分成许许多多大大小小的三角形，对于每一个顶点，我们都赋予它一个新的坐标，这样我们就可以得到一个新的图像，这个图像中每个三角形都是由原图拉伸过来的，那么图像就可以变得很扭曲，嗯，大概就像下面这个例子这样（灰色线是后加的）：

![Example](/assets/images/texture/example1.png)

除此之外，三角形的每个顶点都可以赋予其一种颜色，每个三角形内部会根据三个顶点的颜色来渲染，原理等同于 `draw_sprite_general` 因此不再特殊说明。

要注意的几点是：

1. 虽然我上图把整个图像分成了八个三角形，但是事实上三角形是可以随意选取的，并不必要让所有三角形刚好覆盖这张图片，而且不同的三角形是可以随意互相重叠的，也可以完全分开没有任何边和顶点重合，自由度非常高。
2. 同理，既然选取三角形是自由的，那么拉伸之后的三角形也是随意的，不需要保持和原图一样的顺序，也不必要互相连在一起。
3. GM 也可以不以三角形为基本单位而是以点和线为基本单位，线的纹理与三角形的纹理类似，就是选取原图中的一条像素线，然后拉伸到另一条像素线上，可以画出更加扭曲的图像了（八说了，我自裁）。

![Example](/assets/images/texture/example2.png)

纹理的作用，怎么说呢，在 GM8 中并不是很大，再加上他本身和其他组件组合性也不咋地，不像混色和表面那样密切结合。如果纹理和混色能结合起来的话，那就是 GMS 的 **shader** 了，那是特别的爽，虽然 shader 本身的语法和 debug 都非常的 shit，但是 shader 能做的特效是真的多。咳咳，但是咱作为 GM8 的教程，就只能看着眼馋无能为力了。

## 图元

在绘制纹理之前，我们需要选定一种**图元**（primitive）。图元是纹理的基本单位的形状，也就是上文中所说的点，线，三角形，选择其中一种作为绘制纹理的基本形状。要注意的是，无论是点，线，三角形，我们在代码中的本质都是通过点来指定的，即通过线的两个端点指定线，通过三角形的三个顶点指定三角形，这些点有个专门的术语叫做**顶点**（vertex）。因此，GM 给出了下面六种图元：

* `pr_pointlist` 一组点。

  ![Pointlist](/assets/images/texture/pointlist.png)

* `pr_linelist` 一组无关联的线。我们指定六个点 ABCDEF，`pr_linelist` 会给我们生成三条线，AB，CD 和 EF。

  ![Linelist](/assets/images/texture/linelist.png)

* `pr_linestrip` 一组连续的线。与 `pr_linelist` 的区别在于，我们指定六个点 ABCDEF，`pr_linestrip` 会生成五条线，即AB，BC，CD，DE 和 EF。也就是为指定的每两个相邻的点都生成一组线。

  ![Linestrip](/assets/images/texture/linestrip.png)

* `pr_trianglelist` 一组无关联的三角形。假设指定六个点 ABCDEF，那么 `pr_trianglelist` 会生成两个三角形 ABC 和 DEF。

  ![Trianglelist](/assets/images/texture/trianglelist.png)

* `pr_trianglestrip` 一组相邻的三角形。这种图元会把所有指定顺序相邻的三个点都连接为一个三角形，假设指定六个点 ABCDEF，那么 `pr_trianglestrip` 会生成四个三角形 ABC，BCD，CDE 和 DEF。

  ![Trianglestrip](/assets/images/texture/trianglestrip.png)

* `pr_trianglefan` 一组共用一个顶点且相邻的三角形。这种图元会固定第一个点，让它与其他任意两个指定顺序相邻的点构成三角形。假设指定六个点 ABCDEF，那么 `pr_trianglefan` 会先固定点 A 作为公共顶点，然后生成 ABC，ACD，ADE，AEF 四个三角形。事实上这个图元更适合用来生成圆形（或扇形等有弧度的图形），固定圆心作为第一个点，然后取圆周上一定数量的点构成三角形来逼近圆。

  ![Trianglefan](/assets/images/texture/trianglefan1.png)

  ![Trianglefan](/assets/images/texture/trianglefan2.png)

## 绘制纹理

GM8可以不使用图像，而是仅使用图元绘制纹理。相比之下只有函数参数上的小区别，因此不做细分。

* `sprite_get_texture(spr, subimg)` 返回精灵 spr 的索引为 subimg 的子图的纹理 id。
* `background_get_texture(back)` 返回背景图片 back 的纹理 id。
* `surface_get_texture(id)` 返回索引为 id 的表面的纹理 id。
* `draw_primitive_begin(kind)` 开始绘制一个纹理，该函数是绘制不使用图像的纹理，参数 kind 可以选择 `pr_pointlist`，`pr_linelist`，`pr_linestrip`, `pr_trianglelist`，`pr_trianglestrip`，`pr_trianglefan`。
* `draw_primitive_begin_texture(kind, texid)` 开始绘制一个纹理。参数 kind 同上，参数 texid 是图像的纹理 id。
* `draw_primitive_end()` 结束绘制纹理。

任何时候，绘制纹理都要以 begin 函数开始，以 end 函数结束，指定顶点的内容夹在中间。

通常，对于任意一个图像，我们定义**它的左上角的纹理坐标是 (0, 0)，右下角的纹理坐标是 (1, 1)**，不管图像本身是不是正方形的。因此，一张 800x600 的图像中，像素 (24, 66) 的纹理坐标是 (24 / 800, 66 / 600)。

* `draw_vertex(x, y)` 增加一个顶点到纹理中。注意该函数用于绘制不使用图像的纹理，顶点颜色受到 `draw_set_color` 和 `draw_set_alpha` 的影响。
* `draw_vertex_color(x, y, col, alpha)` 同上，不过增加了参数 col 和 alpha 指定顶点的颜色。
* `draw_vertex_texture(x, y, xtex, ytex)` 增加一个顶点到纹理中。该函数用于绘制使用图像的纹理。(x, y) 是顶点绘制在房间中的实际坐标，(xtex, ytex) 是顶点在图像中的纹理坐标。顶点颜色受到 `draw_set_color` 和 `draw_set_alpha` 的影响。所以一般使用该函数前会手动设置二者为 `c_white` 和 `1`。
* `draw_vertex_texture_color(x, y, xtex, ytex, col, alpha)` 同上。参数 col 指定混色颜色，alpha 指定透明度。

那么，我们有一张精灵 sprRay，大小为 300x200，使用它的索引为 0 的子图，将图像中从 (100, 100) 到 (200, 200) 的线段，绘制到房间内从 (300, 300) 到 (300, 600) 的线段上，完整的代码是：

```c
texid = sprite_get_texture(sprRay, 0);
draw_set_color(c_white);
draw_set_alpha(1);
draw_primitive_begin_texture(pr_linelist, texid);
draw_vertex_texture(300, 300, 100 / 300, 100 / 200);
draw_vertex_texture(300, 600, 200 / 300, 200 / 200);
draw_primitive_end();
```

我们说通常情况下，图像的右下角的纹理坐标是 (1, 1)，那么什么是非通常情况呢？那就是当系统是 **Win XP** 或者更低的时候。在 Win XP 及以下的电脑中，如果图像的长和宽不满足 `2^n`，GM8 会扩充空白区域直到图像大小满足 `2^n` 为止，再把扩充后右下角视作纹理坐标的 (1, 1)，这样一来原图的右下角坐标就不是 (1, 1)了。实测在 Win7 及更高的系统中，图像的右下角纹理坐标都是 (1, 1)。注意，这里所说的系统不是指你的系统，而是指玩家的系统。考虑到兼容 XP 玩家的话，我们可以使用下面这些函数：

* `texture_get_width(texid)` 返回纹理 id 为 texid 的图像的纹理宽度（在 0~1 之间）。
* `texture_get_height(texid)` 返回纹理 id 为 texid 的图像的纹理高度（在 0~1 之间）。

我们修改上述代码，让他兼容 Win XP：

```c
texid = sprite_get_texture(sprRay, 0);
texwidth = texture_get_width(texid);
texheight = texture_get_height(texid);
draw_set_color(c_white);
draw_set_alpha(1);
draw_primitive_begin_texture(pr_linelist, texid);
draw_vertex_texture(300, 300, texwidth * 100 / 300, texheight * 100 / 200);
draw_vertex_texture(300, 600, texwidth * 200 / 300, texheight * 200 / 200);
draw_primitive_end();
```

由于Win7以上系统的图像右下角坐标一定是 (1 ,1)，毫无疑问上述两个函数的返回值也一定是 1，因此这个修改并不会影响到 Win7 以上系统正常运行。

最后，注意纹理属于 draw_系列函数，因此代码要么写在绘制事件中，要么就要绘制到表面上。

## 一些设置

* `texture_preload(texid)` 将纹理 id 为 texid 的纹理图像立即加载到显存中。通常纹理会在第一次绘制时才加载纹理图像到显存中，该函数可以提前这个操作。
* `texture_set_priority(texid, prio)` 当显存不够用时，会移除优先度较低的纹理图像。默认所有纹理图像的优先级都是 0，你可以使用该函数改变其优先级（使用正数）。
* `texture_set_interpolation(linear)` 设置是否使用线性插值（true）或选择就近像素（false）。线性插值使纹理更加顺畅，但也会有点模糊，有时候会增加额外的时间成本。此设定也会影响到绘制精灵和背景。默认值是 false。
* `texture_set_blending(blend)` 设置是否使用混色和透明度。设置为 false 在旧硬件上更快。此设定也影响到绘制精灵和背景。默认是 true。
* `texture_set_repeat (repeat)` 设置当纹理坐标大于 1 时的行为。设置为 false 时不绘制纹理坐标超出 1 的像素。设置为 true 时，会将图像不断重复扩展到 1 以外的坐标，比如在这种情况下纹理坐标 (1.5, 2.3) 实际上和 (0.5, 0.3) 是一样的。默认值是 false。注意，当绘制精灵和背景时，这个值会被强制重置为 0，因为绘制精灵和背景总是不重复的，因此它并不是个永久性的设置。

## 范例

纹理的例子真不好找，姑且先写一个放大镜的例子吧。*注意，放大镜的 obj 的深度应该最低。*

![Example](/assets/images/texture/example.gif)

创建（Create）事件：

```c
surf = surface_create(room_width, room_height);
texid = surface_get_texture(surf);
isRedraw = false;
// 放大倍数
scale = 2;
// 放大镜半径
radius = 100;

texture_set_interpolation(true);
```

步结束（End Step）事件：

```c
if (!surface_exists(surf))
{
    surf = surface_create(room_width, room_height);
    texid = surface_get_texture(surf);
}

surface_set_target(surf);
draw_clear_alpha(c_black, 0);
isRedraw = true;
screen_redraw();
isRedraw = false;
surface_reset_target();
```

绘制（Draw）事件：

```c
if (!isRedraw)
{
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_blend_mode_ext(bm_one, bm_zero);

    draw_primitive_begin_texture(pr_trianglefan, texid);
    draw_vertex_texture(mouse_x, mouse_y, mouse_x / room_width, mouse_y / room_height);
    for (i = 0; i <= 360; i += 6)
        draw_vertex_texture(mouse_x + lengthdir_x(radius, i), mouse_y + lengthdir_y(radius, i),
            (mouse_x + lengthdir_x(radius / scale, i)) / room_width,
            (mouse_y + lengthdir_y(radius / scale, i)) / room_height);
    draw_primitive_end();

    draw_set_blend_mode(bm_normal);
}
```

销毁（Destroy）事件：

```c
if (surface_exists(surf))
    surface_free(surf);
```
