---
title: Docker 学习小计
description: 学习 Docker 的总结
tags:
  - Docker
categories:
  - Docker学习笔记
---

## docker简介

- Docker 是什么

Docker 是一个生态，这个生态专注于管理 Containers（容器）。

- 为什么用 Docker？

Docker 使得安装软件与运行软件十分便利。

安装软件时，可能会碰到各种各样的问题，解决这些问题可能会花费很多人力物力。而 Docker 可以标准化“安装流程”，让用户直接进入运行软件步骤，进而节省成本。

## 基础概念

1. Image

Image 也称为镜像，是一个包含运行指定程序的文件系统快照和启动命令的文件。通常在[Docker Hub](https://hub.docker.com/)下载。

2. Container

Container 也就是容器，是 Image 的一个实例。是一个正在运行的进程，以及机器物理资源的子集。

不同的 Containers 之间，资源是隔离的。

3. Docker Client

用户通过终端与 Docker Client 交互，一个解析用户命令的程序，并发送给 Docker Server。

这个程序本身没有处理 Image 与 Container 的功能。

4. Docker Server

也称之为 Docker Daemon，是负责创建、运行容器的程序。 

## 安装

[官方下载网站](https://docs.docker.com/get-docker/) 

## 拉取镜像

以 training/webapp 为例，training/webapp 是由 docker 官方维护的一个镜像，它是一个专门用于试验的python web app。运行的效果就是在网页中呈现一个hello world。

命令：`docker pull training/webapp`

```
Using default tag: latest
latest: Pulling from training/webapp
Image docker.io/training/webapp:latest uses outdated schema1 manifest format. Please upgrade to a schema2 image for better future compatibility. More information at https://docs.docker.com/registry/spec/deprecated-schema-v1/
e190868d63f8: Pull complete
909cd34c6fd7: Pull complete
0b9bfabab7c1: Pull complete
a3ed95caeb02: Pull complete
10bbbc0fc0ff: Pull complete
fca59b508e9f: Pull complete
e7ae2541b15b: Pull complete
9dd97ef58ce9: Pull complete
a4c1b0cb7af7: Pull complete
Digest: sha256:06e9c1983bd6d5db5fba376ccd63bfa529e8d02f23d5079b8f74a616308fb11d
Status: Downloaded newer image for training/webapp:latest
docker.io/training/webapp:latest
```

拉取完成可使用 `docker images` 命令查看镜像是否在镜像列表中。这里有两个镜像：

```
REPOSITORY        TAG       IMAGE ID       CREATED       SIZE
hello-world       latest    9c7a54a9a43c   4 weeks ago   13.3kB
training/webapp   latest    6fae60ef3446   8 years ago   349MB
```

## 启动镜像

命令：`docker run -d -P training/webapp python app.py`

注意：这里是大写字母P

运行命令后，会打印了容器 ID，这里是`cc54d5db3f55842176c41f42896106c2d02d32214e81856687daa1c506f9070c`。容器 ID 很长，用的时候一般取前几位就行了。

各参数意义如下：

- docker: Docker 的二进制执行文件
- run: 与前面的`docker`组合来运行一个容器
- -d: 让容器在后台运行
- -P: 将容器内部使用的网络端口随机映射到我们使用的主机上
- training/webapp: 指定要运行的镜像
- python app.py: 启动容器时运行的命令

## 查看容器

查看正在运行的容器的命令：`docker ps`

```
CONTAINER ID   IMAGE             COMMAND           CREATED         STATUS       PORTS                     NAMES
cc54d5db3f55   training/webapp   "python app.py"   8 seconds ago   Up 8 seconds   0.0.0.0:32768->5000/tcp   trusting_euclid
```

> 注意：立即执行并退出的容器用上述命令是看不到的

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
- PORTS: 容器的端口映射信息和使用的连接类型（tcp\udp）。
- NAMES: 自动分配的容器名称

上面命令中，Docker开放了5000端口（默认 Python Flask 端口）并映射到主机端口32768上。

如果要查看所有的容器，而不只是正在运行的，可以添加`--all`选项:

```
CONTAINER ID   IMAGE             COMMAND               CREATED              STATUS                          PORTS                     NAMES
13260e7b78ad   busybox           "ping bilibili.com"   About a minute ago   Exited (0) About a minute ago                             peaceful_dijkstra
cc54d5db3f55   training/webapp   "python app.py"       14 minutes ago       Up 14 minutes                   0.0.0.0:32768->5000/tcp   trusting_euclid
bf2bf04f3575   hello-world       "/hello"              20 minutes ago       Exited (0) 20 minutes ago                                 suspicious_bouman
```

### 访问web应用

在主机的浏览器输入: `http://localhost:32768`, 看到 `Hello world!` 就说明运行成功了

### 如何换个端口

运行容器时可以用`-p`切换端口

命令：`docker run -d -p 5000:5000 training/webapp python app.py`

这里将容器的5000端口映射到了主机的5000端口。再在主机的浏览器输入: `http://localhost:5000`。可以看到5000端口能够成功访问。

需要注意的是，由于之前的容器也在后台运行，所以localhost:32768也能够正常访问。运行命令：`docker ps`，可以看到两个training/webapp：

```
CONTAINER ID   IMAGE             COMMAND               CREATED         STATUS                   PORTS                     NAMES
3d405b6cadd2   training/webapp   "python app.py"       3 seconds ago   Up 2 seconds             0.0.0.0:5000->5000/tcp    awesome_babbage
13260e7b78ad   busybox           "ping bilibili.com"   2 hours ago     Exited (0) 2 hours ago                             peaceful_dijkstra
cc54d5db3f55   training/webapp   "python app.py"       2 hours ago     Up 2 hours               0.0.0.0:32768->5000/tcp   trusting_euclid
bf2bf04f3575   hello-world       "/hello"              2 hours ago     Exited (0) 2 hours ago                             suspicious_bouman
```

## 如何停止容器

有两种命令可以停止容器：`docker stop <container_id>` 和 `docker kill <container_id>`。

- docker stop 发送 SIGTERM 信号给容器，容器接收到信号后，执行相关逻辑并停止。

- docker kill 发送 SIGKILL 信号给容器，使它立即终止。

一般情况下我们使用 docker stop 来停止容器，对于容器已经未响应的情况，再使用 docker kill 命令。不过默认情况下，docker stop 命令会在信号发送后10秒钟后，对未停止的容器再发送 SIGKILL 信号。

运行命令`docker stop cc54d5db3f55`，可以看到容器id为 cc54d5db3f55 的容器状态变为 Exited 了：

```
CONTAINER ID   IMAGE             COMMAND               CREATED         STATUS                        PORTS                    NAMES
3d405b6cadd2   training/webapp   "python app.py"       2 minutes ago   Up 2 minutes                  0.0.0.0:5000->5000/tcp   awesome_babbage
13260e7b78ad   busybox           "ping bilibili.com"   2 hours ago     Exited (0) 2 hours ago                                 peaceful_dijkstra
cc54d5db3f55   training/webapp   "python app.py"       2 hours ago     Exited (137) 12 seconds ago                            trusting_euclid
bf2bf04f3575   hello-world       "/hello"              2 hours ago     Exited (0) 2 hours ago                                 suspicious_bouman
```

## 如何重新启动容器

在 Exited 状态并不代表容器没用了，运用命令 `docker start <container_id>` 可以重新启动容器。该命令后添加 -a 来获取容器的标准输出/标准错误

## 如何移除容器

命令：`docker rm <container_id>`

另外，`docker system prune`这个命令会一口气删除所有未运行的容器来节省空间，同时也会删除本地的镜像缓存。
