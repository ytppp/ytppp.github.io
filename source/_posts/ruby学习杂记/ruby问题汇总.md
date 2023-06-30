---
title: ruby问题汇总
description: 记录一些ruby学习上遇到的问题
tags:
  - ruby
categories:
  - ruby学习杂记
---

1. gem和bundle的区别是什么？

- bundle: 用来管理维护项目的软件包。例如，在rails项目下执行: `bundle install`
- gem: 用来管理具体的每一个软件包。例如，安装rails: `gem install rails`

2. 目前最流行的 Rails 部署方式是 Passenger、Puma 或者 Unicorn 配合 Nginx 使用，此外 Puma 已经开始被 Rails 社区作为首选了