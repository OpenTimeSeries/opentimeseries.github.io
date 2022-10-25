---
layout: default
title: 粒子
nav_order: 26
---

在实现一些特效时，如烟花，下雨，迷雾等等，这些特效都是由大量的类似的基本单位所堆叠而成的，如果要用对象来实现这些特效，就需要生成巨量的实例。

而**粒子**（particle）就是在这种时候用来取代实例的。粒子可以看做一种极简化的实例，他也有各种各样的属性，如精灵，运动速度，方向，重力，混色，透明度等等，但是与实例不同的是，粒子没有索引，没有事件，不能执行代码，不会响应碰撞，没有父对。因此，相较于创建大量的实例而言，创建大量的粒子既能节省许多内存，也减少了计算的开销，特效不会轻易卡顿。当然，粒子也不是可以无限生成的，粒子数量多到一定程度也会变得卡顿掉帧。

## 层次

一个粒子特效可以分为三个层次：

* 最底层就是各种各样的粒子。
* 第二层是一些功能性组件，包含**发射器**（emitter，不断地产生粒子），**吸引器**（attractor，对粒子产生引力或斥力），**破坏器**（destroyer，将进入范围内的粒子摧毁），**偏转器**（deflector，偏转粒子运动方向）和**转换器**（changer，将进入范围内的一种粒子转换为另一种粒子）。
* 最高层是**粒子系统**（particle system），粒子系统 A 的功能性组件只会影响粒子系统 A 内的粒子，不会对另一个粒子系统 B 内的粒子造成影响。*每个粒子特效都要创建自己的粒子系统，即避免影响其他粒子特效，也避免被其他粒子特效所影响。*

## 简单粒子特效

由于制作一个粒子特效需要建立三个层次，过程十分麻烦，因此 GM8 提供了一些函数用来生成一些很简单的粒子特效，下面的函数会包办创建三个层次的所有过程：

* `effect_create_below(kind, x, y, size, color)` 在指定位置 (x, y) 创建粒子特效 kind，深度为 100000，参数 size 可选 0, 1, 2（从小到大），参数 color 会进行混色。
* `effect_create_above(kind, x, y, size, color)` 同上，但是深度为 -100000。
* `effect_clear()` 清除所有的简单粒子效果。参数kind的可选值有：
  * `ef_explosion` 爆炸
  * `ef_ring` 环形物
  * `ef_ellipse` 椭圆
  * `ef_firework` 烟花
  * `ef_smoke` 烟雾
  * `ef_smokeup` 上升的烟雾
  * `ef_star` 星星
  * `ef_spark` 火星
  * `ef_flare` 闪光
  * `ef_cloud` 烟云
  * `ef_rain` 雨水
  * `ef_snow` 雪花

## 创建粒子系统

制作粒子特效的第一步，先创建一个粒子系统：

* `part_system_create()` 创建一个新的粒子系统并返回其索引。
* `part_system_destroy(ind)` 销毁索引为 ind 粒子系统。注意粒子系统不会因为房间变动而自动销毁，所以大多数情况下需要手动销毁。粒子系统一旦销毁，里面的所有粒子都会一并被销毁
* `part_system_exists(ind)` 返回索引为 ind 的粒子系统是否存在。
* `part_system_clear(ind)` 清空索引为 ind 的粒子系统并恢复到默认设置，这将会移除粒子系统所有的粒子及其组件。

配置一下粒子系统的属性：

* `part_system_draw_order(ind, oldtonew)` 设置索引为 ind 的粒子系统中粒子的绘制顺序。当 oldtonew 为 true 时，新生成的粒子将绘制在旧的粒子的上方。反之则在下方。默认值是 true。
* `part_system_depth(ind, depth)` 设置索引为 ind 的粒子系统的深度。粒子系统中所有的粒子都会绘制在这个深度上。
* `part_system_position(ind, x, y)` 设置索引为 ind 的粒子系统的位置。之后我们给粒子和组件设置位置时，他们的位置都是相对位置，他们的 (0, 0) 是粒子系统的位置，也就是该函数设置的 (x, y) 位置。

默认情况下，**粒子系统会自动绘制在屏幕上**，不需要你调用什么函数。但是有的时候，我们并不想让它自动绘制，比如我们想让它绘制到**表面**上去，以配合混色或者其他的更多特效，那么你可能需要下面的函数：

* `part_system_automatic_update(ind, automatic)` 设置索引为 ind 粒子系统是否自动更新，默认值为 true。如果粒子系统设置为不自动更新的话，其中的所有粒子和组件都是静态的，不会移动，也不会做自己的事情。除非你调用下面这个函数。
* `part_system_update(ind)` 令索引为 ind 的粒子系统更新一次，也就是让粒子系统内的粒子和组件向前进一步。只能在 `part_system_automatic_update` 设置为 false 时使用该函数。
* `part_system_automatic_draw(ind, automatic)` 设置粒子系统是否自动绘制。默认值为 true。如果你要将其画在表面上，就要设置为 false。
* `part_system_drawit(ind)` 立即绘制索引为 ind 的粒子系统。当你使用 `surface_set_target` 指向表面后，调用该函数把粒子系统画在表面上。你只能在 `part_system_automatic_draw` 设置为 false 时使用该函数。

## 创建粒子类型

如果把粒子比作实例，那么粒子类型就是对象。粒子系统以粒子类型为模板创建粒子。我们可以为一个粒子系统设计多个不同的粒子类型。注意，虽然不同的粒子系统之间不能共享粒子，但是**粒子系统不占有粒子类型**，同一个粒子类型可以供给多个不同的粒子系统使用。同样的，粒子系统销毁时虽然会销毁其中的粒子，但是不会销毁粒子类型。

* `part_type_create()` 创建一个新的粒子类型并返回其索引。
* `part_type_destroy(ind)` 销毁索引为 ind 的粒子类型。
* `part_type_exists(ind)` 返回索引为 ind 的粒子类型是否存在。
* `part_type_clear(ind)` 清空索引为 ind 粒子类型，使其恢复到默认设置。

设置粒子类型的**形状**：

* `part_type_shape(ind,shape)` 设置索引为 ind 的粒子类型的形状为 shape。参数 shape 的可选值有（默认为 `pt_shape_pixel`）：
  * `pt_shape_pixel` 像素点
  * `pt_shape_disk` 圆盘
  * `pt_shape_square` 正方形
  * `pt_shape_line` 线形
  * `pt_shape_star` 星星
  * `pt_shape_circle` 圆形
  * `pt_shape_ring` 环形
  * `pt_shape_sphere` 球形
  * `pt_shape_flare` 闪光
  * `pt_shape_spark` 火星
  * `pt_shape_explosion` 爆炸
  * `pt_shape_cloud` 烟云
  * `pt_shape_smoke` 烟雾
  * `pt_shape_snow` 雪花

或者不使用预设的形状，而是使用自己的**精灵**：

* `part_type_sprite(ind, sprite, animat, stretch, random)` 设置索引为 ind 的粒子的精灵为 sprite。参数 animat（true 或 false）指定是否播放动画（即相当于实例中 `image_speed` 为 1 或者 0）。参数 stretch（true 或 false）为在粒子存活期内动画是否被拉伸，举个例子，假如一个粒子的存活时间为 50 步，而你设置它的精灵有 5 个子图，那么当 stretch 为 true 时，该粒子第 1-10 步使用子图 0，第 11-20 步使用子图 1，第 21-30 步使用子图 2，以此类推，使得粒子在它的生存周期内刚好播放完这个动画，如果 stretch 为 false，那么粒子将会一步换一次子图。参数 random（true 或 false）为是否选取随机子图开始（即相当于实例中的 `iamge_index = random(image_number)`）。

当你为粒子类型选定形状或者精灵之后，你可以设置它的**大小**和**朝向**：

* `part_type_size(ind, size_min, size_max, size_incr, size_wiggle)` 为索引为 ind 的粒子类型设置大小。粒子的初始大小将在 [size_min, size_max] 之间随机选取（以初始大小做为 1，可以是小数），之后，粒子大小每一步都会增加 [size_incr - size_wiggle, size_incr + size_wiggle] 之间随机的一个数值。
* `part_type_scale(ind, xscale, yscale)` 设置索引为 ind 的粒子类型的缩放。这个函数设置的 scale 与上述 size 是以乘法叠加的。
* `part_type_orientation(ind, ang_min, ang_max, ang_incr, ang_wiggle, ang_relative)` 为索引为 ind 的粒子类型设置形状或精灵的朝向。粒子的初始朝向将在 [ang_min, ang_max] 之间随机选取（默认角度为 0，使用角度制），之后，粒子朝向每一步都会增加 [ang_incr - ang_wiggle, ang_incr + ang_wiggle] 之间随机的一个数值。参数 ang_relative（true 或 false）指定朝向是否与运动方向相关联，当其他值都设置为 0 而 ang_relative 设置为 true 时，粒子的朝向会始终跟随其运动方向（即相当于实例中 `image_angle = direction`）。

之后，你可以设置粒子类型的**颜色**和**透明度**：

* `part_type_color1(ind, color1)` 为索引为 ind 的粒子类型指定一个颜色 color1。混色方式等同于 draw_sprite_general。
* `part_type_color2(ind, color1, color2)` 为索引为 ind 的粒子类型指定两个颜色，粒子刚出现时的颜色是 color1，随后渐变到 color2。
* `part_type_color3(ind, color1, color2, color3)` 为索引为 ind 的粒子类型指定三个颜色，粒子刚出现时的颜色是 color1，在粒子存活周期正中间刚好渐变到 color2，之后再渐变到 color3。
* `part_type_color_mix(ind, color1, color2)` 为索引为 ind 的粒子类型指定一个混合色。粒子刚出现时的颜色是 color1 与 color2 的混合，整个周期内颜色不会变化。
* `part_type_color_rgb(ind, rmin, rmax, gmin, gmax, bmin, bmax)` 为索引为 ind 的粒子类型指定一个随机的颜色，相当于 `make_color_rgb(random_range(rmin, rmax), random_range(gmin, gmax), random_range(bmin, bmax))`。
* `part_type_color_hsv(ind, hmin, hmax, smin, smax, vmin, vmax)` 为索引为 ind 的粒子类型指定一个随机的颜色，相当于 `make_color_hsv(random_range(hmin, hmax), random_range(smin, smax), random_range(vmin, vmax))`。
* `part_type_alpha1(ind, alpha1)` 设置索引为 ind 的粒子类型的透明度为 alpha（0-1）。
* `part_type_alpha2(ind, alpha1, alpha2)` 为索引为 ind 的粒子类型指定两个透明度，粒子刚出现时的透明度是 alpha1，随后渐变到 alpha2。
* `part_type_alpha3(ind, alpha1, alpha2, alpha3)` 为索引为 ind 的粒子类型指定三个透明度，粒子刚出现时的透明度是 alpha1，在粒子存活周期正中间刚好渐变到 alpha2，之后再渐变到 alpha3。

粒子不能执行代码，无法像实例一样通过 `draw_set_blend_mode` 改变自己的**混色方式**，但是你可以使用下面这个函数：

* `part_type_blend(ind, additive)` 设置索引为 ind 的粒子类型是否使用 `bm_add` 的混色方式（additive 为 true 或 false）。

每个粒子都有其**存活时间**，到达存活时间后会自动销毁，默认情况下，存活时间是 100 步，你可以通过下面的函数修改：

* `part_type_life(ind, life_min, life_max)` 设置索引为 ind 的粒子类型的存活时间，将在 [life_min, life_max] 中随机选取。
* `part_type_step(ind, step_number, step_type)` 设置索引为 ind 的粒子类型每一步都会生成 step_number 个索引为 step_type 的粒子类型的粒子。当 step_number 为负数时，例如 step_number 为 -5 时，每一步有 1/5 的概率会生成粒子，平均五步生成一个粒子。
* `part_type_death(ind, death_number, death_type)` 设置索引为 ind 的粒子类型时产生 death_number 个索引为 death_type 的粒子类型的粒子。同样 death_number 可以使用负数。注意，只有在粒子存活时间结束时才会生成粒子，被破坏器销毁不会生成粒子。

最后，我们为粒子类型设置**运动方式**：

* `part_type_speed(ind, speed_min, speed_max, speed_incr, speed_wiggle)` 为索引为 ind 的粒子类型设置速度。粒子的初始速度将在 [speed_min, speed_max] 之间随机选取（默认速度为 0），之后，粒子速度每一步都会增加 [speed_incr - speed_wiggle, speed_incr + speed_wiggle] 之间随机的一个数值。注意，速度永远不会降到 0 以下。
* `part_type_direction(ind, dir_min, dir_max, dir_incr, dir_wiggle)` 为索引为 ind 的粒子类型设置运动方向。粒子的初始运动方向将在 [dir_min, dir_max] 之间随机选取（默认运动方向为 0），之后，粒子运动方向每一步都会增加 [dir_incr - dir_wiggle, dir_incr + dir_wiggle] 之间随机的一个数值。
* `part_type_gravity(ind, grav_amount, grav_dir)` 为索引为 ind 的粒子类型设置重力。参数 grav_amount 是重力的大小，参数 grav_dir 是重力的方向（向下为 270）。

## 直接创建粒子

为粒子系统创建粒子有两种方式，一种是通过**发射器**，另一种就**是直接创建粒子**：

* `part_particles_create(ind, x, y, parttype, number)` 为索引为 ind 的粒子系统创建 number 个粒子类型为 parttype 的粒子。创建位置 (x, y) 是相对于粒子系统的位置，而不是房间的位置。
* `part_particles_create_color(ind, x, y, parttype, color, number)` 同上，不过增加了一种混色。注意，该函数当且仅当粒子类型没有设置颜色或者只设置了一种颜色时才生效。
* `part_particles_clear(ind)` 销毁索引为 ind 的粒子系统中所有的粒子。包括直接创建的粒子和发射器创建的粒子。
* `part_particles_count(ind)` 返回索引为 ind 的粒子系统中粒子的数量。包括直接创建的粒子和发射器创建的粒子。

## 发射器

**发射器**（emitter）有两种：一种是**爆发型发射器**，仅在一瞬间创建大量粒子，之后不再创建粒子；另一种是**持续型发射器**，会源源不断地生成粒子。一个粒子系统可以包含多个发射器。

* `part_emitter_create(ps)` 为索引为 ps 的粒子系统创建一个发射器并返回其索引。
* `part_emitter_destroy(ps, ind)` 销毁索引为 ps 的粒子系统中索引为 ind 的发射器。
* `part_emitter_destroy_all(ps)` 销毁索引为 ps 的粒子系统中所有发射器。
* `part_emitter_exists(ps, ind)` 返回索引为 ps 的粒子系统中索引为 ind 的发射器是否存在。
* `part_emitter_clear(ps, ind)` 将索引为 ps 的粒子系统中索引为 ind 的发射器重置到默认设置。
* `part_emitter_region(ps, ind, xmin, xmax, ymin, ymax, shape, distribution)` 设置索引为 ps 的粒子系统中索引为 ind 的发射器的分布区域和分布方法。发射器将在 (xmin, ymin) 和 (xmax, ymax) 为对角线的区域内随机位置生成粒子（每个粒子的位置都是随机的），参数 shape 指定区域形状，可选 `ps_shape_rectangle`（矩形），`ps_shape_ellipse`（椭圆形），`ps_shape_diamond`（菱形），`ps_shape_line`（线形），参数 distribution 指定分布方式，可选 `ps_distr_linear`（线性分布，各点概率相同），`ps_distr_gaussian`（高斯分布，在中心的概率高于边缘），`ps_distr_invgaussian`（逆高斯分布，在边缘的概率高于中心）。
* `part_emitter_burst(ps, ind, parttype, number)` 指定索引为 ps 的粒子系统中索引为 ind 的发射器爆发式生成粒子。参数 parttype 是生成的粒子类型，参数 number 是生成的粒子数量。发射器将在函数调用的一瞬间生成粒子，并且可以多次调用函数多次爆发式生成粒子。
* `part_emitter_stream(ps, ind, parttype, number)` 指定索引为 ps 的粒子系统中索引为 ind 的发射器连续不断地生成粒子。参数 parttype 是生成的粒子类型，参数 number 是每一步生成的粒子数量，同样的，number 可以为负数，代表每一步有 -1/number 的概率生成一个粒子。该函数只需调用一次就会让发射器源源不断地生成粒子。

## 吸引器

**吸引器**（attractor）会对粒子产生吸引力或者排斥力，以此改变粒子的行动轨迹。注意吸引器的处理速度较慢，不宜大量放置。

* `part_attractor_create(ps)` 为索引为 ps 的粒子系统创建一个吸引器并返回其索引。
* `part_attractor_destroy(ps, ind)` 销毁索引为 ps 的粒子系统中索引为 ind 的吸引器。
* `part_attractor_destroy_all(ps)` 销毁索引为 ps 的粒子系统中所有吸引器。
* `part_attractor_exists(ps, ind)` 返回索引为 ps 的粒子系统中索引为 ind 的吸引器是否存在。
* `part_attractor_clear(ps, ind)` 将索引为 ps 的粒子系统中索引为 ind 的吸引器重置到默认设置。
* `part_attractor_position(ps, ind, x, y)` 设置索引为 ps 的粒子系统中索引为 ind 的吸引器的位置为 (x, y)。该位置不是房间位置，而是相对粒子系统的位置。
* `part_attractor_force(ps, ind, force, dist, kind, aditive)` 设置索引为 ps 的粒子系统中索引为 ind 的吸引器的吸引力大小为 force（负数为排斥力），参数 dist 设置有效距离，只有离吸引器的距离小于 dist 的粒子才会受到作用，参数 kind 设置吸引器的类型，可选 `ps_force_constant`（吸引力大小为固定常量），`ps_force_linear`（距离越近吸引力越大，吸引力呈现线性增长，距离为 dist 的粒子受到的吸引力刚好为 0，距离为 0 的粒子受到的吸引力刚好为 force），`ps_force_quadratic`（距离越近吸引力越大，吸引力呈现二次曲线增长，距离为 dist 的粒子受到的吸引力刚好为 0，距离为 0 的粒子受到的吸引力刚好为 force），参数 additive 指定是否将吸引力叠加到粒子的速度和运动方向上（true）还是仅仅只改变粒子的位置（false）。

## 破坏器

**破坏器**（destroyer）会销毁进入区域内的粒子。一个粒子系统可以有多个破坏器。常见的方式是在房间外侧布置一圈破坏器，用来销毁超出房间范围的粒子。

* `part_destroyer_create(ps)` 为索引为 ps 的粒子系统创建一个破坏器并返回其索引。
* `part_destroyer_destroy(ps, ind)` 销毁索引为 ps 的粒子系统中索引为ind的破坏器。
* `part_destroyer_destroy_all(ps)` 销毁索引为 ps 的粒子系统中所有破坏器。
* `part_destroyer_exists(ps, ind)` 返回索引为 ps 的粒子系统中索引为 ind 的破坏器是否存在。
* `part_destroyer_clear(ps, ind)` 将索引为 ps 的粒子系统中索引为 ind 的破坏器重置到默认设置。
* `part_destroyer_region(ps, ind, xmin, xmax, ymin, ymax, shape)` 设置索引为 ps 的粒子系统中索引为 ind 的破坏器的作用域。作用域范围由 (xmin, ymin) 和 (xmax, ymax) 决定，作用域的形状 shape 可选值有 `ps_shape_rectangle`（矩形），`ps_shape_ellipse`（椭圆形），`ps_shape_diamond`（菱形）。

## 偏转器

**偏转器**（deflector）使进入作用域的粒子发生偏转。更准确的说，偏转器类似于 `move_bounce_all`，真正有用的是偏转器的边界，他会将触碰到边界的粒子反弹。偏转器有水平偏转和垂直偏转两种，通常对应垂直墙壁和水平墙壁。如果从一个水平偏转器的上方触碰到偏转器，粒子会进入偏转器内不断地每一步都偏转其水平速度，就会变得非常鬼畜，直到粒子离开偏转器为止。因此，设置偏转器的作用范围要注意不要让粒子从不应该进入的方向进入到偏转器内部。

* `part_deflector_create(ps)` 为索引为 ps 的粒子系统创建一个偏转器并返回其索引。
* `part_deflector_destroy(ps, ind)` 销毁索引为 ps 的粒子系统中索引为 ind 的偏转器。
* `part_deflector_destroy_all(ps)` 销毁索引为 ps 的粒子系统中所有偏转器。
* `part_deflector_exists(ps, ind)` 返回索引为 ps 的粒子系统中索引为 ind 的偏转器是否存在。
* `part_deflector_clear(ps, ind)` 将索引为 ps 的粒子系统中索引为 ind 的偏转器重置到默认设置。
* `part_deflector_region(ps, ind, xmin, xmax, ymin, ymax)` 设置索引为 ps 的粒子系统中索引为 ind 的偏转器的作用域。作用域一定是矩形，由 (xmin, ymin) 和 (xmax, ymax) 构成的对角线决定。
* `part_deflector_kind(ps, ind, kind)` 设置索引为 ps 的粒子系统中索引为 ind 的偏转器的类型。 kind 可选值有：`ps_deflect_horizontal`（粒子偏转水平速度），`ps_deflect_vertical`（粒子偏转垂直速度）。
* `part_deflector_friction(ps, ind, friction)` 设置索引为 ps 的粒子系统中索引为 ind 的偏转器的阻力大小，偏转器偏转粒子之后会令其减速 friction 值，以显得更加真实。

## 转换器

**转换器**（changer）使进入范围内的某种粒子转换为另一种粒子。同样，一个粒子系统可以有多个转换器。

* `part_changer_create(ps)` 为索引为 ps 的粒子系统创建一个转换器并返回其索引。
* `part_changer_destroy(ps, ind)` 销毁索引为 ps 的粒子系统中索引为 ind 的转换器。
* `part_changer_destroy_all(ps)` 销毁索引为 ps 的粒子系统中所有转换器。
* `part_changer_exists(ps, ind)` 返回索引为 ps 的粒子系统中索引为 ind 的转换器是否存在。
* `part_changer_clear(ps, ind)` 将索引为 ps 的粒子系统中索引为 ind 的转换器重置到默认设置。
* `part_changer_region(ps, ind, xmin, xmax, ymin, ymax, shape)` 设置索引为 ps 的粒子系统中索引为 ind 的转换器的作用域。作用域范围由 (xmin, ymin) 和 (xmax, ymax) 决定，作用域的形状 shape 可选值有 `ps_shape_rectangle`（矩形），`ps_shape_ellipse`（椭圆形），`ps_shape_diamond`（菱形）。
* `part_changer_types(ps, ind, parttype1, parttype2)` 设置索引为 ps 的粒子系统中索引为 ind 的转换器将粒子类型为 parttype1 的粒子转换为 parttype2。
* `part_changer_kind(ps, ind, kind)` 设置转换器的种类。参数 kind 的可选值有：`ps_change_motion`（仅转换运动状态），`ps_change_shape`（仅转换形状），`ps_change_all`（完全转换）。

## Particle Designer

设计一个粒子特效是件很复杂又头疼的事情，因为你通常要使用大量的函数，设置大量的参数，甚至会感到一丝代码密集恐惧症。另一方面，粒子特效的参数设置不直观，设置一个参数需要反复地运行游戏才能调整好。

因此，Particle Designer 作为一个有 GUI 的，参数直观的粒子设计器应运而生。

下载地址：[Particle Designer v2.5.3](https://pan.baidu.com/s/1djmoucglVW42vWuACzn1Hg)

主窗口截图：

![Particle Designer](/assets/images/particle/particle_designer.png)

几乎每一个 GML 中的参数函数都能在 Particle Designer 中找到对应的设置。而且 Particle Designer 非常直观，修改好参数后只需要鼠标点击屏幕中空白的部分，就可以快速预览粒子的效果。同时，Particle Designer 也提供随机效果，脑洞匮乏的时候可以跑几个随机看看有没有心仪的粒子效果。

当你设计好粒子特效后，可以点击 Export->Entire System->GML 导出为 .gml 文件，该文件可以用 GM8 导入为脚本，或者也可以直接右键以记事本打开，直接复制其中的代码。
