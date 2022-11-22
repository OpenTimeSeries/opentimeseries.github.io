---
layout: post
title: 素材
nav_order: 1
parent: 初识GameMaker
---
## 获取素材

> ***WARNING***
>
> 如果你要制作商业性质游戏，所有素材必须要有授权或完全原创！

### 获取图像素材

最好办法当然是勾搭一个（或多个）美工。而像我这种勾搭不上美工的，就只能到处抠图了（偷偷安利东方素材：[http://pan.baidu.com/s/1o8NYoQm](http://pan.baidu.com/s/1o8NYoQm)）。

一般来说，我们拿到的图不可能刚好满足我们的需求，这个时候 GM 自带的图像编辑器可以帮我们大忙。

### 获取音乐素材

一般来讲做个**非商业性质**小游戏偷偷用一下别人的音乐是没有太大关系的（除非作者明确表示了非商业性使用也禁止）。如果你担心出事的话，那么下面这个网站就是为你准备的：

* [魔王魂](https://maoudamashii.jokersounds.com/music_bgm.html)

这个网站是**完全免费**的原创音乐素材网站，里面的音乐资源授权给任何人使用。（使用网站需要一点**日语**功底）

## 导入素材

精灵（Sprites）可以导入静图也可以导入 gif 动态图，而背景（Backgrounds）只允许导入静图。

方法一：直接将素材文件拖入 GM8 中，如图所示：

![Drag Import](/assets/images/start/drag_import.png)

如果是图片素材，拖入时会询问你是创建一个 Sprite 还是 Background，根据实际选择即可：

![Sprite Or Background](/assets/images/start/sprite_or_background.png)

---

方法二：通过功能栏新建

![Topbar Import](/assets/images/start/topbar_import.png)

从左到右分别是创建 Sprite/Sound/Background/Path/Script/Font/Timeline/Object/Room

只有第一、二、三是可以导入外部素材的。

以创建 Sprite 为例，会出现下面这个弹窗：

![Sprite Window](/assets/images/start/sprite_window.png)

点**载入精灵**。选择文件，此时右边有四个选项：

![Import Image](/assets/images/start/import_image.png)

从上到下分别是：显示预览，不透明化（如果图片本身有透明区域），清除底色，平滑边缘。

这里要提一下，GM8 清除底色的机理，是将**最左下角的点**的颜色当做底色，将整张图的这个颜色全部去掉（变为透明），这个功能效果不是理想，我们还有别的方法可以清除底色（详见后文）。

---

方法三：通过任务栏/快捷键新建

![Menu Import](/assets/images/start/menu_import.png)

和方法二的后续操作是一样的。

---

PS：给资源命名时，一般遵照下面规则：

* 开头写**资源类型简写**，如精灵（Sprites）简写为 spr，背景（Backgrounds）简写为 back，音效（Sounds）简写为 snd，均使用小写。
* 之后写上素材的性质，如形状，用途，颜色，可以组合，一般以便于区分作为第一法则，每个单词第一个字母大写，例：sprGreenApple，sndGameOver，backSky，sndJump 等。
* 其他资源中，对象（Objects）简写为 obj，时间轴（Timeline）简写为 tl，房间（Rooms）简写为 r，也可以写 room，字体（Fonts）仍用 font，脚本（Scripts）不使用类型名开头，而是根据实际用途命名，首字母也要大写，例如 FlashScreen。（有兴趣可以去百度一下驼峰命名法）

## 编辑素材

### 编辑 Sprites

点击**编辑精灵**。

如果你的图片是静图，你只能看到一张**子图（Images）**，如果你的图片是 gif，你可以看到有很多张**子图（Images）**，每一张子图叫做**一帧（Frame）**。左边的“显示预览”勾选可以显示该 gif 的预览图，注意勾选后出现的“速度”，该值单位为**帧/秒**，这里填入的数字只代表预览图的播放速度，与在游戏里实际使用时的播放速度无关。如图：

![GIF Images](/assets/images/start/gif_images.png)

你可以添加、删除、复制、粘贴子图，也可以改变子图的顺序。

双击可以打开其中一个子图：

![A Image](/assets/images/start/a_image.png)

*注意：透明区域显示为灰白交替的格子。*

GM8的图片编辑器，基本的功能都有，上面一行菜单栏，“查看，改变，图片”，这些里面装的才是高级玩意。

*注意：在图2处修改图片，只对当前子图有效，如果在图1处修改图片，默认对所有子图有效（可以取消勾选）。*

每个功能都请自己亲自动手去试试有什么效果，我不可能把所有的功能全部地讲一遍的，这不现实。

在这里我提一个能用的上的小技巧：

#### 图片---清除某种色

![Erase Color](/assets/images/start/erase_color.png)

常用于清除底色，与在导入图片时不同的是，你可以自定义你的底色是什么，并且可以选择容差值。你的鼠标会变成取色器，单击左图的某个地方，可以将该地方的颜色作为底色。点击“颜色”字样后的方框，可以选择底色。

一般而言，图片素材的底色和主题之间的界限并不明显，你需要通过调整容差值（即颜色的范围大小）来增大或减小清除的范围。

![Make Color Transparent](/assets/images/start/make_color_transparent.png)

有的时候你会遇到这种情况，比如下图，底色是白色，初音小姐姐身上也有白色，清除底色会把初音小姐姐的白色也去除：

![Hatsune Miku](/assets/images/start/hatsune_miku.png)

这时候，我们就需要来一些窒息的操作：

选择这个颜料罐，再把容差值调大（确保底色不会遗漏，如果会影响主体，就调小点），然后选择一种主体没有的颜色（比如在这里我选择紫色），并将颜色模式改为替换，然后单击有底色的地方，这张图就会变成：

![Fill](/assets/images/start/fill.png) ![Purple](/assets/images/start/purple.png)

然后在清除底色的时候选择紫色，容差值小一点，就可以去除底色而不影响主体了：

![Tolerance](/assets/images/start/tolerance.png)

### 编辑 Backgrounds

背景和精灵的编辑是差不多的，但是背景编辑删除了一些功能。相对的，背景也多了一个功能：作为贴图使用，这在我们讲到房间（Rooms）的时候会做讲解。

### 编辑 Sounds

这个没啥好编辑的，用默认的配置就行了。
