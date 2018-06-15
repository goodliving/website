---
title: "Hugo的安装使用介绍"
date: 2018-06-15T10:44:21+08:00
draft: false
share: true
---
### 概述

这是关于`hugo`的搭建过程记录。

### 安装

对于`hugo`的安装，可以参考[官方安装指南](http://www.gohugo.org/)，在`windows`上的使用二进制文件安装过程，到[Hugo Release](https://github.com/gohugoio/hugo/releases)下载`windows`操作系统的`Hugo`二进制文件，之后将`hugo.exe`加入到环境变量中即可。

### 生成站点

使用`Hugo`快速生成站点，打开`git`命令行界面，切换要生成站点的目录下

```shell
$ hugo new cooper-docs
```

之后，`cd cooper-docs`中会生成一系列目录。

### 创建文章

创建一个`about`页面

```shell
$ hugo new post/about.md
```

`about.md`自动生成到`content/about.md`，`about.md`内容如下

```shell
+++
date = "2015-10-25T08:36:54-07:00"
draft = true
title = "about"

+++

正文内容
```

### 安装皮肤

到[皮肤列表](http://www.gohugo.org/theme/)挑选一个心仪的皮肤，比如`Hyde`，找到相关的`Github`地址，在站点的`themes`目录下将皮肤下载下来

```shell
$ cd themes
$ git clone https://github.com/spf13/hyde.git
```

### 运行`Hugo`

在你的站点根目录执行`hugo`命令进行调试

```shell
$ hugo server --theme=hyde --buildDrafts
```

浏览器里打开：`http://localhost:1313`，这时你会发现啥都没有。。。

这里，我们需要对于`about.md`的文件进行一些配置，最终配置如下

```shell
+++
date: "2015-10-25T08:36:54-07:00"
draft: false
title: "about"
share: true
+++
hello world
```

之后，重新运行`hugo`命令，再次打开浏览器，你会看到你网站有个`about`文章，正文内容是`hello world`。

### 部署

在站点根目录执行`Hugo`命令生成最终页面

```shell
$ hugo --theme=hyde --baseUrl="http://coderzh.github.io/"
```

其中替换`baseUrl`的域名为你自己的即可。

如果一切顺利，所有静态页面都会生成到`public`目录，该目录下就是我们所需要的静态文件，之后部署到一个`nginx`即可访问。