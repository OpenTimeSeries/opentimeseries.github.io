---
layout: default
title: 键盘与鼠标
nav_order: 12
---

## 键盘事件

键盘事件分为三类，**键盘事件**（Keyboard Event），**按下键盘事件**（Keyboard Press Event），**放开键盘事件**（Keyboard Release Event）。

![Keyboard Event](/assets/images/keyboard_mouse/keyboard_event.png)

这三者的区别，估计大家也忘记的差不多了，这里再讲解一下：

1. 键盘事件，是只要某个键保持按住的状态，就会每一步都执行一次。
2. 按下键盘事件，是某个按键按下的这一步才会执行一次，之后按住键盘并不会触发这个事件。
3. 松开键盘事件，是某个按键松开的这一步才会执行一次。

在这之中，又可以再选择不同键的键。

![Key](/assets/images/keyboard_mouse/key.png)

键盘事件没啥好讲的，因为键盘事件在处理玩家角色操作时非常无力，一般都用代码来控制玩家角色的操作。

一般键盘事件更多用于全局的键盘操作，比如[按 R 键 restart]({{ site.baseurl }}{% link _tutorials/make_your_game/data.md %}#杀死玩家记录死亡数)，[按 backspace 键回到选关页]({{ site.baseurl }}{% link _tutorials/make_your_game/level_design.md %}#选关页)，[按 P 键暂停什么]({{ site.baseurl }}{% link _tutorials/make_your_game/pause.md %}#show_message-法)的。

## 鼠标事件

![Mouse Event](/assets/images/keyboard_mouse/mouse_event.png)

鼠标事件一般用的比键盘事件要更多，除非是鼠标操作很复杂的游戏，比如扫雷，有左键按住，左键松开，右键松开，右键按住，左右同时松开等等复杂的鼠标操作，才会在 step 里用代码去取代鼠标事件。

不过其实，鼠标事件其实也没啥好讲，毕竟中文大家都看的懂，，，，，，唯一值得注意的是，除了全局鼠标事件外，其他的鼠标事件都是只有当鼠标放在实例的碰撞盒内部才会生效的。

**全局鼠标事件**则是不管鼠标点在窗口的什么位置，都会执行的事件。

这里提一下**鼠标靠近事件**（Mouse Enter Event）和**鼠标离开事件**（Mouse Leave Event），事实上前者我认为翻译为鼠标进入事件更为准确。鼠标靠近事件发生在鼠标从实例的碰撞盒外进入到实例的碰撞盒内部这一步，鼠标离开事件发生在鼠标从实例的碰撞盒内移到实例的碰撞盒之外的这一步。

## 跟随鼠标

GM内置了两个变量来接受鼠标的位置：`mouse_x`，`mouse_y`，分别代表鼠标相对于游戏窗口的坐标。注意，这两个值只能读取，不能修改。

如果你需要一个实例始终跟随鼠标的话，你应该在他的对象的步事件中添加：

```c
x = mouse_x;
y = mouse_y;
```

由于 GM 对鼠标位置的读取是发生在一步的最开始，而绘制在一步的末尾，所以跟随鼠标的实例看起来无论如何都会落后鼠标光标一步。

## 光标

本节内容位于 GML 汉化文档 56-57 页。

* `window_set_cursor(curs)` 设置游戏窗口的光标类型。参数 curs 必须使用 GM 内置的常量。所有常量请自行查阅 GML 汉化文档，这里不一一列出。常用的是用 `cr_none` 来隐藏鼠标，然后用一个对象实例跟随鼠标以实现自定义光标的效果。
* `window_get_cursor()` 返回当前使用的光标类型。
* `cursor_sprite` GM 内置变量，可以用精灵给它赋值，GM 会用这个精灵来替代光标图案。赋值 -1 则可以返回系统默认光标。

## 鼠标检测

本节内容位于 GML 汉化文档 40 页。

`mouse_check_button(numb)`，`mouse_check_button_pressed(numb)`，`mouse_check_button_released(numb)` 这三个函数分别用来检测鼠标键是否按住、按下、松开，与鼠标事件相互对应，返回值为1或0。

注意：鼠标检测函数全部是全局鼠标检测。

numb 只有四个参数可选：

* `mb_none` 无按键
* `mb_left` 鼠标左键
* `mb_middle` 鼠标中键
* `mb_right` 鼠标右键

## 键盘检测

`keyboard_check(key)`，`keyboard_check_pressed(key)`，`keyboard_check_released(key)` 这三个函数分别用来检测某个键是否按住、按下、松开，与三种键盘事件相对应，返回值为 1 或者 0。

参数 key 可以使用 GM 的内置常量（一般都是以 vk_xxx 的形式），如：`vk_up` 代表方向上键，`vk_space` 代表空格键，`vk_shift` 代表 shift 键，`vk_f1` 代表 F1 键，`vk_numpad0` 代表小键盘 0 键，更多按键参考 GML 汉化文档。

如果要检测字母键，以及字母键盘上方的数字键，应该使用 `ord('A')`，`ord('1')` 的形式，字母一定要大写，例如

```c
if (keyboard_check(ord('W')))
  xxxxx;
```

---

`keyboard_check_direct(key)` 这个函数是 `keyboard_check` 的扩展版，从硬件直接检测键盘操作，这样就可以提供区分左右的键盘检测。

以下是只能用在 keyboard_check_direct 里的常量：

* vk_lshift 左shift 键
* vk_lcontrol 左ctrl键
* vk_lalt 左alt键
* vk_rshift 右shift键
* vk_rcontrol 右ctrl键
* vk_ralt 右alt键

除此之外，`keyboard_check` 不能在游戏失焦时判断某个键是否按注，但是 `keyboard_check_direct` 在游戏失焦时仍然能判断某个键是否按住。另外，`keyboard_check` 会在房间变换后中断检测，如果你一直按着右键，然后角色向右移动进入了传送门，之后切换房间到下一个关卡，但是这个过程中你的右键一直没有松开的话，在新的房间里，角色并不会继续向右移动，你要松开右键，重新按下右键才能被 `keyboard_check` 识别，而 `keyboard_check_direct` 则不会，切换房间之后角色仍然保持向右运动。

## 人物的移动

现在我们来讲一讲为什么键盘事件不适合用来做玩家角色操作。（嫌啰嗦可以直接跳过，无碍）

较为传统的小游戏，玩家角色操作一般是上下左右移动。那么我们至少要新建八个键盘事件。为什么是八个？首先，你至少要新建四个对应方向键的键盘事件或者按下键盘事件，在其中对应地为 hspeed 或者 vspeed 赋值，这样角色才能动起来。但是，当你松开方向键时，GM 并不会自动把玩家角色的速度归零，你又要有四个松开键盘事件来让玩家角色能停下来。

如果你真的这样做了，那你肯定会焦头烂额。为什么呢？你会发现，你无法处理同时按两个相对的按键，即同时按左右键，和同时按上下键的情况，或者按三个键以上的情况。GM 的左键事件先于右键事件，上键事件先于下键事件，所以同时按左右，实际上是向右走的，而同时按上下，实际上是向下走的，而不是停在原地。

这时，可能会有聪明的读者想出这么一种方案：建立四个方向键的按下键盘事件，分别用 `hspeed += 5;`, `hspeed -= 5;`, `vspeed += 5;`, `vspeed -= 5;` 来触发运动，然后再建立四个松开键盘事件，内容则和按下键盘事件相反（即原本 `vspeed += 5;` 就改成 `vspeed -= 5;`）。如果你能想到这个方案，可以说明你是真的很聪明了，这个方案可以说是完美解决了同时按下相对按键的问题。

但是，这个方案仍然存在一些问题，第一，这个方案对于更复杂的操作方式仍然显得十分无力。第二，有些不可抗力会导致这个方案出 bug，我们知道 Windows 的焦点只能在一个窗口上，如果出现什么弹窗，或者杀了病毒，或者安装补丁什么的，把焦点从游戏中移开了，但是 GM 游戏只有在焦点在自己身上时才会读取键盘操作，也就是说，如果你按着上键，角色向上移动，这个时候游戏突然失去焦点，游戏不再读入键盘数据，这时你松开上键，角色依然会继续向上移动，而且这之后焦点再回到游戏窗口，还会更惨，你再按下键，角色会停止，而不是向下移动，再松开下键，角色又向上移动了。第三，也是最关键的，如果斜向运动，速度是根号 2 倍，无法做到斜向运动和横向竖向保持一样的速度，如果是做 stg 这是很致命的。

*以下是正题：*

在 step 中进行键盘判定，通常是这样开头：

```c
var U, _U, U_, D, _D, D_, L, _L, L_, R, _R, R_;
U = keyboard_check(vk_up);
_U = keyboard_check_press(vk_up);
U_ = keyboard_check_release(vk_up);
D = keyboard_check(vk_down);
_D = keyboard_check_press(vk_down);
D_ = keyboard_check_release(vk_down);
L = keyboard_check(vk_left);
_L = keyboard_check_press(vk_left);
L_ = keyboard_check_release(vk_left);
R = keyboard_check(vk_right);
_R = keyboard_check_press(vk_right);
R_ = keyboard_check_release(vk_right);
```

*注：实际用到哪些就写哪些，不用全部写。`U` 表示按住上键，`_U` 表示按下上键，`U_` 表示松开上键，其余类推。这些变量名只是我个人的写法，并不需要也这样写。*

如果不考虑到斜向运动速度会比横向纵向速度更大的问题，那么实现运动的代码就非常简单：

```c
var U, D, L, R;
U = keyboard_check(vk_up);
D = keyboard_check(vk_down);
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
// 5 是速度，实际使用时应换掉
vspeed = 5 * (D - U);
hspeed = 5 * (R - L);
```

短短 7 行，就能实现移动，并且可以解决同时按下相对键或三个键以上的问题，并且在游戏失焦时会自动停止，比起用八个事件八句代码简洁了不知道多少。实际上，如果把 `keyboard_check` 直接替换变量 U, D, L, R，只需要两行即可，但是代码可读性变差，而且可延展性也差，不建议这样写。

如果要让斜向运动也和横向竖向运动保持一样的速度，个人的方案为：

```c
var U, D, L, R;
U = keyboard_check(vk_up);
D = keyboard_check(vk_down);
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
// 5 是速度，实际使用时应换掉
vspeed = 5 * (D - U);
hspeed = 5 * (R - L);
vspeed /= sqrt((vspeed != 0) + (hspeed != 0));
hspeed /= sqrt((vspeed != 0) + (hspeed != 0));
```

最后两行很难理解，理解不了无需强迫自己理解。如果有 GM8 大佬看到这个，可能会觉得除数可以是 0 而导致 bug，但实际上 GM8 对 `var /= 0` 的操作有特殊的保护机制，不会报错，也不会改变 var 的值。嗯我承认这确实很诡秘。

Ray 提供的方案 1：

```c
var U, D, L, R;
U = keyboard_check(vk_up);
D = keyboard_check(vk_down);
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
// 5 是速度，实际使用时应换掉
vspeed = 5 * (D - U);
hspeed = 5 * (R - L);
vspeed *= max(sqrt(0.5), L == R);
hspeed *= max(sqrt(0.5), U == D);
```

Ray 提供的方案 2：

```c
var U, D, L, R;
U = keyboard_check(vk_up);
D = keyboard_check(vk_down);
L = keyboard_check(vk_left);
R = keyboard_check(vk_right);
// 5 是速度，实际使用时应换掉
vspeed = 5 * (D - U);
hspeed = 5 * (R - L);
vspeed *= sqrt(((L == R) + 1) / 2);
hspeed *= sqrt(((U == D) + 1) / 2);
```

欢迎更多大佬提供自己的解决方案！
