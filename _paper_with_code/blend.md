---
layout: post
title: 混色
nav_order: 20
---

本章内容魔改 Ray 神的帖子，原贴已随 Heabot 的关闭而石沉大海，若 Ray 神未来补档，则会在此处贴出链接。

## 颜色的混合

细心的 GMer 可能已经发现，在 GM8 的图像编辑器中，有“**颜色模式**”一选项，可选择“**混合**”或是“**替换**”。

![Image Editor](/assets/images/blend/image_editor.png)

当选择颜色的透明度为 255 时，“混合”和“替换”是没有区别的，都是用新的颜色取代旧的颜色。

但是如果新颜色的透明度不是 255，而是**半透明**，比如 120，那么“混合”模式下，会将新颜色与原本的颜色进行混合，比如要画上去的颜色是 (0, 0, 255, 120)（请参考[RGB 颜色系统]({{ site.baseurl }}{% link _tutorials/rgb_hsv.md %}#rgb-颜色系统)），原本的颜色是 (255, 0, 0, 120)，那么混合之后的颜色是 (87, 0, 167, 183)。

这个混合是如何计算得到的呢？

首先，我们要把所有值**压缩到 0\~1 之间**，也就是说让所有值都除以 255，例如上述的 (0, 0, 255, 120) 压缩为 (0, 0, 1, 0.47)，(255, 0, 0, 120) 压缩为 (1, 0, 0, 0.47)，(87, 0, 167, 183) 压缩为 (0.34, 0, 0.65, 0.72)。

然后，我们要规定一下符号，**s** 代表 source，即**你要画上去的颜色**，**d** 代表 destination，即**原本的颜色**，**o** 代表 output，**最终得到的颜色**，**R** 代表 Red，**G** 代表 Green，**B** 代表 Blue，**A** 代表 Alpha。将一个大写字母和一个小写字母组合，如 Rs，代表要画上去的颜色的 Red 的值。为了更好的理解，我们将上面举的例子用符号来表示出来：

> Rd = 1, Gd = 0, Bd = 0, Ad = 0.47,
>
> Rs = 0, Gs = 0, Bs = 1, As = 0.47,
>
> Ro = 0.34, Go = 0, Bo = 0.65, Ao = 0.72

请一定要记住这十二个符号所代表的含义，因为我们后面都将用这十二个符号来讲解混色。

最后，GM 的图像编辑器所使用的混色计算方式为：

```c
Ao = As + Ad * (1 - As)
Ro = (Rs * As + Rd * Ad * (1 - As)) / Ao
Go = (Gs * As + Gd * Ad * (1 - As)) / Ao
Bo = (Bs * As + Bd * Ad * (1 - As)) / Ao
```

可以自己做做实验算一算，看看是不是这样。

## 混合因素

混色的计算方式可以有很多种，并非只有上面所讲的那种。只要输入一中 source 的颜色和一种 destination 的颜色，经过一定的计算得到 output 的过程，都可以称之为混色。事实上，所有的**混色**计算都可以总结为下面一个公式：

```c
Ro = Rs * a1 + Rd * b1
Go = Gs * a2 + Gd * b2
Bo = Bs * a3 + Bd * b3
Ao = As * a4 + Ad * b4
```

在这之中，`(a1, a2, a3, a4)` 和 `(b1, b2, b3, b4)` 就是两个**混合因素（factor）**，`(a1, a2, a3, a4)` 称为 source 的混合因素，`(b1, b2, b3, b4)` 称为 destination 的混合因素。注意，如果计算的值大于 1，则一律视为 1。

同样是拿 GM 的图像编辑器举例子，它的两个混合因素分别是 `(As / Ao, As / Ao, As / Ao, 1)` 和 `(Ad * (1 - As) / Ao, Ad * (1 - As) / Ao, Ad * (1 - As) / Ao, 1 - As)`。值得一提的是，这个混合因素是很特别的，它在 GM8 中是无法用代码来实现的。

GM8所提供的混合因素有：

* `bm_zero` 混合因素是 `(0, 0, 0, 0)`
* `bm_one` 混合因素是 `(1, 1, 1, 1)`
* `bm_src_color` 混合因素是 `(Rs, Gs, Bs, As)`
* `bm_inv_src_color` 混合因素是 `(1 – Rs, 1 – Gs, 1 – Bs, 1 – As)`
* `bm_src_alpha` 混合因素是 `(As, As, As, As)`
* `bm_inv_src_alpha` 混合因素是 `(1 – As, 1 – As, 1 – As, 1 – As)`
* `bm_dest_alpha` 混合因素是 `(Ad, Ad, Ad, Ad)`
* `bm_inv_dest_alpha` 混合因素是 `(1 – Ad, 1 – Ad, 1 – Ad, 1 – Ad)`
* `bm_dest_color` 混合因素是 `(Rd, Gd, Bd, Ad)`
* `bm_inv_dest_color` 混合因素是 `(1 – Rd, 1 – Gd, 1 – Bd, 1 – Ad)`
* `bm_src_alpha_sat` 混合因素是 `(f, f, f, 1)`; 其中 `f = min(As, 1 – Ad)`

*注意：虽然有些混合因素的名字带了 src 或者 dest 的字样，但是这并不代表只有 source 能使用带有 src 的混合因素或者只有 destination 能使用带有 dest 的混合因素，所有因素都是 source 和 destination 共用的。*

## 设置混色模式

* `draw_set_blend_mode_ext(src, dest)` 这个函数用来设置混色模式。参数 src 填写 source 的混合因素，参数 dest 填写 destination 的混合因素。

这是一个全局设置，一旦启用，整个游戏都会使用这个混色模式，所以在使用完，请恢复混色模式到默认状态，默认状态的混合因素为 `draw_set_blend_mode_ext(bm_src_alpha, bm_inv_src_alpha);`，你也可以使用 `draw_set_blend_mode(bm_normal);`，两个代码等效。

*注意：由于 GM8 的窗口并非半透明的，因此，如果你在窗口中进行混色绘制时，得到的 **Ao 往往会被忽略，而强制设置为 1***。但是，如果你是在**表面**（surface）上进行混色绘制，则会保留 Ao。

另外，GM8 还有一个简化的混色函数：

* `draw_set_blend_mode(mode)` 这个函数是上面这个函数的简化版，参数只能选填 `bm_mormal`，`bm_add`，`bm_subtract`, `bm_max` 四个参数。

这是 GM8 提供的四种比较常用的混合因素组合方式，你可以完全使用 `draw_set_blend_mode_ext` 来代替。

* `bm_normal` 对应 `(bm_src_alpha, bm_inv_src_alpha)`
* `bm_add` 对应 `(bm_src_alpha, bm_one)`
* `bm_subtract` 对应 `(bm_zero, bm_inv_src_color)`
* `bm_max` 对应 `(bm_src_alpha, bm_inv_src_color)`

### bm_normal

`bm_normal` 就是常规状态下，不设置混色模式时 GM8 的默认混合因素。

### bm_add

`bm_add` 是对颜色的加强，通常用于暗色调下去除黑色背景。比如你看中了一张素材图片，但是它的黑色底色很难去除：

![Add Example](/assets/images/blend/add_example1.png)

事实上，你无需去除它的黑色底色，直接导 入GM8 中，绘制它时在 draw 事件内写：

```c
draw_set_blend_mode(bm_add);
draw_sprite(sprite_index, 0, x, y);
draw_set_blend_mode(bm_normal);
```

bm_add 的混色会自动帮你去除黑色底色：

![Add Example](/assets/images/blend/add_example2.png)

![Add Example](/assets/images/blend/add_example3.png)

由于 bm_add 属于叠加型混色，在亮色背景的情况下大概率会叠加到白色，因此只适合于暗色的背景。在制作弹幕游戏的时候，给弹幕用上 `bm_add`，就能让弹幕看起来非常炫丽（只适用于黑色或偏暗的背景色）。在用圆球 spr 组成文字的时候，`bm_add` 能消除圆球 spr 的重叠，视觉效果更好。总之，`bm_add` 是混色中最常用的一种模式，经常活跃在各种特效之中。例如：<https://www.bilibili.com/video/av3877543/>

### bm_subtract

`bm_subtract` 多用于表面（surface）之中，可以在表面上“挖洞”，这个我们日后再说。

### bm_max

`bm_max` 和 `bm_add` 效果比较接近，混合因素稍有不同，destination 的权重相比 `bm_add` 更低，因此单纯从去除黑色底色的功能来讲大概是要比 `bm_add` 更好一点点的（如下图所示），但是感觉大部分人似乎都更喜欢用 `bm_add`？不过 `bm_max` 仍然是不适合用在亮色背景下的。

![Max Example](/assets/images/blend/max_example.png)

---

### 区域反色效果

```c
draw_set_blend_mode_ext(bm_inv_dest_color, bm_zero);
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(200, 200, 400, 400, false);     // 这里可以改成绘制任何纯白色的图案或精灵
draw_set_blend_mode(bm_normal);
```

![MeAqua](/assets/images/blend/meaqua.png)

很容易推出，反色就是：

```c
Ro = 1 - Rd
Go = 1 - Gd
Bo = 1 - Bd
```

因此，我们设置混合因素：source 为 `bm_inv_dest_color`，即 `(1 – Rd, 1 – Gd, 1 – Bd, 1 – Ad)`，dest 为 `bm_zero`，即 `(0, 0, 0, 0)`，然后再绘制上纯白色的图案，由于纯白色就是 (1, 1, 1, 1)，所以 Rs，Gs，Bs，As 均为 1，带入方程中就可以解出：

> Ro = 1 \* (1 - Rd) + Rd \* 0 = 1 - Rd

Go和Bo同理，不赘述。

---

上面说过，由于 GM8 的窗口不能半透明，所以实际上 Ao 总是强制设置为 1，因此，直接使用混色能实现的功能比较有限。要想真正发挥混色的能力，那么就要用到可以储存 Ao 值的**表面**（surface），表面就是我们下一章所要的内容。可以说，表面 + 混色是 GM8 高端特效的绝对主力，在 GMS1/2 中则引入了更加高端的 **shader**（同时也更加复杂难懂）来实现特效。

## 绘制函数中的混色

有些绘制函数中有混色的参数，例如 `draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, color, alpha)` 中的 color 参数，再比如 `draw_sprite_general(sprite, subimg, left, top, width, height, x, y, xscale, yscale, rot, c1, c2, c3, c4, alpha)` 提供了 c1~c4 四个参数，代表左上角，右上角，右下角，左下角的渐变混色。

那么这些函数的混色是怎么混色呢？

以下图为例，用 `draw_sprite_general` 混色，颜色参数为：`c_red`, `c_yellow`, `c_blue`, `c_green`。左为混色后，右为混色前。

![General](/assets/images/blend/general.png)

这种混色模式的因素为 `(bm_dest_color, bm_zero)`，或者 `(bm_zero, bm_src_color)`，两种混色模式的效果是相同的。混色结果为：

```c
Ro = Rs * Rd
Go = Gs * Gd
Bo = Bs * Bd
Ao = As * Ad  // 实际上强制设置为1
```

我们现在来验证一下，验证代码为：

```c
// 左上角
draw_sprite(sprite_index, 0, 0, 0);
// 右上角
draw_sprite_general(sprite_index, 0, 0, 0, sprite_width, sprite_height, sprite_width, 0, 1, 1, 0, c_red, c_yellow, c_blue, c_green, 1);
// 左下角
draw_sprite(sprite_index, 0, 0, sprite_height);
draw_set_blend_mode_ext(bm_dest_color, bm_zero);
draw_rectangle_color(0, sprite_height, sprite_width, sprite_height * 2, c_red, c_yellow, c_blue, c_green, 0);
draw_set_blend_mode(bm_normal);
// 右下角
draw_sprite(sprite_index, 0, sprite_width, sprite_height);
draw_set_blend_mode_ext(bm_zero, bm_src_color);
draw_rectangle_color(sprite_width, sprite_height, sprite_width * 2, sprite_height * 2, c_red, c_yellow, c_blue, c_green, 0);
draw_set_blend_mode(bm_normal);
```

结果如下（左上角为原图，右上角为 `draw_sprite_general`，左下角 `(bm_dest_color, bm_zero)`，右下角为 `(bm_zero, bm_src_color)`）：

![Compare](/assets/images/blend/compare.png)

可见确实是等效的。
