---
title: 用docker中运行training/webapp
description: 通过training/webapp这个官方镜像学习 docker 的一些基本操作
tags:
  - docker
  - training/webapp
  - python
---

## 关于 training/webapp

`training/webapp`是由`docker`官方维护的一个镜像，它是一个专门用于试验的python web app。运行的效果就是在网页中呈现一个hello world。这里用这个镜像学习 docker 的一些基本操作。

(补图片)

## 拉取 training/webapp 镜像

命令：`docker pull training/webapp`

(补图片)

拉取完成可使用 `docker images` 命令查看镜像是否在镜像列表中。

(补图片)

## 启动镜像

命令：`docker run -d -P training/webapp python app.py`

注意！这里是大写的`P`。各参数意义如下：

- docker: Docker 的二进制执行文件
- run: 与前面的`docker`组合来运行一个容器
- -d: 让容器在后台运行
- -P: 将容器内部使用的网络端口随机映射到我们使用的主机上
- training/webapp: 指定要运行的镜像
- python app.py: 启动容器时运行的命令

(补图片)

其他命令:

- 运行交互式的容器: `docker run -i -t ubuntu:15.10 /bin/bash`

这里：
- -t: 在新容器内指定一个伪终端或终端。
- -i: 允许你对容器内的标准输入 (STDIN) 进行交互。

(补图片)

要退出，输入`exit`即可

## 查看web应用的容器

命令：`docker ps`

(补图片)

这个时候可以看到PORTS列多了端口映射信息，Docker开放了5000端口（默认 Python Flask 端口）映射到主机端口49153上。

列的信息简介：
- CONTAINER ID: 容器 ID
- IMAGE: 使用的镜像
- COMMAND: 启动容器时运行的命令
- CREATED: 容器的创建时间
- STATUS: 容器状态，一共有7种：
  - created（已创建）
  - restarting（重启中）
  - running 或 Up（运行中）
  - removing（迁移中）
  - paused（暂停）
  - exited（停止）
  - dead（死亡）
- PORTS: 容器的端口信息和使用的连接类型（tcp\udp）。
- NAMES: 自动分配的容器名称


## 访问web应用

在主机的浏览器输入: `http://localhost:49153`

(补图片)

这样就说明运行成功了

### 如何换个端口

由于上面启动镜像使用的端口是随机映射的，而在生产环境中端口可能是经过规划的，所以这里试验如何指定端口，需要注意的是主机的端口不一定都是开放的，在使用前要进行确认。

命令：`docker run -d -p 5000:5000 training/webapp python app.py`

这里使用了小写的p，将容器的5000端口映射到了主机的5000端口

运行命令：`docker ps`

(补图片)

再在主机的浏览器输入: `http://localhost:5000`

(补图片)

可以看到5000端口能够成功访问。需要注意的是，由于之前的容器也在后台运行，所以localhost:49153也能够正常访问。

### 如何停止容器

上面在docker中运行了两个相同的容器，此时就需要停止一个以节约资源。停止容器有两种方式：

* 通过**容器名称**停止： `docker stop <container_name>`
* 通过**窗口ID**停止： `docker stop <container_id>`

(补图片)

停止后通过`docker ps`就只看到一个容器了

要再次启动已经停止的容器，`docker restart <container_id>`

### 如何移除容器

在上一步中，只是停止了容器，使它不活跃了。使用命令`docker ps -a`（这个命令，可以查看所有的容器）会看到，容器只是停止了，但是依然存在于我们的系统中。这时需要使用`docker rm <container_id>`移除容器

使用`docker rm <container_id>`移除容器后再`docker ps -a`

(补图片)