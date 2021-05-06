---
layout: default
title: step事件模拟碰撞事件
nav_order: 3
parent: 碰撞
---

我们很久以前就提到过，可以用step事件去取代别的事件，这样可以随心地自己掌控各个事件的执行顺序。比如，在碰撞事件中，如果一个实例有两个碰撞事件，并且在同一步内都触发了，那么哪个碰撞事件先执行？猜测GM的执行顺序是一件痛苦的事，所以不如由自己来掌控执行顺序。

对于普通的非固体碰撞，在步事件里`if(place_meeting(x, y, obj){ xxxxxx; }`就能达成和碰撞事件一样的效果了，如果要模拟other，可以用`inst = instance_place(x, y, obj); if(inst) { xxxxxx; }`，通过inst来代替other。

所以重点就是如何模拟并取代固体的碰撞。首先，我们要知道，固体碰撞实际上有很多的问题，最明显的问题就是当速度比较大的时候，容易出现下面这种情况：

![Result Solid](/assets/images/collision/result_solid3.gif)

objBall悬停在objBlock的上方。当参与固体碰撞的二者之间的距离小于实例的相对速度时，固体碰撞事件是不会自动帮你补全这段距离的。

用step的解决思路是（注意，被碰撞方仍要勾选固体属性）：

```c
_vFree = place_free(x, y + vspeed + gravity) || place_free(x + hspeed, y + vspeed + gravity);
if (!_vFree) {
    if (vspeed <= 0)
        move_contact_solid(90, abs(vspeed + gravity));
    if (vspeed > 0)
        move_contact_solid(270, abs(vspeed + gravity));

    vspeed = 0;
    gravity = 0;
}

_hFree = place_free(x + hspeed, y);
if(!_hFree && _vFree)
    _hFree = place_free(x + hspeed, y + vspeed + gravity);
if (!_hFree) {
    if (hspeed <= 0)
        move_contact_solid(180, abs(hspeed));
    if (hspeed > 0)
        move_contact_solid(0, abs(hspeed));

    hspeed = 0;
}

_hvFree = place_free(x + hspeed, y + vspeed + gravity)
if (!_hvFree)
    hspeed = 0;
```

_vFree是预判实例下一帧是否会在**垂直方向**碰撞到objBlock，_hFree则是预判**水平方向**，_hvFree预判**斜角方向**。注意_vFree不仅检测了垂直方向，还检测了斜角方向，这是对操作手感的一种优化：如果斜角方向没有碰撞block，则向斜角方向移动；如果不一起检测斜角方向的话，player会再垂直下落一帧再向斜角运动，这可能导致player无法进入一些明显高度大于它的缝隙中。_hFree的两段赋值也是同理。

* `move_contact_solid(dir, maxdist)` 以速度maxdist向dir方向运动，碰撞到固体时会停止。这个函数的特点是，如果最后一步与固体的距离小于maxdist，会补全这一段距离。

效果如下：

![Result Solid](/assets/images/collision/result_solid4.gif)

注意这里使用了`!place_free()`的判定，所以对一切固体实例都会生效，如果你只想对某个特定对象或实例生效，应该改用`place_meeting()`，但是这在很复杂的地形中可能会出现问题，所以不建议单独对特定对象或实例进行固体碰撞，而应该善用GM的固体属性，把不能穿透的物体都设置为固体。

值得注意的是，上述代码写在碰撞事件中也是有效的，如果你觉得麻烦不想用step，想用碰撞事件也可以的。
