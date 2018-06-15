---
title: "Gitea的安装使用"
date: 2018-06-15T14:23:07+08:00
draft: false
share: true
---

### 概述

Gitea 是一个开源社区驱动的 [Gogs](http://gogs.io/)的[克隆](https://blog.gitea.io/2016/12/welcome-to-gitea/), 是一个轻量级的代码托管解决方案，后端采用 [Go](https://golang.org/) 编写，采用 [MIT](https://github.com/go-gitea/gitea/blob/master/LICENSE) 许可证。

### 安装

对于`gitea`有多种方式，`docker`、[二进制](https://github.com/go-gitea/gitea)以及源码编译安装，以下介绍通过`docker`与`docker-compose`来快速安装。

`docker-compose.yml`文件

```shell
version: '2'
services:
  web:
    image: gitea/gitea
    volumes:
      - ./data:/data
    ports:
      - "3000:3000"
      - "10022:22"
    depends_on:
      - db
    restart: always
  db:
    image: mariadb:10
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_DATABASE=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=123456
    volumes:
      - ./db/:/var/lib/mysql
```

上面一些参数可以修改成自己需要的值，之后，通过`docker-compose up -d`来启动即可，如果出现下面的表示成功安装

```shell
[root@nodejs-200 gogs]# docker-compose ps
   Name                 Command               State                       Ports
---------------------------------------------------------------------------------------------------
gogs_db_1    docker-entrypoint.sh mysqld      Up      3306/tcp
gogs_web_1   /usr/bin/entrypoint /bin/s ...   Up      0.0.0.0:10022->22/tcp, 0.0.0.0:3000->3000/tcp
```

失败的情况下查看日志来确认问题。

> **对于`docker`以及`docker-compose`的安装参考官方文档，默认已经安装完毕**

最后，我们打开浏览器`gitea`的地址，地址为`http://$IP:$Port`，替换成自己机器的`ip`和设置的端口。我们会看到gitea的登陆界面，注册一个账号来使用，没有默认的用户密码。

> **默认第一个注册的用户权限属于管理员**

### 应用场景

`gitea`符合企业内部对于源码的管理，没有`gitlab`的重量级，同时没有自己的`CI`工具，但是，我们可以通过与`Drone`搭配，基于其丰富的插件来组成一个高速的`pipeline`，与`docker`以及`kubernetes`配合构建企业的`CI/CD`。

### 备份与恢复

Gitea 已经实现了 `dump` 命令可以用来备份所有需要的文件到一个zip压缩文件。该压缩文件可以被用来进行数据恢复。

> **具体的使用可以查看[gitea备份与恢复资料](https://docs.gitea.io/zh-cn/backup-and-restore/)。**

