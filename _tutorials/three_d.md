---
layout: default
title: 3D 绘制
nav_order: 34
---

（by 魔方 12139）

众所周知，GameMaker8 在图形绘制方面最主要、最强大、最全面的方面是 2D 绘制，也就是在平面上绘制图形。而在 3D 绘制方面，GameMaker8 虽有一定功能，但：

1. 无法在编辑时创建和编辑 3D 模型，无直接导入通用的 3D 模型的方法。
2. 无法直接在房间编辑时在 3D 空间中放置物体。
3. 必须自己处理 3D 世界变换、投影变换等。
4. 必须自己处理 3D 空间中的碰撞判断。
5. 房间背景、前景设置以及图块使用可能出错。

因此在 GM8 中，3D 绘制方面的功能通常被用来做一些小特效，或者对 3D 物理方面要求较低的游戏功能。如果要用 GM8 做出复杂的 3D 游戏，很多在其他 3D 游戏引擎中已经是内置的功能都需要自己实现。（话说，我好像还见过 GMS 做的 3D 建模工具......真的是自己折腾自己）

下面来具体讲述如何进行简单的 3D 绘制。

## 改变投影方式

你的显示器是一个 2D 空间，所以在 3D 空间中绘制图形后，需要一个从 3D 空间投射到 2D 空间的过程才能出现在你的屏幕上。而决定某一个点投射前后的位置关系，需要**投影方式**作为规则。常见的投影方式有以下两种：

* **正交投影**（orthogonal projection）

  过点作一直线垂直于目标平面，垂足作为投影点。这也是“正交”一词的含义如图：

  ![Orthogonal](/assets/images/three_d/orthogonal.png)

* **透视投影**（perspective projection）

  将点与视点（也就是你从哪儿看这个空间）连线，与目标平面的交点作为投影点。如图：

  ![Perspective](/assets/images/three_d/perspective.png)

  这种投影方式产生的效果和人眼的投影效果相近。

GM8 中，设置这两种投影方式的函数分别如下：

* `d3d_set_projection_ortho(x, y, w, h, angle)` 设置正交投影。参数 x 是被投影部分的左上角水平坐标，参数 y 是被投影部分的左上角竖直坐标，参数 w 是被投影部分的宽度，参数 h 是被投影部分的高度，参数 angle 是被投影部分的旋转角度。
* `d3d_set_projection_perspective(x, y, w, h, angle)` 设置透视投影。参数同上。

为了在后面更清楚地看到 3D 的效果，我们首先把投影设置成透视投影。代码如下：

```c
d3d_set_projection_perspective(0, 0, room_width, room_height, 0);
```

## 绘制 3D 图形

之前在[纹理]({{ site.baseurl }}{% link _tutorials/texture.md %})中提到，在 2D 空间中绘制多边形的方法如下：

```c
draw_primitive_begin(kind);
draw_vertex(x, y);
draw_vertex(x, y);
...
draw_primitive_end();
```

通过指定**一群点**以及它们之间的**拓扑结构**来绘制一个图形。当然，还可以用 `draw_vertex_texture()` 或 `draw_vertex_color()` 来绘制带有纹理或者颜色的图形。

在 3D 空间中绘制多边形的方法与上述方法十分相似。如下：

```c
d3d_primitive_begin(kind);
d3d_vertex(x, y, z);
d3d_vertex(x, y, z);
...
d3d_primitive_end();
```

仅仅是把前缀 `draw_` 改成 `d3d_`，点的坐标从 2 个变成 3 个而已。

下面我们就来尝试绘制一个 3D 的正方体框。创建一个物体，在 **Draw 事件**添加代码如下：

```c
// 设置透视投影方式
d3d_set_projection_perspective(0, 0, room_width, room_height, 0);

// 拓扑结构：线列表（忘了的去复习）
d3d_primitive_begin(pr_linelist);
// 顶面
d3d_vertex(0, 0, 0);
d3d_vertex(100, 0, 0);
d3d_vertex(100, 0, 0);
d3d_vertex(100, 100, 0);
d3d_vertex(100, 100, 0);
d3d_vertex(0, 100, 0);
d3d_vertex(0, 100, 0);
d3d_vertex(0, 0, 0);

// 侧面
d3d_vertex(0, 0, 0);
d3d_vertex(0, 0, 100);
d3d_vertex(100, 0, 0);
d3d_vertex(100, 0, 100);
d3d_vertex(100, 100, 0);
d3d_vertex(100, 100, 100);
d3d_vertex(0, 100, 0);
d3d_vertex(0, 100, 100);

// 底面
d3d_vertex(0, 0, 100);
d3d_vertex(100, 0, 100);
d3d_vertex(100, 0, 100);
d3d_vertex(100, 100, 100);
d3d_vertex(100, 100, 100);
d3d_vertex(0, 100, 100);
d3d_vertex(0, 100, 100);
d3d_vertex(0, 0, 100);
d3d_primitive_end();

// 把投影方式设置回去
d3d_set_projection_ortho(0, 0, room_width, room_height, 0);
```

创个房间把这个物体扔进去（位置随意），运行，效果如下：

![Example](/assets/images/three_d/example1.png)

可以看到正方体框就出来了。注意到正方体框在屏幕的左下角，这是因为在透视投影模式下点的坐标含义发生了变化，变成了以左下角为原点，向右、向上分别为正方向。

如果把上述代码开头设置透视投影的函数注释了再运行，效果是这样的：

![Example](/assets/images/three_d/example2.png)

只有一个正方形。这就是我们画出的几何体的主视图。

---

在绘制 3D 几何体时也可以定义纹理、颜色、光照等其他信息，相应函数如下：

```c
d3d_vertex_color(x, y, z, col, alpha);
d3d_vertex_normal(x, y, z, nx, ny, nz);
d3d_vertex_normal_color(x, y, z, nx, ny, nz);
d3d_vertex_normal_texture(x, y, z, nx, ny, nz, xtex, ytex);
d3d_vertex_color(x, y, z, col, alpha);
d3d_vertex_normal(x, y, z, nx, ny, nz);
d3d_vertex_normal_color(x, y, z, nx, ny, nz, col, alpha);
d3d_vertex_normal_texture(x, y, z, nx, ny, nz, xtex, ytex);
d3d_vertex_normal_texture_color(x, y, z, nx, ny, nz, xtex, ytex, col, alpha);
d3d_vertex_texture(x, y, z, xtex, ytex);
d3d_vertex_texture_color(x, y, z, xtex, ytex, col, alpha);
```

具体用法可以参阅汉化文档。

另外对于一些基本体，GameMaker8 提供了一些可以直接绘制出它们的函数，这样就不必像刚才那样写一大堆顶点了。如下：

```c
d3d_draw_block(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat);
d3d_draw_cylinder(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat, closed, steps);
d3d_draw_cone(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat, closed, steps);
d3d_draw_ellipsoid(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat, steps);
d3d_draw_wall(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat);
d3d_draw_floor(x1, y1, z1, x2, y2, z2, texid, hrepeat, vrepeat);
```

具体用法可以参阅汉化文档。

## 设置 3D 变换

众所周知，用 `draw_sprite_ext()` 绘制一个 2D 精灵时可以指定它的位置、旋转角度、拉伸比例等。这实际上是通过**变换**（transfoming）来实现的。

变换的作用就是改变后续绘制流程中点的坐标的含义。例如，在单位变换（也就是什么变换都不做）下，在点 (0, 0) 绘制一个尺寸为 (20, 10) 的矩形，绘制结果如下：

![Draw Result](/assets/images/three_d/draw_result1.png)

而在到点 (30, 30) 的平移变换下，在点 (0, 0) 绘制一个尺寸为 (20, 10) 的矩形，绘制结果如下：

![Draw Result](/assets/images/three_d/draw_result2.png)

绘制出的矩形并不是在 (0, 0) 位置。

你可以把变换视为对点的一系列处理流程。也就是你告诉GM：我接下来说的坐标并不是真实坐标，你在处理时要根据我之前说的变换方式把这些坐标作变换，然后再绘制到屏幕上。

多个变换可以**叠加**成一个大的变换，这个变换的效果等于那几个变换的效果依次发生。变换的叠加一般**没有交换性**。（学了图形学的话就会知道，变换实际上通过**矩阵相乘**来实现，变换的不可交换性其实就是矩阵乘法的不可交换性）

与本例中**平移变换**（translating transform）相似的还有**旋转变换**（rotating transform）、**伸缩变换**（scaling transform）等。上述的以一定位置、角度、伸缩比例绘制一个精灵的过程中，其实就依次进行了伸缩变换、旋转变换、平移变换。只是 GM 对我们屏蔽了实现细节，平常我们在使用 2D 绘制时感受不到变换的存在。

然而在 3D 绘制中，我们就需要自己处理坐标变换了。相应函数如下：

* `d3d_transform_set_identity()` 设置当前变换为单位变换，也就是什么都不变换。
* `d3d_transform_set_translation(xt, yt, zt)` 设置当前变换为到指定点的平移变换。
* `d3d_transform_set_scaling(xs, ys, zs)` 设置当前变换为指定尺寸的伸缩变换。
* `d3d_transform_set_rotation_x(angle)` 设置当前变换为指定角度的绕 x 轴旋转变换。
* `d3d_transform_set_rotation_y(angle)` 设置当前变换为指定角度的绕 y 轴旋转变换。
* `d3d_transform_set_rotation_z(angle)` 设置当前变换为指定角度的绕 z 轴旋转变换。
* `d3d_transform_set_rotation_axis(xa, ya, za, angle)` 设置当前变换为绕指定方向旋转指定角度的旋转变换。
* `d3d_transform_add_translation(xt, yt, zt)` 在当前变换上追加到指定点的平移变换。
* `d3d_transform_add_scaling(xs, ys, zs)` 在当前变换上追加指定尺寸的伸缩变换。
* `d3d_transform_add_rotation_x(angle)` 在当前变换上追加指定角度的绕 x 轴旋转变换。
* `d3d_transform_add_rotation_y(angle)` 在当前变换上追加指定角度的绕 y 轴旋转变换。
* `d3d_transform_add_rotation_z(angle)` 在当前变换上追加指定角度的绕 z 轴旋转变换。
* `d3d_transform_add_rotation_axis(xa, ya, za, angle)` 在当前变换上追加绕指定方向旋转指定角度的旋转变换。

可以看到可设置的主要是平移、旋转、伸缩变换，并且既可以**直接把当前变换设置为指定变换**，也可以**在当前变换上追加指定变换**。其中旋转变换可以指定为绕 x 轴、y 轴、z 轴，也可以指定为通过向量自定义的一个角度。

下面让我们来体验一下变换的作用。创建另外一个物体，在 Create 事件添加代码如下：

```c
rotation_x = 0;
rotation_y = 0;
rotation_z = 0;
```

定义好三个旋转角度值，坐标值和伸缩比例值在 ICC 定义。

在 Step 事件添加代码如下：

```c
rotation_x += rotation_x_speed;
rotation_y += rotation_y_speed;
rotation_z += rotation_z_speed;
```

三个旋转速度值也在 ICC 里定义

在 Draw 事件添加代码如下：

```c
d3d_set_projection_perspective(0, 0, room_width, room_height, 0);

d3d_transform_set_scaling(scaling_x, scaling_y, scaling_z);
d3d_transform_add_rotation_x(rotation_x);
d3d_transform_add_rotation_y(rotation_y);
d3d_transform_add_rotation_z(rotation_z);
d3d_transform_add_translation(x_3d, y_3d, z_3d);

d3d_primitive_begin(pr_linelist);

d3d_vertex(-50, -50, -50);
d3d_vertex( 50, -50, -50);
d3d_vertex( 50, -50, -50);
d3d_vertex( 50,  50, -50);
d3d_vertex( 50,  50, -50);
d3d_vertex(-50,  50, -50);
d3d_vertex(-50,  50, -50);
d3d_vertex(-50, -50, -50);

d3d_vertex(-50, -50, -50);
d3d_vertex(-50, -50,  50);
d3d_vertex( 50, -50, -50);
d3d_vertex( 50, -50,  50);
d3d_vertex( 50,  50, -50);
d3d_vertex( 50,  50,  50);
d3d_vertex(-50,  50, -50);
d3d_vertex(-50,  50,  50);

d3d_vertex(-50, -50,  50);
d3d_vertex( 50, -50,  50);
d3d_vertex( 50, -50,  50);
d3d_vertex( 50,  50,  50);
d3d_vertex( 50,  50,  50);
d3d_vertex(-50,  50,  50);
d3d_vertex(-50,  50,  50);
d3d_vertex(-50, -50,  50);

d3d_primitive_end();

d3d_set_projection_ortho(0, 0, room_width, room_height, 0);
```

还是首先设置**透视投影**，然后仿照 GM 的流程依次进行三个变换，再然后还是绘制正方体框，不同的是这次绘制出的是以原点为中心。最后把投影方式设置回去。其实不设置也行，因为这时候还没有别的物体要进行 2D 绘制。

删掉房间里之前放的物体，然后随便扔三个刚创建的物体，分别在写 ICC 如下：

第一个物体：

```c
x_3d = 100;
y_3d = 100;
z_3d = 0;
scaling_x = 1;
scaling_y = 1;
scaling_z = 1;
rotation_x_speed = 3;
rotation_y_speed = 0;
rotation_z_speed = 0;
```

设定它在 (100, 100, 0) 位置，伸缩比例是 (1, 1, 1)，绕 x 轴旋转速度是 3，绕其他两轴旋转速度都是 0。

第二个物体：

```c
x_3d = 100;
y_3d = 200;
z_3d = 100;
scaling_x = 1;
scaling_y = 1;
scaling_z = 1;
rotation_x_speed = 0;
rotation_y_speed = 3;
rotation_z_speed = 0;
```

设定它在 (100, 200, 100) 位置，伸缩比例是 (1, 1, 1)，绕 y 轴旋转速度是 3，绕其他两轴旋转速度都是 0。

第三个物体：

```c
x_3d = 300;
y_3d = 100;
z_3d = 0;
scaling_x = 2;
scaling_y = 1;
scaling_z = 1;
rotation_x_speed = 0;
rotation_y_speed = 0;
rotation_z_speed = 3;
```

设定它在 (300, 100, 0) 位置，伸缩比例是 (2, 1, 1)，绕 z 轴旋转速度是 3，绕其他两轴旋转速度都是 0。

注：为什么不用物体原本的 x 和 y 坐标呢，因为房间编辑时用的是左上角坐标系，而透视投影用的是左下角坐标系，这就意味着如果用了物体原本的 x 和 y 坐标，在透视投影模式下想让物体在左下角，就得在房间编辑时把物体放在左上角，不符合房间编辑“所见即所得”的用法。物体自带的伸缩比例变量和旋转角度变量倒是可以用，不过为了统一性和防止误会，还是用自定义变量的好。

运行，结果如下：

![Example](/assets/images/three_d/example3.gif)

可见三个几何体的位置、旋转角度、伸缩比例都与预期一致。

## 3D 绘制与 2D 绘制的冲突

往常我们绘制 2D 精灵时都是用 `draw_sprite` 系列函数。其实在 GM 内部，使用这个函数的本质与使用 `draw_primitive_begin_texture()` 和一群 `draw_vertex_texture()` 来绘制一个纹理是一样的，只是 `draw_sprite` 函数太常用，每次都写那么一串太麻烦了，才有了简单的一句话就搞定的 `draw_sprite()`。

然而在透视投影模式下坐标系发生了变换，再用 `draw_sprite()` 就会导致灾难了。用下图创建一个精灵，然后创建一个物体，在 Draw 事件添加代码如下：

![Sprite](/assets/images/three_d/sprite.png)

```c
d3d_set_projection_perspective(0, 0, room_width, room_height, 0);

draw_sprite(sprite0, 0, 100, 100);
```

把房间里的物体删了，放一个这个，运行，结果如下：

![Example](/assets/images/three_d/example4.png)

可以看到画出来的精灵居然竖直翻转了。这是因为 `draw_sprite()` 函数不知道你现在用的是什么投影，它只会把精灵纹理的左上、左下、右上、右下四个点映射到你要画的位置。也就是：

* 左上(0, 0) -> (100, 100)
* 左下(0, 1) -> (100, 356)
* 右上(1, 0) -> (356, 100)
* 右下(1, 1) -> (356, 356)

在普通的正交投影的坐标系中，(100, 100) 是在 (100, 356) 的上方；可在透视投影坐标系中，(100, 100) 却是在 (100, 356)的下方，所以整张纹理就发生了竖直翻转。

所以，如果你硬要在透视投影模式下用 `draw_sprite()`，`draw_text()` 之类绘制 2D 图形的话，就必须每次都自己重新计算一遍坐标，并且把竖直伸缩比例设置为 -1 才行。这无疑是很难受的。

另外，如果房间内的物体有的要进行 3D 绘制，有的要进行 2D 绘制的话，那么进行 3D 绘制的那些物体一定要注意设置完透视投影模式，执行绘制后把投影模式设置回来，要不然在它之后发生的 2D 绘制都得崩坏。

如果你的房间需要背景图或者图块，就像 F1 所说，最好不要用房间编辑器里的那些设置，因为你无法控制它们被绘制上去时的投影模式是透视投影还是正交投影。最好自己另外做一个物体，确保在正交投影模式下用 `draw_background()` 之类的函数作出绘制。

## 其他 3D 功能

GM8 提供的 3D 功能还包括以下方面：

1. 创建、保存和读取 3D 模型（完全使用代码，无可视性，且保存和读取的格式都仅限 GM 独家）
2. 设置灯光和雾（没怎么用过）
3. 暂存和读取变换方式（也就是说可以把当前的变换方式保存起来，以后要用的时候读出来即可。通过栈数据结构实现）

## GMS(2) 的 3D 功能

GMS1 中为了兼容，提供了和 GM8 的 d3d_系列函数相同的函数，但**顶点缓冲区**（Vertex Buffer），**矩阵**（Matrix）和 **gpu_系列函数**等更接近底层的功能已经出现；到了 GMS2，d3d_系列函数已被完全删除，3D 绘制功能都需要通过上述的三方面来实现。不过就我看来，只要弄懂了 3D 绘制的本质，GM8 和 GMS(2) 也没有什么难以理解的差别。

总而言之，无论是 GM 的哪个版本，3D 功能都是相对薄弱的功能，当玩具玩玩有益身心健康，要做出复杂的游戏功能还是换用 Unity 等其他游戏引擎的好。
