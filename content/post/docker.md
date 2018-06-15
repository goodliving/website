---
title: "Docker的安装使用"
date: 2018-06-15T15:12:05+08:00
draft: false
share: true
---

### 概述

`Docker` 是一个开源的应用容器引擎，基于[Go语言](http://www.runoob.com/go/go-tutorial.html)并遵从Apache2.0协议开源。`Docker` 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 `Linux` 机器上，也可以实现虚拟化。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 `iPhone` 的 `app`）,更重要的是容器性能开销极低。

> **具体的介绍可以通过[Docker官方介绍](https://www.docker.com/)**

### 安装

对于`docker`的安装有源码安装、二进制安装或者其他安装包工具如`yum`、`apt`等，以下通过在`centos7`上来安装`docker`

##### `yum`更换阿里云源

```shell
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

##### 添加docker软件源

```shell
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo 
```

之后，运行`yum makecache`来以上`repo`信息，之后使用`yum install docker-ce`来默认安装最新版本的`docker-ce`版本。以上操作结束后没有报错，那么`docker`版本已经安装到机器上了，通过以下检查是否正确

```shell
[root@nodejs-200 drone]# docker -v
```

会提示你`docker`没有启动，然后，我们需要配置一些相关配置项后启动`docker`：

##### `docker`的`volume`类型

目前`docker`支持如下几种`storage driver`

| technology    | storage driver name |
| ------------- | ------------------- |
| OverlayFS     | overlay             |
| AUFS          | aufs                |
| Btrfs         | btrfs               |
| Device Mapper | devicemapper        |
| VFS*          | vfs                 |
| ZFS           | zfs                 |

对于以上几种的驱动类型的比较，参考博客[Docker之几种storage-driver比较](https://blog.csdn.net/vchy_zhao/article/details/70238690)。

当`docker`安装完毕后，默认是`overlay`，不需要改动，我们需要添加的是镜像加速器地址，在阿里云官网注册账号，获取到一个字符串，在`/etc/docker`中新建一个`daemon.json`文件，将字符串添加到里面，如下

```shell
[root@master docker]# cat daemon.json
{
  "registry-mirrors": ["https://ba8vby2y.mirror.aliyuncs.com"]
}
```

之后，运行`systemctl start docker`，等待运行成功后，通过拉取一个`nginx`镜像来确认安装成功。

```shell
[root@master docker]# docker run -d --name nginx -p 80:80 nginx
```

最后，通过`curl http://localhost`来访问`nginx`的界面，出现`nginx`的静态页面表示一切正常，最后，我们可以使用`docker`来构建我们的容器应用。