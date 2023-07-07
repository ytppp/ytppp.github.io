---
title: 基于docker 搭建 ruby开发环境
tags:
  - ruby
categories:
  - ruby学习杂记
---

## 思路

先开启一个临时的 Ruby 容器，在容器内创建项目，之后再构建开发需要的镜像。

### 新建项目

为了创建一个 Rails 项目，先启动一个临时的 Ruby 容器：

```
$ docker run -it -v $(pwd):/app -w /app ruby:3.2 bash
```

在容器内安装 Rails gem：

```
/app# gem install rails
```

然后创建项目：

```
/app# rails new myapp --database postgresql --skip-bundle
```

这里使用了`--skip-bundle`参数，因为这只是个临时容器，稍后会在开发容器内执行 `bundle`。

现在这个临时容器已经完成使命，按 ctrl-d 或者输入 exit 退出容器。

### 添加 Dockerfile

在项目目录下添加`Dockerfile`文件，输入以下内容：

```
FROM ruby:3.2

# ruby 镜像预设的这个环境变量干扰了后面的操作，将它重置为默认值
ENV BUNDLE_APP_CONFIG=.bundle

# 如果需要安装其他依赖，取消这段注释
# RUN apt-get update && apt-get install -y --no-install-recommends \
#   nodejs \
#   npm \
#   postgresql-client

WORKDIR /app
```

这是一个最精简的 Rails 开发环境镜像，如果有需要可以用`apt-get`安装其他系统依赖。

现在还不需要构建镜像，稍后我们会用`docker compose`命令一起构建。

### 添加 docker-compose.yml

在项目目录下添加`docker-compose.yml`文件，输入以下内容：

```
version: "3.9"

services:
  web:
    build: .
    command: bin/rails server -b 0.0.0.0
    volumes:
      - .:/app
    ports:
      - 3000:3000
    depends_on:
      - postgres
  postgres:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: postgres
```

这里定义了 web 和 postgres services。web service 会基于当前目录下的 Dockerfile 文件构建镜像，并且挂载当前目录到容器内的 /app 目录，释出 3000 端口，并且添加了对 postgres servcie 的启动依赖。postgres service 会使用 postgres 镜像，并通过环境变量设置了初始密码。

### 构建镜像

执行以下命令：

```
$ docker compose build
```

Docker Compose 会读取 docker-compose.yml 中的配置，构建相应的镜像。

> 注意：每次修改 Dockerfile 后都要重新执行这个命令。

### 进入命令行

执行以下命令：

```
$ docker compose run web bash
```

这样就会启动 web service 容器，并且打开一个 bash shell。在这个 shell 中我们可以执行本地开发时需要执行的命令，例如 bundle install，bin/rails g 等。

后面需要在容器内执行的操作都会通过这个 shell 执行。

### 执行 bundle

首先在容器内执行以下命令：

```
/app# bundle config set --local path vendor/bundle
```

这个命令将 bundle 的安装目录设为项目下的 vendor/bundle 目录。因为我不希望开发的时候每次更新 Gemfile 都要重新构建镜像。

然后执行 bundle：

```
/app# bundle install
```

> 注意：记得在 .gitignore 中添加 vendor/bundle。

### 准备数据库

在创建数据库前先要修改 Rails 项目的数据库设置，因为在 Docker Compose 搭建的环境中，PostgreSQL 跟 Rails 进程运行在不同的容器中，类似于不同的主机，service 名就是各自的网络名。

修改`database.yml`，在`development`和`test`段加入以下内容：

```
  host: postgres
  username: postgres
  password: postgres
```

然后执行以下命令：

```
/app# bin/setup
```

之后便会创建相应的数据库。

### 启动 web service

经过上面的准备，是时候启动 web service 了。打开另一个终端，输入以下命令：

```
$ docker compose up
```

启动完成后，打开 http://localhost:3000 就能看到 Rails 的启动页面了


## 一种更简单的方式

偶然看大佬的分享发现的：[rails/docked](https://github.com/rails/docked)

先运行下面的命令：

```
$ docker volume create ruby-bundle-cache
$ alias docked='docker run --rm -it -v ${PWD}:/rails -v ruby-bundle-cache:/bundle -p 3000:3000 ghcr.io/rails/cli'
```

然后创造你的 rails 应用:

```
$ docked rails new weblog
$ cd weblog
$ docked rails generate scaffold post title:string body:text
$ docked rails db:migrate
$ docked rails server
```

参考资料:

1. [Rails on Docker: 用 Docker Compose 搭建开发环境](https://geeknote.net/Rei/posts/372)
2. [用 Docked Rails CLI 启动新手环境](https://www.bilibili.com/video/BV1QA411m7E4)
3. [用 Docker 构建开发环境](https://ruby-china.org/topics/37628)