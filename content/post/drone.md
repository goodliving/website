---
title: "Drone的安装使用"
date: 2018-06-15T14:23:58+08:00
draft: false
subtitle: "手把手教你安装Drone"
categories: "CD"
tags: ["drone", "docker", "gitea"]
nocomment: true
postmeta: false
share: true
---

### 概述

[Drone](http://docs.drone.io/zh/installation/)是一个轻量级，为容器构建的强大的持续交付平台。`Drone`通过`Docker`镜像的方式来实现打包和发布。

### 安装

`Drone`的官方推荐使用`docker-compose`来安装。下面配置是官方的一个安装实例

```yaml
version: '2'

services:
  drone-server:
    image: drone/drone:0.8

    ports:
      - 80:8000
    volumes:
      - /var/lib/drone:/var/lib/drone/
    restart: always
    environment:
      - DRONE_OPEN=true
      - DRONE_HOST=${DRONE_HOST}
      - DRONE_GITHUB=true
      - DRONE_GITHUB_CLIENT=${DRONE_GITHUB_CLIENT}
      - DRONE_GITHUB_SECRET=${DRONE_GITHUB_SECRET}
      - DRONE_SECRET=${DRONE_SECRET}

  drone-agent:
    image: drone/drone:0.8

    command: agent
    restart: always
    depends_on:
      - drone-server
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_SERVER=drone-server:9000
      - DRONE_SECRET=${DRONE_SECRET}
```

`Drone`可以整合多个版本控制系统，使用环境变量来配置，如`gitea`，可以查看[gitea配置](http://docs.drone.io/install-for-gitea/)来获取安装帮助。

以下是个人的安装配置，其中使用`mysql`数据来代替默认的`sqlite`

```yaml
version: '2'

services:
  drone-server:
    image: drone/drone:0.8.5

    ports:
      - 8080:8000
      - 9000
    volumes:
      - /var/lib/drone:/var/lib/drone/
    restart: always
    depends_on:
      - db
    environment:
      - DRONE_OPEN=true
      - DRONE_HOST=http://192.168.200.157:8080
      - DRONE_GITEA=true
      - DRONE_GITEA_URL=http://192.168.200.157:3000
      - DRONE_SECRET=x25WM5TaTXGK5vQ0kgv
      - DRONE_DATABASE_DRIVER=mysql
      - DRONE_DATABASE_DATASOURCE=root:86LzseBTczbp@tcp(db:3306)/drone?parseTime=true

  drone-agent:
    image: drone/agent:0.8.5

    restart: always
    depends_on:
      - drone-server
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_SERVER=drone-server:9000
      - DRONE_SECRET=x25WM5TaTXGK5vQ0kgv

  db:
    image: bitnami/mariadb
    ports:
      - 3306
    restart: always
    volumes:
      - ./mariadb:/bitnami
    environment:
      - MARIADB_ROOT_PASSWORD=86LzseBTczbp
      - MARIADB_DATABASE=drone
```

> **将`gitea`的地址替换成自己安装的地址，其他参数可以配置成自己需要的**

通过`docker-compose ps`来查看启动结果，出现以下表示一切正常

```shell
[root@nodejs-200 drone]# docker-compose ps
        Name                    Command                State                                    Ports
-----------------------------------------------------------------------------------------------------------------------------------
drone_db_1             /app-entrypoint.sh /run.sh   Up             0.0.0.0:32777->3306/tcp
drone_drone-agent_1    /bin/drone-agent             Up (healthy)   3000/tcp
drone_drone-server_1   /bin/drone-server            Up             443/tcp, 80/tcp, 0.0.0.0:8080->8000/tcp, 0.0.0.0:32776->9000/tcp
```

对于失败的情况，通过查看日志来确认。

> **对于bitnami/mariadb的镜像有一个已知的`bug`，可以通过`chmod 777 mariadb`来改变目录权限来规避问题。或者自行替换官方的数据库镜像**

最后，我们打开浏览器，输入地址：`http://$ip:$port`，登陆用户密码输入`gitea`注册的用户密码。`Drone`会自行同步`gitea`的项目名称过来，每个项目都有一个开关来控制代码编译。当打开后，我们在对应的项目中提交代码后，`Drone`会根据我们在`.drone.yml`中配置的构建步骤来执行，最终完成我们的代码构建以及其他后续的步骤。

> **具体的操作使用参考[Drone使用](http://docs.drone.io/getting-started/)。**



