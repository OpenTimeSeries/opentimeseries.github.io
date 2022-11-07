---
layout: post
title: 显示与窗口控制
nav_order: 33
---

## 三种坐标系

在本章之前，我们提到的所有的坐标都是基于**房间坐标系**（Room Coordinate System）的，也就是以房间左上角为原点，向右为 x 轴，向下为 y 轴的坐标系。现在，我们来了解一下 GM8 的另外两种坐标系，**显示坐标系**（Display Coordinate System）——以屏幕左上角为原点的坐标系，和**窗口坐标系**（Window Coordinate System）——以窗口左上角为原点的坐标系（包含标题栏和边框）。

GM8提供获取和设置鼠标在三种不同坐标系下的坐标的方法：

* `mouse_x` 获取鼠标在房间坐标系下的 x 坐标。
* `mouse_y` 获取鼠标在房间坐标系下的 y 坐标。
* `window_views_mouse_get_x()` 等同于 `mouse_x`。
* `window_views_mouse_get_y()` 等同于 `mouse_y`。
* `window_views_mouse_set(x, y)` 设置鼠标位置到房间坐标系的 (x, y) 处。
* `window_view_mouse_get_x(id)` 如果同时开启了多个视野，那么鼠标的房间坐标对于不同视野而言是不一样的，例如视野 0 的 `view_x[0]` 是 100，而视野 1 的 `view_x[1]` 是 200，当鼠标放在左上角时，对于视野 0 而言鼠标指向房间 `x=100` 处，而对于视野 1 而言，鼠标指向房间 `x=200` 处。在这种情况下，你可以使用 `window_view_mouse_get_x(id)` 分别获取各个视野中鼠标的房间坐标的 x。启用单视野时，该函数等同于 `mouse_x`。
* `window_view_mouse_get_y(id)` 同上，在启用多视野时分别获取各个视野中鼠标的房间坐标的y。启用单视野时，该函数等同于 `mouse_y`。
* `window_view_mouse_set(id, x, y)` 同上，在启用多视野时，以索引为 id 的视野为基准设置鼠标的房间坐标。
* `window_mouse_get_x()` 获取鼠标在窗口坐标系下的 x 坐标。
* `window_mouse_get_y()` 获取鼠标在窗口坐标系下的 y 坐标。
* `window_mouse_set(x, y)` 设置鼠标位置到窗口坐标系的 (x, y) 处。
* `display_mouse_get_x()` 获取鼠标在显示坐标系下的 x 坐标。
* `display_mouse_get_y()` 获取鼠标在显示坐标系下的 y 坐标。
* `display_mouse_set(x, y)` 设置鼠标位置到显示坐标系的 (x, y) 处。

## 显示控制

通常来说，直接改变用户显示设置是比较冒险的事情，但是有时候为了提供更好的显示效果，不少游戏会改变用户的分辨率（比如东方系列）。由于 GM8 提供函数可以重置所有显示设置，因此倒也不算是什么需要避讳的事情。

* `display_get_width()` 返回显示的分辨率宽度。
* `display_get_height()` 返回显示的分辨率高度。
* `display_get_colordepth()` 返回显示的色深。
* `display_get_frequency()` 返回显示的刷新率。
* `display_set_size(w, h)` 设定显示的分辨率，单位像素。返回是否成功。只有某些特定的组合才能成功，即通过系统设置能修改的那些组合。
* `display_set_colordepth(coldepth)` 设置色深为 16 和 32 二者之一。返回是否成功。
* `display_set_frequency(frequency)` 设置屏幕刷新率。返回是否成功。只有某些特定的组合才能成功（ 比如 60、75、85 等等），即通过系统设置能修改的那些组合。
* `display_set_all(w, h, frequency, coldepth)` 一次性设置上述所有值。参数填 -1 代表不更改。返回是否成功。
* `display_test_all(w, h, frequency, coldepth)` 返回给定的设置是否允许。参数填 -1 代表不更改。
* `display_reset()` 将设置重置到程序初始时的状态。

## 窗口控制

相比于显示控制，窗口控制的使用程度要高上许多，而且安全度也高。

* `window_set_visible(visible)` 设置游戏窗口是否可见。处于不可见状态的窗口不会响应任何键鼠事件。
* `window_get_visible()` 返回游戏窗口是否可见。
* `window_set_fullscreen(full)` 设置窗口是否为全屏模式。
* `window_get_fullscreen()` 返回窗口是否处于全屏模式。
* `window_set_showborder(show)` 设置是否显示窗口的边框（全屏模式下不显示）。该函数会影响窗口坐标系下的鼠标坐标。
* `window_get_showborder()` 返回窗口是否显示边框。
* `window_set_showicons(show)` 设置是否显示窗口右上角的最小化，最大化，关闭按钮（全屏模式下不显示）。
* `window_get_showicons()` 返回窗口是否显示右上角按钮。
* `window_set_stayontop(stay)` 设置窗口是否置顶。
* `window_get_stayontop()` 返回窗口是否置顶。
* `window_set_sizeable(sizeable)` 设置窗口大小是否可以被玩家调整。
* `window_get_sizeable()` 返回窗口大小是否可以被玩家调整。
* `window_set_caption(caption)` 设置窗口标题。由于有 `room_caption` 的存在，该函数并不是那么有用。
* `window_get_caption()` 返回窗口标题。
* `window_set_color(color)` 设置窗口的底色。
* `window_get_color()` 返回窗口底色。
* `window_set_region_scale(scale, adaptwindow)` 如果窗口比当前房间大，通常画面就会拉伸到接触窗口边框，并且显示在窗口的中心位置。你可以设置 scale 为 1 使得画面不进行缩放，保持原本大小居中，四周填充底色，在此设置下窗口不能调整到比房间小；当 scale 为其他正数时，画面会扩大到scale 倍；设置为 0 时，画面将填充到整个窗口，不保持原本的宽高比；而设置为负数时，画面会在保持宽高比的情况下，尽可能地拉伸到最大，也就是默认的情况。adaptwindow 仅在 scale 为 0\~1 之间时生效，默认情况下（即 adaptwindow 为 false）当 scale 大于 1 时，窗口也会随之放大相同倍数以显示画面内容，但是当 scale 为 0\~1 时，默认的情况下窗口会保持原本的大小，缩小的画面则位于中心，四周以底色填充。设置 adaptwindow 为 true，则当 scale 为 0\~1 时，窗口会自动缩小相同倍数以适配画面的大小。
* `window_get_region_scale()` 返回上述函数设置的 scale 值。
* `window_set_position(x, y)` 设置窗口位于显示坐标系下的位置。
* `window_set_size(w, h)` 设置窗口的大小。注意该函数的优先级低于 `window_set_region_scale`，如果冲突了会以 `window_set_region_scale` 为准。
* `window_set_rectangle(x, y, w, h)` 设置窗口的位置和大小。
* `window_center()` 将窗口移动至屏幕正中央。
* `window_default()` 将窗口重置为默认大小和位置（居中显示）。
* `window_get_x()` 返回窗口在显示坐标系的x坐标。
* `window_get_y()` 返回窗口在显示坐标系的y坐标。
* `window_get_width()` 返回窗口宽度。
* `window_get_height()` 返回窗口高度。

## 鼠标光标

**鼠标光标**（mouse cursor）又叫**鼠标指针**（mouse pointer），即通过在屏幕中显示一些形如箭头的图像，以识别鼠标在屏幕中位置。同时，通过不同的图像，也表现出不同的状态。

要想改变鼠标光标，使用以下函数。下面函数的效果取决于用户所使用的光标主题：

* `window_set_cursor(curs)` 设置窗口内鼠标指针的类型。你可以使用如下几种鼠标指针类型，特别的，隐藏鼠标使用 `cr_none`：
  * `cr_default` 默认
  * `cr_none` 无
  * `cr_arrow` 箭头
  * `cr_cross` 十字
  * `cr_beam` 工形
  * `cr_size_nesw` 右斜双箭头
  * `cr_size_ns` 垂直双箭头
  * `cr_size_nwse` 左斜双箭头
  * `cr_size_we` 水平双箭头
  * `cr_uparrow` 上箭头
  * `cr_hourglass` 沙漏
  * `cr_drag` 拖拽
  * `cr_nodrop` 不能拖拽
  * `cr_hsplit` 水平分离
  * `cr_vsplit` 垂直分离
  * `cr_multidrag` 复数拖拽选中
  * `cr_sqlwait` SQL 等待
  * `cr_no` 拒绝
  * `cr_appstart` 载入中
  * `cr_help` 帮助
  * `cr_handpoint` 手指
  * `cr_size_all` 全向箭头
* `window_get_cursor()` 返回窗口中使用的鼠标指针类型。

你也可以使用自己的精灵图像作为鼠标指针使用：

* `cursor_sprite` 使用精灵来取代鼠标指针的绘制，默认为 -1。
