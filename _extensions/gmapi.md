---
layout: default
title: 使用GMAPI
nav_order: 3
---

此篇为[使用C++为GM8生成dll]({{ site.baseurl }}{% link _extensions/dll.md %})的扩展篇，在阅读此篇之前，请确保你已经阅读[使用C++为GM8生成dll]({{ site.baseurl }}{% link _extensions/dll.md %})。

GMAPI是由国外神仙Snake所写的，能够在C++的DLL中直接调用GM函数，并且获取内部数据的库。由于年代久远，该作者所提供的个人主页链接已经失效，故不在此贴出。

[GMAPI下载请点击此处](https://pan.baidu.com/s/1_DutjJlhoQ8D9wGauFfICw)。

该篇教程部分代码参考自[FoxWriting项目](https://github.com/Noisyfox/FoxWriting)。（对的，比如下面某注释里的vs2015就是fw里的注释）

# 在VS中使用GMAPI

## 配置项目

解压GMAPI.zip，可以看到里面有两个文件夹：

![Folder](/assets/images/gmapi/folder.png)

将GMAPI下的所有.h与.cpp文件全部复制到项目下，并且导入：

![Solution](/assets/images/gmapi/solution.png)

在**项目**->**属性**->**链接器**->**常规**->**附加库目录**中，添加GMAPICore文件夹的路径（*注意，左上角选择所有配置*）：

![GMAPICore](/assets/images/gmapi/gmapicore.png)

紧接着，在**项目**->**属性**->**链接器**->**输入**->**附加依赖项**中添加GMAPICore.lib：

![GMAPICore Lib](/assets/images/gmapi/gmapicore_lib.png)

之后，在**项目**->**属性**->**链接器**->**命令行**中键入`/nodefaultlib:libci /SAFESEH:NO`）：

![Command](/assets/images/gmapi/command.png)

## 初始化GMAPI

在你自己的"**项目名.h**"头文件中，包含Gmapi.h：

```cpp
#include "Gmapi.h"
```

声明一个`CGMAPI`的**全局指针**，我们之后会用到它：

```cpp
extern gm::CGMAPI *gmapi;
```

再进入到你的"**项目名.cpp**"文件中，在全局域定义该指针：

```cpp
gm::CGMAPI *gmapi = nullptr;
```

然后来到**dllmain.cpp**中，先`#include`上你的"**项目名.h**"头文件，然后使用下面的代码替换你的`DllMain`函数：

```cpp
switch (ul_reason_for_call)
{
    case DLL_PROCESS_ATTACH:
    {
        DWORD result = 0;
        gmapi = gm::CGMAPI::Create(&result);
        // Check the initialization
        if (result == gm::GMAPI_INITIALIZATION_FAILED)
        {
            MessageBox(NULL, L"Unable to initialize GMAPI.", NULL, MB_SYSTEMMODAL | MB_ICONERROR);
            return FALSE;
        }
    }
    break;

    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    break;

    case DLL_PROCESS_DETACH:
    gm::CGMAPI::Destroy();
    break;
}
return TRUE;
```

至此，GMAPI初始化完毕。

## 调用GM8的函数

任何GM8中的函数，均可通过`gm::function_name(args)`的形式来使用。

# 使用D3D8

**D3D8**即**DirectX 3D 8.0**版本。通过D3D8我们可以访问GM8的图像数据。[D3D8下载请点击此处](https://pan.baidu.com/s/1oid7_xQZl-4Zsz3rdFWPCg)。

解压d3d8.zip并将其放在项目目录下。

在**项目**->**属性**->**VC++目录**->**包含目录**中，添加D3D8的文件夹路径。注意，请将D3D8的路径放在包含目录的最后面，否则`winnt.h`会报错。

![D3D8 Include](/assets/images/gmapi/d3d8_include.png)

同样，在**项目**->**属性**->**链接器**->**常规**->**附加库目录**也添加D3D8的文件夹路径。（Debug和Release最好分开配置）

![D3D8 LIB](/assets/images/gmapi/d3d8_lib.png)

在**项目**->**属性**->**C/C++->预处理器**->**预处理器定义**中，添加`GMAPI_USE_D3D`和`_CRT_SECURE_NO_WARNINGS`两个宏。

![D3D8 Macros](/assets/images/gmapi/d3d8_macros.png)

打开你的"**项目名.h**"，包含D3D8的头文件以及库：

```cpp
#include <d3d8.h>
#pragma comment (lib, "d3d8.lib")
#include <d3dx8.h>
#pragma comment (lib, "d3dx8.lib")
```

打开**dllmain.cpp**，在case DLL_PROCESS_ATTACH:之后添加下面的代码：

```c
{
    // 应对 vs2015 内联 sprintf 导致 d3d8.lib 找不到 _sprintf 的问题
    char f__kInline[1];
    sprintf(f__kInline, "");
}
```

此时，你的dllmain.cpp应该是这样的：

![DllMain](/assets/images/gmapi/dllmain.png)

GM8的图像，背景图片，表面都是以材质储存的，我们可以通过`gm::xxx_get_texture()`的方式得到他们的材质索引texid。

之后，我们可以使用：

```cpp
IDirect3DTexture8 *texture = gm::CGMAPI::GetTextureArray()[texid].texture;
```

来获取对应的D3D8中的材质类型。如果你在预处理器中设置的宏没问题，那么`gm::CGMAPI::GetTextureArray()[texid].texture`应当返回一个`IDirect3DTexture8 *`类型的指针，反之则是`void *`类型。我们可以在**GmapiDefs.h**中第29行看出：

![GMAPI Defs](/assets/images/gmapi/gmapidefs.png)

我并不建议你修改图像和背景图片的材质，除非是你通过`sprite_add()`或`background_add()`所创建的（事实上，FoxWriting的原理就是修改一个精灵的材质，然后再绘制该精灵实现的）。更多情况下我们应当修改表面的材质。应当提醒一句，GMAPI的效率并不高，形如`surface_set_target()`，`screen_redraw()`之类的操作最好放在GML里去操作，然后将surface的id传入到dll中。

`IDirect3DTexture8`有一个成员函数`LockRect`可以获取其数据并且修改。但是由于GM8的材质被设置为`D3DPOOL_DEFAULT`，从D3D8文档中我们得知：

![D3DPOOL DEFAULT](/assets/images/gmapi/d3dpool_default.png)

没办法，我们只好走一点弯路，先自己创建一个`IDirect3DTexture8`，拷贝数据过来，修改完成后再`update`回去了。

为了防止每一次调用函数就创建一个额外的`IDirect3DTexture8`，我们将我们的`IDirect3DTexture8`指针声明在**全局域**。方法类似于`gm::CGMAPI`的创建，不再赘述。假设它叫做`textureTemp`吧，我们使用下面的代码来修改其中的图像数据：

```cpp
IDirect3DTexture8 *texture = gm::CGMAPI::GetTextureArray()[texid].texture;
IDirect3DDevice8 *device;
texture->GetDevice(&device);
IDirect3DSurface8 *surface, *surfaceTemp;
// 创建textureTemp，width和height可以指定为gm::surface_get_width(surfid)和gm::surface_get_height(surfid)，考虑到效率也可以设置为全局变量。其中第五个变量就是与GM8的材质不同的点，GM8的材质该参数是D3DPOOL_DEFAULT。
if(textureTemp == nullptr)
    device->CreateTexture(width, height, 0, D3DUSAGE_DYNAMIC, D3DFMT_A8R8G8B8, D3DPOOL_SYSTEMMEM, &textureTemp);
texture->GetSurfaceLevel(0, &surface);
textureTemp->GetSurfaceLevel(0, &surfaceTemp);
// 拷贝数据
device->CopyRects(surface, NULL, 0, surfaceTemp, NULL);
D3DLOCKED_RECT lock;
textureTemp->LockRect(0, &lock, NULL, 0);
// imageData为图像数据
unsigned *imageData = reinterpret_cast<unsigned *>(lock.pBits);
/*
    some_function_here();
    在此处处理imageData
*/
textureTemp->UnlockRect(0);
device->UpdateTexture(textureTemp, texture);
```

`imageData`是一个无符号整数的数组，总长度是`width * height`，每一个整数代表一个像素，格式为AGBR。你可以这样获取红，绿，蓝，透明度值：

```cpp
unsigned char red = imageData[i] & 0xFFU,
    green = (imageData[i] & 0xFF00U) >> 8,
    blue = (imageData[i] & 0xFF0000U) >> 16,
    alpha = (imageData[i] & 0xFF000000U) >> 24;
```

注意，由于C++整型使用小端储存，如果你将该指针强制转换为`unsigned char *`指针，那么图像数据的顺序就是R,G,B,A。值得注意的是，C++计算位运算远远快过四则运算，因此下面的代码反而比上面的慢。

```cpp
unsigned char *imageData = reinterpret_cast<unsigned char *>(lock.pBits);
......
unsigned char red = imageData[i * 4];
    green = imageData[i * 4 + 1];
    blue = imageData[i * 4 + 2];
    alpha = imageData[i * 4 + 3];
```

例如，将图像灰度化：

```cpp
unsigned gray;
for (int i = 0; i < width * height; i++)
{
    gray = ((imageData[i] & 0xFFU) + ((imageData[i] & 0xFF00U) >> 8) + ((imageData[i] & 0xFF0000U) >> 16)) / 3;
    // 强制设置透明度为255以防止bm_normal对表面的腐蚀。非screen_redraw的情况下应使用原透明度。
    imageData[i] = 0xFF000000U | gray << 16 | gray << 8 | gray;
}
```

我不得不提醒你，**使用CPU来逐个像素处理是非常慢的**，如果你想要制作类似GMS的shader的效果，我建议你使用GPU来处理，使用**openGL**，**openCV**等GPU库，或者D3D8自带的**LLSL**（Low Level Shading Language）着色器，而不是使用for循环来逐个像素处理。再加上，GM8本身效率也低，如果你的房间放了很多的东西，处理了很多逻辑，留给C++的余地就更少了。具体在什么程度下会开始出现掉帧，不同的电脑不一样，可以自己试一试，但真的是稍微复杂点就掉帧。

你可能会问LLSL是什么，我怎么听说D3D用的是**HLSL**（High Level Shading Language）？遗憾的是，HLSL是D3D9才有的东西，然而GMAPI只支持D3D8，而D3D8中使用的着色器也就是LLSL，所谓低级着色器语言。

如果你只是需要写入，而不需要读取（就像FoxWriting那样），那就更简单了，你可以使用自己创建的IDirect3DTexture8直接顶替掉`gm::CGMAPI::GetTextureArray()[texid].texture`即可，也就是说：

```cpp
gm::CGMAPI::GetTextureArray()[texid].texture = yourTextrue;
```

如果你想将texture保存为文件，你可以使用：

```cpp
D3DXSaveTextureToFile(L"Enter Your File Path", D3DXIFF_BMP, texture, NULL);
```

粗略测试感觉这个函数的效率要高于GM8的`surface_save()`。

# 使用OpenMP加速for循环

如果你觉得学GPU编程太麻烦了，还是想用CPU使用for循环来逐个处理像素，那么你可以考虑使用**OpenMP**来加速for循环。

不过不要指望OpenMP能有非常惊人的提升，如果你的代码本来会让游戏掉到30帧，使用了OpenMP最多也就帮你提高到40多帧。**优化for循环的结构，减少循环体的计算量**才是更有效率的。

VS2017自带OpenMP，你只需要在**项目**->**属性**->**C/C++**->**语言**->**OpenMP**支持选择是即可。

![OpenMP](/assets/images/gmapi/openmp.png)

在你的"**项目名.h**"中`#include <omp.h>`，在for循环前，加上

```cpp
#pragma omp parallel for
```

即可。注意，OpenMP通过多线程加速for循环，它不能保证for循环的顺序，（也就是说，`i = 3`可能会比`i = 2`早执行），因此，for循环内部不应该存在可能会互相影响的代码。

例如，上述灰度化代码即可通过OpenMP加速：

```cpp
#pragma omp parallel for
for (int i = 0; i < width * height; i++)
{
    gray = ((imageData[i] & 0xFFU) + ((imageData[i] & 0xFF00U) >> 8) + ((imageData[i] & 0xFF0000U) >> 16)) / 3;
    imageData[i] = 0xFF000000U | gray << 16 | gray << 8 | gray;
}
```

# And More？

GMAPI中还有更多底层的东西，比如GM变量的底层实现`gm::CGMVariable`，精灵的底层实现`gm::GMSPRITE`（其中包含有以BYTE*储存的图像比特数据）等等，因为我本人也并不是很能看懂GMAPI（摊手），更多的功能就留给各位一起探索。
