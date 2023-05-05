---
title: 基于SVG实现写字动画
cover: https://cdn.pixabay.com/photo/2023/01/30/19/40/gulls-7756481_1280.jpg
swiper_index: 2
description: 这是系列文章《原生 JS 实现前端常见功能》的第 2 篇，讲述一些 svg 的基础知识和如何通过 svg 实现一个写字动画。
date: 2021-07-09 14:24:36
categories: 
  - [前端, 前端综合]
tags: 
  - SVG
---

`SVG`是一种基于`XML`的标记语言，常用来优雅、简洁地渲染一些可以自动实现`响应式变化`的图形，并和`CSS`，`DOM`，`JavaScript`等其他网络标准无缝衔接。所以在工作中，熟练地使用它能使开发过程更得心应手。

今天的示例就是通过 `JavaScript` + `SVG` 实现写字动画。

## 实现效果

最终的实现效果：

![](https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/ezgif-1-30b0796c0e30.gif)

## 画 SVG 图形

怎样才能实现上面的效果呢？首先，需要准备一张图片:

```html
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 280 40">
  <g fill="none" stroke="#000">
    <path
      d="M20.15 22.62c-3.74-3.67-7.94-9.77-5-15 2.5-3.16 5.88 1.35 5 4.2-.66 5.23-2 11.08-6 14.8-2.95 2.62-8.04.02-7-4 1.15-1.88 3.52-.9 5 0"
    />
    <path
      d="M48.15 21.62c-1.27-5.3-9.5-2.8-9 2.1-.4 4.65 7.2 5.37 8 .9l6-18m-4 12c-.22 2.87-2.37 6.7 0 9 3.02.14 4.57-2.8 6-5"
    />
    <path
      d="M58.15 18.62c-2.7 1.97-4.1 6.13-2 9 2.53.45 4.45-1.22 6-3m2-6c-.45 2.87-3.6 6.56-1 9 4.88.6 7.7-4.72 7-9m0 0c-.08 3.47 2.6 6.87 5.95 4.02l.05-.02"
    />
    <path
      d="M77.15 25.62c2.8-.67 5.64-4.77 3-7-5.52-.5-5.4 9.6.1 9 2.97.08 4.48-2.84 5.9-5"
    />
    <path
      d="M86.15 22.62c2.77-4.7 7-9.27 7-15-2.77-2.68-4.56 2.88-4.8 5.18-.74 4.62-1.9 9.75-.82 14.2 2.64 2.2 5.43-2.47 6.62-4.38"
    />
    <path
      d="M94.15 22.62c2.77-4.7 7-9.27 7-15-2.77-2.68-4.56 2.88-4.8 5.18-.74 4.62-1.9 9.75-.82 14.2 2.64 2.2 5.43-2.47 6.62-4.38"
    />
    <path
      d="M121.15 13.62c-.43 2.95 2.74-.6 0 0zm-3 9c2.5-5.4 1.76-3.03.27 1.18-1.95 3.9 2.96 4.9 4.73 1.82l2-3"
    />
    <path
      d="M125.15 22.62c.55-2.93 6.15-5.93 4.73-.94-.45 2.02-1.04 4-1.73 5.94m1-3c1.27-2.85 3.74-7.46 7.38-5.6 2.44 2.3-2.94 7.36 1.16 8.6 2.77-.3 4.06-2.92 5.45-5"
    />
    <path
      d="M159.15 22.62c2.02-2.78 3.9-7.3 2.07-1.3-1.98 6.12-4.05 12.2-6.07 18.3m6-18c.83-4.6 8.62-3.63 8 1.1.06 2.33-1.9 4.2-4 4.9m-4-1c4.33 2.78 10.2-.4 13-4"
    />
    <path
      d="M180.15 18.62c-4.63-1.2-8.56 6.1-4.02 8.5 4.4 2.74 9.78-4.58 5.53-7.74-3.54-2.53-3.16 4.84-.05 4.97 2.22.82 5.06.2 6.55-1.73"
    />
    <path
      d="M188.15 22.62c2.35-2.74 2.73-7.08 3.9-1.64 1.38 2 4.07 5.8.1 6.64m-4-1c3.62 2.38 8.93.9 10.5-3.27l.32-.45.18-.28"
    />
    <path
      d="M199.15 22.62c2.35-2.74 2.73-7.08 3.9-1.64 1.38 2 4.07 5.8.1 6.64m-4-1c3.62 2.38 8.93.9 10.5-3.27l.32-.45.18-.28"
    />
    <path
      d="M213.15 13.62c-.43 2.95 2.74-.6 0 0zm-3 9c2.5-5.4 1.76-3.03.27 1.18-1.95 3.9 2.96 4.9 4.73 1.82l2-3"
    />
    <path
      d="M217.15 22.62c2.77-4.7 7-9.27 7-15-2.77-2.68-4.56 2.88-4.8 5.18-.74 4.62-1.9 9.75-.82 14.2 2.47 1.77 5.9-1.88 6.3-4.45.7-6-.1-1.8 2.32 1.07 1.5.23 2.74-.22 4-1"
    />
    <path
      d="M234.15 13.62c-.43 2.95 2.74-.6 0 0zm-3 9c2.5-5.4 1.76-3.03.27 1.18-1.95 3.9 2.96 4.9 4.73 1.82l2-3"
    />
    <path
      d="M238.15 22.62c2.77-4.7 7-9.27 7-15-2.77-2.68-4.56 2.88-4.8 5.18-.74 4.62-1.9 9.75-.82 14.2 2.64 2.2 5.43-2.47 6.62-4.38"
    />
    <path
      d="M249.15 13.62c-.43 2.95 2.74-.6 0 0zm-3 9c2.5-5.4 1.76-3.03.27 1.18-1.95 3.9 2.96 4.9 4.73 1.82l2-3"
    />
    <path
      d="M253.15 22.62c1.6-2.18 2.84-4.55 4-7m3-9c-1.9 6.38-4.7 12.62-6 19.1.3 3.68 5.68 1.46 6.6-1l1.4-2.1m-8-8h7"
    />
    <path
      d="M262.15 22.62c2.5-5.4 1.76-3.03.27 1.18-1.98 3.77 3.02 5.1 5.1 2.44 1.56-1.28 2.53-2.97 3.63-4.62m1-3c-2.4 6.64-4.1 13.56-7 20-3.85 3.06-3.5-3.64-1.62-5.38 3.73-4.66 10-5.83 13.62-10.62"
    />
  </g>
</svg>
```

没接触过 `SVG` 的话在这里可能会疑惑，不是准备一张图片吗，上面怎么是一段`XML`代码呢？这是因为 `SVG` 本身是一种基于 `XML` 的标记语言，是浏览器通过解析 `XML` 携带的信息后以图片的形式将信息展示出来的。

例如，我们要用 `SVG` 将一个长为 `300px`，宽为 `300px`，以`红色`填充的正方形展示出来，只需要下面这段`XML`:

```html
<svg
  style="width: 150px; height: 300px"
  version="1.1"
  baseProfile="full"
  xmlns="http://www.w3.org/2000/svg"
>
  <rect width="300" height="300" fill="red" />
</svg>
```

运行效果:

![](<https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/1625802942(1).jpg>)

> 这里为了后续方便展示`SVG`的`响应式变化`，特意给 svg 图形加了 `150px` 的宽度和 `300px` 的高度，所以看起来不完整。

尝试运行上面的代码会发现，`SVG`不是矢量图形吗，那为什么上面的图片不能实现`响应式变化`呢？只需要对上面的`XML`加上`viewBox`属性即可。

```html
<svg
  style="width: 150px; height: 300px"
  version="1.1"
  baseProfile="full"
  xmlns="http://www.w3.org/2000/svg"
  viewBox="0 0 400 400"
>
  <rect width="300" height="300" fill="red" />
</svg>
```

运行效果:

![](<https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/1625803086(1).jpg>)

`viewBox`属性的值是一组用空白或逗号分割的包含 _4_ 个参数的序列，它们从左到右分别表示（`svg`的坐标原点在左上角）：`最小X轴数值`、`最小y轴数值`、`宽度`、`高度`。其中，宽度和高度不允许为负值，当宽度或高度设置为 `0` 可以隐藏元素。

对于`viewBox`的理解，可以把它想象成长度单位不是任何一个 css 单位（例如：px）的视图，这里为了方便叙述，统一就叫它`单位`吧。例如，上面示例的`viewBox`为`0 0 400 400`，即表示视图的最小 X 轴数值为 `0 单位`、最小 y 轴数值为 `0 单位`、宽度为 `400` 单位、高度为 `400 单位`。

`viewBox`前两个参数，是对 svg 图形的元素做整体位移时使用。例如我们将一个 svg 图形的`viewBox`属性定义为`200 200 400 400`，则表示将元素相对于视图分别**向左**和**向上**移动了**200 单位**。

运行效果:

![](<https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/1625803174(1).jpg>)

`viewBox`的后两个参数理解起来比较抽象，用上面示例来说明。上面图形的`viewBox`属性定义为`0 0 400 400`，里面正方形的长款定义为`300*300`。在脑海里我们想象一个 `400单位*400单位`的大正方形，里面再放了一个`300单位*300单位`的小正方形。注意：**svg 有个特点，在默认情况下，会调整 viewBox 的大小，让 viewBox 正好能被放进 svg 里去**。因为外面的 svg 被定义成一个 `150px*300px`的长方形，所以就把大正方形的真实宽度缩小到和 svg 的宽度一样，就正好能将大正方形整个放进 svg 里了，所以现在`viewBox`的实际大小是`150px*150px`。也就表示 `viewBox` 的一个`单位`代表的长度 = 150px/400 = 0.375px。而 `viewBox` 内部的所有数值*0.375px 才是真正的长度。那个小正方形的实际大小就是`112.5px*112.5px`。

## 让 SVG 图形动起来

要让 SVG 图片动起来，先要明白`stroke-dasharray` 和 `stroke-dashoffset` 这两个概念。

### stroke-dasharray

在 `SVG` 中也可以通过指定属性 `stroke-dasharray` 让边框像 `CSS` 中的`border-style: dashed`那样变为虚线。`stroke-dasharray` 属性的参数，是一组用逗号分割的数字组成的序列。需要注意的是，这里的数字必须用逗号分割，虽然也可以插入空格，但是数字之间必须用逗号分开。

每一组数字，第一个用来表示实线，第二个用来表示空白。如果只有一个数字 `5`，则表示会先画 `5px` 实线，紧接着是 `5px` 空白，然后又是 `5px` 实线，从而形成虚线。比如我有一条 `200px` 的线，我把 `stroke-dasharray` 的指定为 `200`，它就表示先画 `200px` 实线，紧接着是 `200px` 空白，然后又是 `200px` 实线，从而形成虚线。

例如：

```html
<svg
  version="1.1"
  baseProfile="full"
  xmlns="http://www.w3.org/2000/svg"
  width="200"
  height="200"
  viewPort="0 0 200 300"
>
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 5"
    x1="10"
    y1="10"
    x2="190"
    y2="10"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 10"
    x1="10"
    y1="30"
    x2="190"
    y2="30"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="10, 5"
    x1="10"
    y1="50"
    x2="190"
    y2="50"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 1"
    x1="10"
    y1="70"
    x2="190"
    y2="70"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="1, 5"
    x1="10"
    y1="90"
    x2="190"
    y2="90"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="0.9"
    x1="10"
    y1="110"
    x2="190"
    y2="110"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="15, 10, 5"
    x1="10"
    y1="130"
    x2="190"
    y2="130"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="15, 10, 5, 10"
    x1="10"
    y1="150"
    x2="190"
    y2="150"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="15, 10, 5, 10, 15"
    x1="10"
    y1="170"
    x2="190"
    y2="170"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 5, 1, 5"
    x1="10"
    y1="190"
    x2="190"
    y2="190"
  />
</svg>
```

运行效果:

![](<https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/1625803488(1).jpg>)

### stroke-dashoffset

`stroke-dashoffset` 属性表示路径从开始位置的偏移量。比如定义了 `stroke-dasharray` 的值为 `5, 10, 30, 10` 表示 5px 的虚线、10px 的空白、30px 的虚线、10px 的空白，如此循环。然后，通过改变它的 `stroke-dashoffset` 的值来看看会发生什么：

```html
<svg
  version="1.1"
  baseProfile="full"
  xmlns="http://www.w3.org/2000/svg"
  width="200"
  height="200"
  viewPort="0 0 200 300"
>
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 10, 30, 10"
    x1="10"
    y1="10"
    x2="190"
    y2="10"
  />
  <line
    stroke="black"
    stroke-width="2"
    stroke-dasharray="5, 10, 30, 10"
    stroke-dashoffset="15"
    x1="10"
    y1="20"
    x2="190"
    y2="20"
  />
</svg>
```

运行效果:

![](https://cdn.jsdelivr.net/gh/ytppp/ytpblog-image-store/img/20210709120649.png)

观察上面代码的运行效果可以看到，通过`stroke-dashoffset`属性，可以重新设置路径开始的位置。在上面的实例中，设置 `stroke-dashoffset` 的值为 `15`，可以看到路径向左移动了 `15px` 的距离。

```html
<svg
  version="1.1"
  baseProfile="full"
  xmlns="http://www.w3.org/2000/svg"
  width="200"
  height="200"
  viewPort="0 0 200 300"
>
  <g fill="none" stroke="#000">
    <path
      d="M20.15 22.62c-3.74-3.67-7.94-9.77-5-15 2.5-3.16 5.88 1.35 5 4.2-.66 5.23-2 11.08-6 14.8-2.95 2.62-8.04.02-7-4 1.15-1.88 3.52-.9 5 0"
    />
  </g>
</svg>
```

把路径的 `stroke-dasharray` 和 `stroke-dashoffset` 都设置为同样的值，会发现什么也看不到了，因为路径的虚线和空白距离都是一样的。

### 用 js 实现具体功能

要实现上面的写字动画，首先要获取 `path` 的长度用来设置 `stroke-dasharray` 和 `stroke-dashoffset` 的值。然后使用 `Web Animations API` 中的 `animate` 方法来把 `stroke-dashoffset` 的值从等长设置为 0，就会产生书写出来的动画效果。

下面来实现具体的功能。先获取所有的 `path`，并且使用 `getTotalLength()`方法来获取 path 的长度，然后将每一个 `path` 的 `strokeDashoffset` 和 `strokeDasharray` 的值都设置为同样的值，从而隐藏所有 `path`。

```javascript
const paths = document.getElementsByTagName('path');
const strokes = [];
let j = 0;

for (let i = 0; i < paths.length; i++) {
  strokes[i] = paths[i].getTotalLength();
  paths[i].style.strokeDasharray = paths[i].getTotalLength();
  paths[i].style.strokeDashoffset = paths[i].getTotalLength();
}
```

然后使用 `animate` 方法来动态更新每一个 `path` 的 `strokeDashoffset` 的值。

```javascript
function strokeLetter(letter, pathLen) {
  letter.animate([{ strokeDashoffset: pathLen }, { strokeDashoffset: 0 }], {
    duration: pathLen * 7,
    fill: 'forwards',
  }).onfinish = function() {
    j++;
    strokeLetter(paths[j], paths[j].getTotalLength());
  };
}
```

> Web Animations 提供的 animate 方法和 CSS3 中的 animation 方法的属性差不多，相比较起来 Web Animations 更加的灵活方便，比如提供了回调的方法等等。

最后调用这个方法，让每一个 path 从左到右依次出来，整个书写的动画就完成了。

```javascript
strokeLetter(paths[0], strokes[0]);
```

最后，给大家分享一个用 svg 做动画更有趣的例子：[不依赖任何库打造属于自己的可视化数据地图](https://juejin.cn/post/6865591917279870990)，文章作者用`svg`实现了一个真实地图的加载动画，有兴趣可以去观摩学习。

参考文章:

1. [SVG 文档](https://developer.mozilla.org/en-US/docs/Web/SVG)
2. [viewBox](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/viewBox)
3. [Web Animations API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API)
4. [Web Animations 的 animate 方法](https://developer.mozilla.org/en-US/docs/Web/API/Animation)
5. [svg 动画以描边以及文字书写 使用](https://blog.csdn.net/chao2458/article/details/84983203)
6. [SVG 之 ViewBox](https://segmentfault.com/a/1190000009226427?utm_source=tag-newest)

最后，这个系列项目的 github 地址：[native-web-projects](https://github.com/ytppp/native-web-projects)，欢迎大家 star。我的个人网站：[yangtp.com](https://www.yangtp.com/)，欢迎大家空闲时候来串串门呀。

> 本文章属于个人原创，转载请标明出处。
