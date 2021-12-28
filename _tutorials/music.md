---
layout: default
title: 外置音频：SS 与 MM
nav_order: 19
---

GM8 的音频系统可以说一团糟糕，因此，GMer 多是选择使用音频插件来播放、控制音频。在此介绍两个常用又容易上手的插件：**SuperSound**（作者为 tsg1zzn）与 **MaizeMusic**（作者为 Mage 松仁玉米），任选其一即可。

[SuperSound 下载](https://pan.baidu.com/s/1CXM_ealY-kqV_S_ydCsnEQ)

[MaizeMusic 下载](https://www.magecorn.com/p/254.shtml)（教程第一章提供的 GM8 汉化版自带）

下载之后，里面会有多个文件，一般来讲至少会有 xxx.dll，xxx.gml，xxx.gex 这三个文件，使用 dll + gml 等效于使用 gex，大佬们通常比较喜欢使用 dll + gml，不过为了方便，本教程此处一律使用 gex。

导入 GM 的方法和[导入 FoxWriting 插件]({{ site.baseurl }}{% link _tutorials/draw/text.md %}#foxwriting)是一样的，因此不再复述。

*注：本教程只讲常用函数，那些比较深层或者不常用的内容不会出现在本教程中。*

# SS vs MM

SuperSound 只支持 wav 和 ogg 的音频格式，而 MaizeMusic 支持 mp3，wav，ogg，ma，m4a，ot，mod 等等多格式，且功能也比 SuperSound 更加全面（虽然基本上用不上），但是目前在国外 GM 圈要么就是用 SuperSound 要么就是用 FMOD，几乎不见使用 MaizeMusic（我怀疑是因为玉米懒得写英文文档），因此如果你有需要与国外大佬合作的话，建议使用 SuperSound 或者更为复杂的 FMOD，否则建议使用 MaizeMusic。

# SuperSound

在使用 SuperSound 之前，你需要准备一个 [GoldWave](https://www.goldwave.com/) 来转换音频格式为**ogg**。

SuperSound 只支持 wav 和 ogg 是它的一大缺陷，但也可以说是一大优点，因为 ogg 格式的音频文件比 mp3 要小很多，音质却完全不输于 mp3，有助于减小游戏整体的大小。

## 转换格式

下载并打开 GoldWave，将音频文件拖入其中，GoldWave 会显示它的频率波形图：

![Gold Wave](/assets/images/music/goldwave1.png)

点击左上角的 **File**，选择 **Save As...**

![Gold Wave](/assets/images/music/goldwave2.png)

下拉“**保存类型**”，选择 **ogg** 格式，保存。

![Gold Wave](/assets/images/music/goldwave3.png)

这样音频文件就成功转换为了 ogg 格式。

将所有转换完的 ogg 音频文件全部放到 .gmk 所在的文件夹，不过个人更喜欢放在 \Data\Music 下，如下图所示，"Best bye to 2016" 是游戏的 .gmk 所在的文件夹。

![Gold Wave](/assets/images/music/goldwave4.png)

## 载入音频

* `SS_LoadSound(path, stream)` 该函数载入一个外置音频，并且返回该音频的索引。

参数 path 填写文件路径，比如上图中，我要载入 `Bad Apple!! piano ver.ogg`，那么参数path就应该填写 `working_directory + "\Data\Music\Bad Apple!! piano ver.ogg"`。参数 stream 填写 true 或 false ，表示是否流式读取音频，由于 SuperSound 对流式音频处理十分烂，所以建议填写 false 。这个函数的返回值需要用在播放音乐当中，所以需要用一个全局变量去接收，因此它的完整调用形式是：

`global.BGM_BadApple = SS_LoadSound(working_directory + "\Data\Music\Bad Apple!! piano ver.ogg", true);`

建议新建一个脚本（假设叫 musicInit），将所有载入音乐全部放在这个脚本里，然后在游戏最开始调用一次 `musicInit();`，比如在对象 [world]({{ site.baseurl }}{% link _tutorials/make_your_game/level_design.md %}#全局控制) 的 create 事件。

注意，当音乐文件成功读取时，该函数会返回一个很大整数，如果读取失败，则会返回字符串 `"No"`，因此可以通过 `if (is_real(global.BGM_BadApple))` 来判断是否读取成功。

## 释放音频

* `SS_FreeSound(snd)` 当不需要一个音频时，应当释放它的内存。参数填写需要释放的音频的索引，即 `SS_LoadSound` 的返回值。

## 播放与停止

* `SS_PlaySound(snd)` 播放指定的音频，只播放一次，参数 snd 填写音频索引。
* `SS_LoopSound(snd)` 循环播放指定的音频。
* `SS_StopSound(snd)` 停止播放指定的音频。
* `SS_PauseSound(snd)` 暂停播放指定的音频。
* `SS_ResumeSound(snd)` 从暂停处继续播放指定的音频。

## 调整音量

* `SS_SetSoundVol(snd, volumn)` 设置某个音频的播放音量。参数 snd 为音频索引。参数 volumn 为音量，可取值为 0\~10000，但是实际上在 5000 左右的时候就基本上没有声音了，因此，如果假设一个变量 `global.volumn` 控制音量在 0\~100 之间，那么最好将 `5000 + 50 * global.volumn` 传递给函数 `SS_SetSoundVol`，为了保险起见，在 `if (global.volumn == 0)` 时传递 0 给 `SS_SetSoundVol`。
* `SS_GetSoundVol(snd)` 获取指定音频的音量。

## 判断状态

* `SS_IsSoundPlaying(snd)` 返回指定音频是否处于播放状态。
* `SS_IsSoundLooping(snd)` 返回指定音频是否处于循环播放状态。
* `SS_IsSoundPaused(snd)` 返回指定音频是否处于暂停状态。

## 控制播放位置

如果你在 `SS_LoadSound` 中使用了**流式**音频，则以下函数全部报废。

* `SS_GetSoundLength(snd)` 返回指定音频的长度。注意，返回的长度单位是 byte。
* `SS_GetSoundPosition(snd)` 返回指定音频播放到的位置。与上面相同，返回的长度单位是 byte。
* `SS_SetSoundPosition(snd, pos)` 设置音频从 pos 处开始播放。注意，`SS_SetSoundPosition` 不会主动播放音频，所以这个音频应当正处于播放状态。参数 pos 的单位也是byte。

举个例子，上述的 global.BGM_BadApple 长度为 219 秒，我要让它从第 46 秒开始播放，那么代码就是：

```c
SS_PlaySound(global.BGM_BadApple);
SS_SetSoundPosition(global.BGM_BadApple, (46 / 219) * SS_GetSoundLength(global.BGM_BadApple));
```

因为音频长度是以 byte 来计数的，所以你可以精确到毫秒来控制播放位置。

# MaizeMusic

## 载入音频

* `mm_music_load(path, loop)` 载入音频。参数 path 请参考 SuperSound 中的 `SS_LoadSound(path, stream)`。参数 loop 指定该音频是否需要循环播放。该函数返回音频的索引，请用全局变量储存，参考 SuperSound 中的 `SS_LoadSound(path, stream)`。读取音乐文件失败时返回 0。
* `mm_music_load_url(url)` 载入网络音频。参数 url 为字符串，填写网络音频的直接文件地址（不是音频的播放页面）。返回值为音频的索引。

## 释放音乐

* `mm_music_free(snd)` 当不需要某个音频时，应当释放它的内存。参数 snd 填写音频索引，即 `mm_music_load` 的返回值。

## 播放与停止

* `mm_play(snd)` 播放指定的音频，参数 snd 填写音频索引。
* `mm_stop(snd)` 停止播放指定的音频。
* `mm_stop_all()` 停止播放所有的音频。
* `mm_pause(snd)` 暂停播放指定的音频。
* `mm_resume(snd)` 从暂停处继续播放指定的音频。

## 调整音量

* `mm_set_volume(snd, volumn)` 设置指定音频的音量，参数 volumn 范围为 0~1。
* `mm_slider_volume(snd, volumn, time)` 缓动指定音频的音量。有些时候，你需要让音量渐渐增大，或者渐渐减小，而不是突兀地变化，此时你需要`mm_slider_volume`，相比于上一个函数多了参数 time ，单位为步（或帧），控制音频经过多少时间变化到 volumn 。
* `mm_set_global_volume(volumn)` 设置操作系统（即 Windows）的音量，参数 volumn 范围为0~1。
* `mm_get_volume(snd)` 获取指定音频的音量
* `mm_get_global_volume()` 获取操作系统的音量。

## 播放速度

* `mm_set_speed(snd, spd)` 设置指定音频的播放速度，参数 spd 为播放速度，1表示常速。

## 循环片段

* `mm_set_music_loop_section(snd, begin, end)` 设置指定音频的循环片段，begin 和 end 单位为秒，可以使用小数，用来指定循环片段的首尾。
* `mm_remove_music_loop_section(snd)` 取消指定音频的循环片段。

## 获取状态

* `mm_get_active(snd)` 返回指定音频的状态。返回 0 为停止，1 为正在播放，2 为正在缓冲，3 为暂停。

## 音效

* `mm_effect_set(snd, effect)` 设置指定音频的音效。音效可以叠加。effect 的可选值为：
  * `se_chorus` 合唱
  * `se_echo` 回声
  * `se_flanger` 降噪、镶边
  * `se_gargle` 漱口声
  * `se_reverb` 混响
  * `se_compressor` 压缩器
  * `se_equalizer` 均衡器
* `mm_effect_remove(snd, effect)` 去除指定音频的指定音效。
* `mm_effect_reset(snd)` 去除指定音频的所有音效。

## 控制播放位置

* `mm_get_length(snd)` 返回指定音频的长度，单位为秒。
* `mm_get_position(snd)` 返回指定音频播放到的位置，单位为秒。
* `mm_set_position(snd, pos)` 设置指定音频从 pos 出开始播放。注意 `mm_set_position` 不会主动播放音频，所以音频应当处于播放状态。pos 单位为秒，支持小数。

举个例子，上述的 `global.BGM_BadApple`，要让它从第 46 秒开始播放，那么代码就是：

```c
mm_play(global.BGM_BadApple);
mm_set_position(global.BGM_BadApple, 46);
```

显然，MM 在控制音频播放位置方面远比 SS 方便。

## 录音

* `mm_record_start()` 开始录音。返回值为本次录音的音频索引，可以用在 `mm_play` 等函数中。
* `mm_record_stop()` 停止录音。
* `mm_record_set_input(enable, volumn)` 设置输入设备的状态，通常指麦克风。enable 表示开启（true）或关闭（false）输入设备，volumn 设置输入设备的音量。
* `mm_record_get_volume()` 获取输入设备的音量，通常指麦克风。
