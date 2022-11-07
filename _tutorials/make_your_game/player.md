---
layout: post
title: 角色控制
nav_order: 1
parent: Make Your Game!
---

在[前一章]({{ site.baseurl }}{% link _tutorials/keyboard_mouse.md %}#人物的移动)，我们讲解了如何用几句代码就实现常规的**上下左右式移动**模式。再添加上碰撞固体检测的代码，就变成了：

```c
var U, D, L, R, _vFree, _hFree, _hvFree;
U = keyboard_check(vk_up);
D = keyboard_check(vk_down);
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
// 5是速度，实际使用时应换掉
vspeed = 5 * (D - U);
hspeed = 5 * (R - L);
vspeed /= sqrt((vspeed != 0) + (hspeed != 0));
hspeed /= sqrt((vspeed != 0) + (hspeed != 0));

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
if (!_hFree && _vFree)
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

下面是一些其他的操作方式的代码：

### 左右移动，空格跳跃

create 事件：

```c
// 跳跃速度，请自己修改值
jumpSpeed = 12;
// 重力，请自己修改值
grav = 0.6;
// 横向移动速度，请自己修改值
Hspd = 4;
// 最大下落速度，填 0 表示不设置限制
maxVspd = 10;
// 初始化跳跃状态，无需修改
jump = 0;
```

step 事件：

```c
var U, D, _S, _vFree, _hFree, _hvFree;
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
_S = keyboard_check_pressed(vk_space);
// 这里是处理水平移动的代码
hspeed = Hspd * (R - L);
// 检测角色脚下是不是地面，是就可以跳跃。
jump = place_free(x, y + 1);
// 这里是处理跳跃的代码。
if (_S && !jump)
{
    // sound_play(sndJump)是播放音效，括号内请填写自己的音效名。如果没有，请删除这一句。
    sound_play(sndJump);
    vspeed = -jumpSpeed;
}
// 这里是处理重力的代码
if (vspeed == 0 && !place_free(x, y + grav))
    gravity = 0;
else
    gravity = grav;
// 这里是限制下落速度的代码
if (maxVspd && vspeed > maxVspd)
    vspeed = maxVspd;
// 这里是处理固体碰撞的代码
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
if (!_hFree && _vFree)
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

### 左右移动，空格二段跳

create 事件：

```c
// 跳跃速度，请自己修改值
jumpSpeed[1] = 10;
jumpSpeed[2] = 8
// 重力，请自己修改值
grav = 0.6;
// 横向移动速度，请自己修改值
Hspd = 4;
// 最大下落速度，填0表示不设置限制
maxVspd = 10;
// 初始化跳跃状态，无需修改
jump = 0;
```

step 事件：

```c
var U, D, _S, isFirstJump, _vFree, _hFree, _hvFree;
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
_S = keyboard_check_pressed(vk_space);
// 这里是处理水平移动的代码
hspeed = Hspd * (R - L);
// 检测角色脚下是不是地面，是就可以一段跳。
isFirstJump = !place_free(x, y + 1);
if (isFirstJump)
    jump = 0;
else if (!jump)
    jump = 1;
// 这里是处理跳跃的代码。
if (_S && jump < 2)
{
    // sound_play(sndJump)是播放音效，括号内请填写自己的音效名。如果没有，请删除这一句。
    sound_play(sndJump);
    if (isFirstJump)
        vspeed = -jumpSpeed[1];
    else
        vspeed = -jumpSpeed[2];
    jump += 1;
}
// 这里是处理重力的代码
if (vspeed == 0 && !place_free(x, y + grav))
    gravity = 0;
else
    gravity = grav;
// 这里是限制下落速度的代码
if (maxVspd && vspeed > maxVspd)
    vspeed = maxVspd;
// 这里是处理固体碰撞的代码
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
if (!_hFree && _vFree)
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
