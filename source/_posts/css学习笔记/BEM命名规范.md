---
title: BEM命名规范
description: 一些 BEM 命名规范的介绍
tags:
  - css
  - bem
categories:
  - css学习笔记
date: 2021-01-07 00:00:00
---
## 什么是 BEM 命名规范？

Bem 是块（block）、元素（element）、修饰符（modifier）的简写，由 Yandex 团队提出的一种前端 CSS 命名命名约定。让你的前端代码更容易阅读和理解，更容易协作，更容易控制，更加健壮和明确，而且更加严密。

> 中划线`-`: 仅作为连字符使用，表示某个块或者某个子元素的多单词之间的连接记号。

> 双下划线`__`: 用来连接块和块的子元素。

> 双中划线`--`: 用来描述一个块或者块的子元素的一种状态。

## 什么时候应该用 BEM 格式

当需要明确关联性的模块关系时，应当使用 BEM 格式。比如只是一条公共的单独的样式，就没有使用 BEM 格式的意义：

```css
.hide {
  display: none !important; /* 没必要用 */
}
```

## 命名实例:

```html
<div class="article">
  <div class="article__body">
    <div class="tag"></div>
    <button class="article__button--primary"></button>
    <button class="article__button--success"></button>
  </div>
</div>
```
## 常规写法

```css
.xxx {
}
.xxx .xxx__item {
}
.xxx .xxx__item--current {
}
.xxx .xxx__item--hightlight {
}
.xxx .xxx__product-name {
}
.xxx .xxx__link {
}
.xxx .xxx__ming-zi-ke-yi-hen-chang {
}

## 嵌套写法（需要css预处理器支持，例如scss、less等）

.xxx__item_current {
  .xxx__link {
  }
  .xxx__item--current {
  }
  .xxx__item--hightlight {
  }
  .xxx__product-name {
  }
  .xxx__link {
  }
  .xxx__ming-zi-ke-yi-hen-chang {
  }
}
```

```html
<!-- 对应的HTML结构如下 -->
<ul class="xxx">
  <li class="xxx__item">
    第一项
    <div class="xxx__product-name">我是名称</div>
    <span class="xxx__ming-zi-ke-yi-hen-chang">看类名</span>
    <a href="#" class="xxx__link">我是link</a>
  </li>

  <li></li>
  <li class="xxx__item xxx__item--current">
    第二项 且 当前选择项
    <div class="xxx__product-name">我是名称</div>
    <a href="#" class="xxx__item-link">我是link</a>
  </li>

  <li></li>
  <li class="xxx__item xxx__item--hightlight">
    第三项 且 特殊高亮
    <div class="xxx__product-name">我是名称</div>
    <a href="#" class="xxx__item-link">我是link</a>
  </li>

  <li></li>
</ul>
```
