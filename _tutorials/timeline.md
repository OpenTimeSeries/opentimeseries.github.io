---
layout: default
title: 时间轴
nav_order: 32
---


**时间轴**（Time Line）是GameMaker中的一种资源，放在第七个文件夹中：

![Game Maker](/assets/images/timeline/gamemaker.png)

一个时间轴可以视为由多个计时器集成而来的，到达指定步数时就执行对应的代码，因此适合用来制作音游。通过`步数=时间x帧率`，你可以快速计算出音乐的某个鼓点对应的步数。

![Timeline](/assets/images/timeline/timeline.png)

*注意：时间轴中的变量属于实例的变量，同样，时间轴中也可以访问实例的变量。*

## 设置时间轴

* `timeline_index` 实例所使用的时间轴，默认为-1，即无时间轴。
* `timeline_running` 是否启用实例的时间轴。默认为false。
* `timeline_position` 实例当前的时间轴位置，单位为步，可以精确定位时间轴运行到何处。
* `timeline_speed` 实例当前的时间轴速度，默认为1。设置为0可以暂停时间轴。该函数会影响到`timeline_position`的变化。如果你设置的速度很大，那么GM8可能会把一些临近步压缩在同一步执行，但是可以放心的是，不管时间轴速度多大，时间轴不会丢失步。
* `timeline_looping` 是否循环播放实例的时间轴。默认为false。
* `timeline_exists(ind)` 返回指定的索引为ind的时间轴是否存在。

## 动态创建时间轴

也许你有时候需要动态创建时间轴，例如，你制作的音游提供一个编辑器的功能，可以让玩家自己设计谱面并且播放。

* `timeline_add()` 创建一个时间轴并返回其索引。
* `timeline_delete(ind)` 删除索引为ind的时间轴，注意，你应当只删除通过`timeline_add()`创建的时间轴。
* `timeline_clear(ind)` 删除索引为ind的时间轴的所有步数和代码，但不删除时间轴本身。
* `timeline_moment_add(ind, step, codestr)` 在索引为ind的时间轴中，步数为step的位置增加代码串codestr（以字符串形式）。注意，该函数是叠加的，不会清除该步原有的代码。
* `timeline_moment_clear(ind, step)` 清除索引为ind的时间轴中，步数为step的位置的所有代码。
