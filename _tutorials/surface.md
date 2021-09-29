---
layout: default
title: 表面
nav_order: 21
---


GM中有着**绘图目标**（drawing target）这一概念。绘制目标可以理解为画布，而 draw_系列函数可以理解为画笔，现实中，在一块画布上作画不会影响其他画布上的内容，同样的，在 GM 中，draw_系列函数会将图案文字等绘制在指定的绘制目标上，不会影响其他绘制目标上的内容。

默认的情况下，GM 只有一个绘制目标，那就是**屏幕**（虽然我觉得叫“屏幕”很容易搞混概念，但是既然官方给的“屏幕”那就用“屏幕”好了），因此，默认的情况下，我们使用 draw_系列函数都是直接绘制在屏幕上给玩家看的。但是，我们有时候并不想直接绘制到屏幕上，而是绘制到**看不见的表面**上，在需要时再将表面的内容绘制到屏幕。*表面只体现在内存中，不体现在游戏窗口中，因此无法直接展现给玩家，必须要先将其内容转移到屏幕上才行。*

这里再解释一下，为什么之前说，draw_系列函数一定要写在绘制事件中呢？屏幕是一个比较特殊的绘制目标，GM 会控制它在每一帧都刷新一次（表面则不会自动刷新）。注意，屏幕也是绘制目标，因此它既有内存的体现，同时又有在游戏窗口中的体现。我们所说的“绘制”，其实是先写入到内存之中的，并不是直接改变了窗口内容。而屏幕刷新的顺序是：

1. 步结束事件
2. 清空屏幕内存
3. 绘制背景图片（到内存中）
4. 调用深度大于 1000000 的实例的绘制事件（到内存中）
5. 绘制贴图（到内存中）
6. 调用深度小于 1000000 的实例的绘制事件（到内存中）
7. 从内存中输出画面到窗口上
8. 下一帧的步开始事件

简化一下，就是：

1. 其他事件
2. 清空内存
3. 绘制事件
4. 内存输出到窗口
5. 其他事件
6. ......

如果你在绘制事件以外的地方使用了 draw_函数，那么显然，它在被输出到窗口之前就会残忍地清空，自然不可能被玩家看到了。但是，屏幕会刷新，**表面**却不会啊！所以我们可以在任意事件中，将绘制目标设置为表面后，尽情使用 draw_系列函数。最后要记得将绘制目标设置回屏幕。（话虽然这么说，但是**实际上一般还是在 end step 或者 draw 事件里**，因为只有这两个事件在"物体移动到新位置"之后执行）

看了上面的介绍，你可能觉得表面似乎没啥厉害的地方啊。这么想就对了！因为厉害的地方还没讲到。

第一，之前我们把绘制目标当成画布，但是它和画布不同的地方在于，**不同的绘制目标之间可以随便转移内容**，比如把表面 1 的指定部分画在表面 2 的指定位置，或者把屏幕的指定部分画在表面的指定位置。

第二，**表面不会因为房间变换而消失**，你在创建表面时，GM 会返回一个表面的索引，只要传递索引（如 global），就能跨房间传递表面，再加上可以把屏幕绘制在表面上，因此，你可以在一个房间内将屏幕绘制到表面上，再在另一个房间内把表面画出来。

第三，**表面的像素透明度可以为任意值**。注意了，这里才是大头戏。我们知道，GM 窗口锁定透明度为 1（即完全不透明），因此，我们在使用混色时，完全不考虑透明度的问题，最终 Ao 总是强制设置为 1。但是表面是可以储存透明度的，这就意味着混色在表面中可以得到最好的体现。

# 表面基础

## 创建表面

* `surface_create(w, h)` 创建一个宽为 w 像素，高为 h 像素的表面。该函数返回被创建的表面的索引（id），请务必保存好该索引。若返回 -1，则表面创建失败。注意：索引是从 0 开始的，因此，你在初始化用来储存索引的变量时，请初始化为 -1 而不是 0。

## 销毁表面

* `surface_free(id)` 销毁索引为 id 的表面。正如上所说，表面不会因为房间变换而消失或改变，因此，切记要自己销毁表面。

## 检测表面

* `surface_exists(id)` 检测索引为 id 的表面是否存在。再次强调，请将储存索引的变量初始化为 -1，因为 `surface_exists(0)` 可能是 true。

## 设置绘制目标

* `surface_set_target(id)` 将绘制目标设置到索引为 id 的表面上，此后所有 draw_系列函数均绘制到这个表面上。
* `surface_reset_target()` 将绘制目标重新设置回屏幕上。

## 绘制表面

* `draw_surface(id, x, y)` 将索引为id的表面的内容绘制在 (x, y) 的位置，表面的左上角与 (x, y) 重合。正如上所说，表面之间也可以随便转移内容，因此你可以把绘制目标设置在表面 2 上，然后 `draw_surface(表面 1, x, y)` 也是可以的。
* `draw_surface_part(id, left, top, width, height, x, y)` 将索引为 id 的表面的部分内容，左上角为 (left, top)，右下角为 (left + width, top + height) 之间的矩形部分绘制在 (x, y) 坐标处，左上角与 (x, y) 重合。

上述两个函数如果绘制在屏幕上，只能写在绘制事件，如果绘制在其他表面上，则可以写在任意事件。事实上，`draw_sprite_xxx` 的函数 `draw_surface_xxx` 几乎都有对应的函数，函数作用和参数也几乎是一样的，因此不再重复赘述。

* `surface_copy(destination, x, y, source)` 除了先 `surface_set_target` 再 `draw_surface` 外，你也可以用这个函数将索引为 source 的表面内容绘制在索引为 destination 的表面的 (x, y) 处，无需改变当前绘制目标。
* `surface_copy_part(destination, x, y, source, xs, ys, ws, hs)` 同上，将索引为 source 的表面的部分内容，左上角为 (xs, ys)，右下角为 (xs + ws, ys + hs) 的矩形部分绘制在索引为 destination 的 (x, y) 坐标处，左上角与 (x, y) 重合。

## 使用表面的一般流程

在 Create（创建）事件：

```c
// 创建一个表面，大小根据实际需要决定。较为通用的情况是使用房间大小作为表面大小。
surf = surface_create(room_width, room_height);
```

在 End Step（步结束）事件中：

```c
// 有时候 GM 可能会无缘无故地销毁一个表面，保险起见先判断一下。
if (!surface_exists(surf))
    surf = surface_create(room_width, room_height);
// 将绘制目标转移到表面上。
surface_set_target(surf);
// 之后开始绘制任意东西。
draw_xxxx();
// 将绘制目标复原到屏幕。
surface_reset_target();
```

在 Draw（绘制）事件中：

```c
// 将表面绘制到屏幕上。
draw_surface(surf, 0, 0);
```

在 Destroy（销毁）事件中：
```c
// 当被销毁时释放表面
if (surface_exists(surf))
    surface_free(surf);
```

# 表面高级

```c
draw_clear_alpha(c_black, 0);
```

当绘制目标为某个表面时，清空其所有内容，回归到**空白透明**状态。**表面不会自动刷新**，因此在有需要的时候得自己手动刷新。

这个函数的原型是 `draw_clear_alpha(color, alpha)`，用指定颜色和指定透明度填充整个绘制目标。由于屏幕强制透明度为1，因此更多使用 `draw_clear(color)`。但是表面是可以储存透明度的，因此可以用 `draw_clear_alpha(c_black, 0);` 将表面重新变回空白透明状态。

注意，虽然 RGBA 值为 (任意, 任意 ,任意, 0) 的时候在视觉上都是完全透明，但是只有 (0, 0, 0, 0) 是真正意义上的透明。在进行混色时，虽然 A 为 0，但是如果 RGB 不为 0，RGB 值依然会对混色的计算产生影响，有时会造成不可预料的结果。而只有 (0, 0, 0, 0) 的纯透明才对混色不会造成任何多余的影响。

---

```c
surface_save(id, fname);
surface_save_part(id, fname, x, y, w, h);
```

将索引为 id 的表面储存到文件 fname 中（.png 格式），后者为部分保存。如果你要保存屏幕内容（即截屏），可以使用 `screen_save(fname)` 或者 `screen_save_part(fname, x, y, w, h)`。

---

```c
screen_redraw();
```

重新调用一遍所有实例的绘制事件，同时也重绘背景和贴图。该函数不会影响正常流程中的绘制事件的执行。通常将绘制目标设置到表面后，调用这个函数**把屏幕内容转移到表面上**。

*注意，调用 `screen_redraw()` 会导致一帧之内执行两次绘制事件*，我们之前说为什么不应该在绘制事件里做其他功能，尤其是变量的自增自减，这也是其中的原因之一。

---

```c
with (all)
    if (sprite_index != -1)
        drawSelf();
```

在设置绘制目标为表面后，将所有实例的图像绘制到表面上，但是不包含背景和贴图。由于可能有的实例没有 sprite，所以要增加 `sprite_index != -1` 的判定，以免出现 Trying to draw non-existing sprite 的报错。

注意：`drawSelf()` 是在[绘制]({{ site.baseurl }}{% link _tutorials/draw/draw.md %}#实例有隐藏的默认绘制事件)中提到的自定义脚本，其内容是 `draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);`，并非 GM8 自带的函数。

如果要剔除调用者本身，则可以使用：

```c
with (all)
    if (id != other.id && sprite_index != -1)
        drawSelf();
```

同样的，你也可以 `with (objxxx) drawSelf();` 将特定的 obj 的实例绘制到表面上。这在处理混色时很有作用。

---

```c
draw_set_blend_mode(bm_subtract);
```

`bm_subtract` 可以说是专门为表面设计的，当绘制目标为表面时，这个混色效果会给表面“挖洞”，即表面与图案重叠的部分会被清空透明。

---

```c
draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
```

与挖洞相反，这个混色模式会让表面只保留与绘制图案重叠的部分，其他部分则清空为透明。需要注意的是，其清空透明的原理是使用了 source 的透明部分，因此要确保让 source 的大小能够完全覆盖 destination。

# 表面范例

## 视野光圈限制

*注意：该实例深度应该最小，建议设置为负数，以免其他实例绘制在表面的上面。*

![Example](/assets/images/surface/example1.gif)

Create（创建）事件中：

```c
surf = surface_create(room_width, room_height);
```

End Step（步结束）事件中：

```c
if (!surface_exists(surf))
    surf = surface_create(room_width, room_height);
surface_set_target(surf);
draw_clear(c_black);
draw_set_blend_mode(bm_subtract);
//不必是白色，是什么颜色都行，此处只是个人习惯
draw_set_color(c_white);
draw_set_alpha(1);
//下面两个 with 修改为你要在周围绘制光圈的 obj，绘制圆也可以换成绘制任何图案
with (player)
    draw_circle(x, y, 150, 0);
with (savePoint)
    draw_circle(x, y, 100, 0);
draw_set_blend_mode(bm_normal);
surface_reset_target();
```

Draw（绘制）事件中：

```c
draw_surface(surf, 0, 0);
```

Destroy（销毁）事件中：

```c
if (surface_exists(surf))
    surface_free(surf);
```

## 电磁波干扰

同样，绘制表面的实例深度应该最低。注意，isRedraw 的目的是阻止表面在 `screen_redraw()` 时重绘，如果 draw 事件有其他与表面无关的代码，应该放在 `if (!isRedraw)` 外。

![Example](/assets/images/surface/example2.gif)

Create（创建）事件：

```c
surf = surface_create(room_width, room_height);
isRedraw = false;
```

End Step（步结束）事件：

```c
if (!surface_exists(surf))
    surf = surface_create(room_width, room_height);
surface_set_target(surf);
draw_clear_alpha(c_black, 0);
isRedraw = true;
screen_redraw();
isRedraw = false;
surface_reset_target();
```

Draw（绘制）事件：

```c
var i;
if (!isRedraw)
{
    draw_set_blend_mode_ext(bm_one, bm_zero);
    for (i = 0;i < room_width;i += 2)
        draw_surface_part(surf, i * 2, 0, 2, room_height, i * 2, random_range(-5,5));
    draw_set_blend_mode(bm_normal);
}
```

Destroy（销毁）事件中：

```c
if (surface_exists(surf))
    surface_free(surf);
```

横向干扰只需将 Draw 事件改为：

```c
var i;
if (!isRedraw)
{
    draw_set_blend_mode_ext(bm_one, bm_zero);
    for (i = 0;i < room_height;i += 2)
        draw_surface_part(surf, 0, i * 2, room_width, 2, random_range(-5,5), i * 2);
    draw_set_blend_mode(bm_normal);
}
```

## 化零为整

同样，绘制表面的实例深度应该最低。

注意：`drawSelf()` 是在[绘制]({{ site.baseurl }}{% link _tutorials/draw/draw.md %}#实例有隐藏的默认绘制事件)中提到的自定义脚本，其内容是 `draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);`，并非 GM8 自带的函数。

图像：

![Example](/assets/images/surface/example3_1.png)

关卡：

![Example](/assets/images/surface/example3_2.png)

效果：

![Example](/assets/images/surface/example3_3.png)

Create（创建）事件：

```c
surf1 = surface_create(room_width, room_height);
surf2 = surface_create(room_width, room_height);
```

End Step（步结束）事件：

```c
if (!surface_exists(surf1))
    surf1 = surface_create(room_width, room_height);
if (!surface_exists(surf2))
    surf2 = surface_create(room_width, room_height);
surface_set_target(surf1);
draw_clear_alpha(c_black, 0);
//下面的 with 改成要被图像覆盖的 obj
with (block)
    drawSelf();
with (playerKiller)
    drawSelf();
surface_set_target(surf2);
draw_clear_alpha(c_black, 0);
//下面的这个函数改成绘制你的图像，不限于绘制 background，可以绘制 sprite，绘制形状，甚至绘制其他表面
draw_background(backRay, 0, 0);
draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
draw_surface(surf1, 0, 0);
draw_set_blend_mode(bm_normal);
surface_reset_target();
```

Draw（绘制）事件：

```c
draw_surface(surf2, 0, 0);
```

Destroy（销毁）事件中：

```c
if (surface_exists(surf1))
    surface_free(surf1);
if (surface_exists(surf2))
    surface_free(surf2);
```

## 放大镜

下面以跟随鼠标为例，其他形式类推。同样，绘制表面的实例深度应该最低。

![Example](/assets/images/surface/example4.gif)

Create（创建）事件：

```c
surf1 = surface_create(room_width, room_height);
surf2 = surface_create(room_width, room_height);
isRedraw = false;
// 放大倍数
scale = 2;
// 放大镜半径
radius = 100;
```

End Step（步结束）事件：

```c
if (!surface_exists(surf1))
    surf1 = surface_create(room_width, room_height);
if (!surface_exists(surf2))
    surf1 = surface_create(room_width, room_height);

surface_set_target(surf1);
draw_clear_alpha(c_black, 0);
isRedraw = true;
screen_redraw();
isRedraw = false;

surface_set_target(surf2);
draw_clear_alpha(c_black, 0);
draw_set_circle_precision(64);
draw_set_color(c_black);
draw_set_alpha(1);
draw_circle(mouse_x, mouse_y, radius, 0);

draw_set_blend_mode_ext(bm_dest_alpha, bm_inv_src_alpha);
draw_surface(surf1, 0, 0);
draw_set_blend_mode(bm_normal);

draw_set_color(c_white);
surface_reset_target();
```

Draw（绘制）事件：

```c
if (!isRedraw)
    draw_surface_ext(surf2, mouse_x * (1 - scale), mouse_y * (1 - scale), scale, scale, 0, c_white, 1);
```

Destroy（销毁）事件：

```c
if (surface_exists(surf1))
    surface_free(surf1);
if (surface_exists(surf2))
    surface_free(surf2);
```

## 表面上的反色

我在[上一章]({{ site.baseurl }}{% link _tutorials/blend.md %}#区域反色效果)讲了反色的混色因素。可能会有人尝试将其放在表面上，想要反色表面，但是却发现失败了。失败是显然的，因为按照 `(bm_inv_dest_color, bm_zero)` 的混色因素，最终得到的 `Ao = 1 - Ad`，也就是说你原本是不透明的部分，反色后会变成透明，而原本透明的部分，反色后会变成不透明。我们完全是依赖 GM8 窗口强制设置 Ao 为 1 的效果，才成功实现的反色。

那么在表面上的反色是不可能的吗？非也。多绕一点弯路还是可以实现的。首先，我们仍然按照正常的混色方式先反色，因为 GM8 只提供了这一种能让颜色全部翻转的方式，得到 `(1 - R, 1 - G, 1 - B, 1 - A)`。之后，我们设置 `(bm_one, bm_zero)`，把反色后的表面以透明度 0 绘制到另一个表面上，这样我们就得到了 `(1 - R, 1 - G, 1 - B, 0)`。现在，我们需要把原本的透明度放进去。我们可以使用 `(bm_one, bm_zero)`，让 `draw_xxx_ext` 系列函数的 col 参数设置为 `c_black`，绘制到一个新的表面上，得到一个 `(0, 0, 0, A)` 的表面。最后，我们通过 `(bm_dest_alpha, bm_inv_src_alpha)` 即可成功混合二者，得到 `(1 - R, 1 - G, 1 - B, A)` 的反色表面。

效果：

![Example](/assets/images/surface/example5.png)

Create（创建）事件：

```c
surf1 = surface_create(room_width, room_height);
surf2 = surface_create(room_width, room_height);
```

End Step（步结束）事件：

```c
if (!surface_exists(surf1))
    surf1 = surface_create(room_width, room_height);
if (!surface_exists(surf2))
    surf1 = surface_create(room_width, room_height);

surface_set_target(surf1);
draw_clear_alpha(0, 0);
// 此处绘制任何你想要反色的精灵，背景图片，表面。
draw_sprite(sprMagicField, 0, 100, 100);
draw_set_blend_mode_ext(bm_inv_dest_color, bm_zero);
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_blend_mode(bm_normal);

surface_set_target(surf2);
draw_clear_alpha(0, 0);
draw_set_blend_mode_ext(bm_one, bm_zero);
draw_surface_ext(surf1, 0, 0, 1, 1, 0, c_white, 0);

surface_set_target(surf1);
draw_clear_alpha(0, 0);
// 此处再次绘制你想要反色的图像以获取其透明度，但是你必须使用 draw_xxx_ext 并且设置 col 参数为 c_black。
draw_sprite_ext(sprMagicField, 0, 100, 100, 1, 1, 0, c_black, 1);
draw_set_blend_mode_ext(bm_dest_alpha, bm_inv_src_alpha);
draw_surface(surf2, 0, 0);
draw_set_blend_mode(bm_normal);
surface_reset_target();
```

Draw（绘制）事件：

```c
draw_surface(surf1, 0, 0);
```

Destroy（销毁）事件：

```c
if (surface_exists(surf1))
    surface_free(surf1);
if (surface_exists(surf2))
    surface_free(surf2);
```

# bm_normal 对表面的腐蚀

回顾一下，`bm_normal` 是 GM8 在正常状态下的默认混色模式，其本质是 `(bm_src_alpha, bm_inv_src_alpha)` 的混色因素，也就是：

```c
Ro = Rs * As + Rd * (1 - As)
Go = Gs * As + Gd * (1 - As)
Bo = Bs * As + Bd * (1 - As)
Ao = As * As + Ad * (1 - As)
```

注意最后一行计算 Ao 时的公式。

如果绘制双方的透明度都是 255，即都是完全不透明的，在公式中 As = Ad = 255 / 255 = 1，因此 Ao = 1 \* 1 + 1 \* 0 = 1，得到的混合透明度也是 255。

但是如果 **source 是半透明**的情况下，假设 As = 0.5，Ad = 1，此时 Ao = 0.5 \* 0.5 + 1 \* (1 - 0.5) = 0.75，输出也是半透明。在 GM 的窗口中，由于强制设置绘制的透明度为 1，因此在 `bm_normal` 下，我们绘制半透明的图像，和背景混合之后的透明度仍然为 1。但是在表面中，透明度保持其计算结果，我们称这种情况是 **`bm_normal` 对表面的腐蚀**。这种腐蚀会产生什么后果呢？他会让 `screen_redraw()` 函数重绘到表面上时带有一定的透明度。

要想理解其危害，首先我们要**假设如果不存在这种腐蚀**，`bm_normal` 画在表面上也是完全不透明的，那么我们在上文中制作放大镜时就完全可以使用 `(bm_dest_alpha, bm_zero)` 的混色因素了，这个混色因素很好理解，取圆圈的透明度 255 加上屏幕的颜色，得到圆圈形状的屏幕部分，再让圆圈乘 0 以此去掉圆圈，这样不管圆圈是什么颜色，都是无所谓的。而事实上，我们在制作放大镜时，却必须要使用纯黑色的圆圈，以及 `(bm_dest_alpha, bm_inv_src_alpha)` 这个一眼看上去有点莫名其妙的混色因素。这就是 `bm_normal` 腐蚀表面带来的后果，如果你使用 `(bm_dest_alpha, bm_zero)` 来制作放大镜，那么半透明的图像通过 `screen_redraw` 绘制到表面上，使得表面带有透明度，再通过 `(bm_dest_alpha, bm_zero)` 时，透明度不变，这样就使得放大镜中绘制了半透明图像的地方也是半透明的，出现了“透视”，可以看到放大镜后面的东西。

那么黑色圆 + `(bm_dest_alpha, bm_inv_src_alpha)` 是怎么抵消掉 `bm_normal` 的腐蚀呢？首先我们来看看这个混色因素的公式：

```c
Ro = Rs * Ad + Rd * (1 - As)
Go = Gs * Ad + Gd * (1 - As)
Bo = Bs * Ad + Bd * (1 - As)
Ao = As * Ad + Ad * (1 - As)
```

我们知道，黑色圆的非透明部分是 (0, 0, 0, 255)，伸缩到 0~1 则是 (0, 0, 0, 1)，带入可得到：

```c
Ro = Rs * 1 + 0 * (1 - As) = Rs
Go = Gs * 1 + 0 * (1 - As) = Gs
Bo = Bs * 1 + 0 * (1 - As) = Bs
Ao = As * 1 + 1 * (1 - As) = 1
```

可以看到，无论原本的透明度是多少，Ao 的计算结果一定是 1，也就是一定完全非透明。而 output 的 RGB 和 source 的 RGB 是一模一样的。

而对于黑色圆的透明部分（即超出放大镜边界的表面部分）则是 (0, 0, 0, 0)，带入可得

```c
Ro = Rs * 0 + 0 * (1 - As) = 0
Go = Gs * 0 + 0 * (1 - As) = 0
Bo = Bs * 0 + 0 * (1 - As) = 0
Ao = As * 0 + 0 * (1 - As) = 0
```

就是纯透明了，会正常显示屏幕的内容。

同样的，在示例“电磁波干扰”中，我们在 draw 事件中使用 `(bm_one, bm_zero)` 也是这个原因。只不过相比于放大镜而言，电磁波干扰要简单很多，因为放大镜只放大部分区域，其他区域仍要显示屏幕的正常内容，而电磁波干扰只需要绘制完成的表面就行了，完全不需要再考虑屏幕中原本的内容，因此使用 `(bm_one, bm_zero)` 直接将屏幕原本的内容完全抹消掉即可，透明度就可以直接依靠 GM8 的窗口强制置 1 来解决。
