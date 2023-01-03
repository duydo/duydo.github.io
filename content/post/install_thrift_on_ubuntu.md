---
title: "Install Thrift on Ubuntu"
date: 2010-01-10T12:21:17+07:00
lastmod: 2023-01-03T12:21:17+07:00
keywords: []
description: ""
tags: ["engineering", "thrift", "linux", "ubuntu"]
categories: []
---

A quick note for installing Thrift on Ubuntu.

<!--more-->


0. Install basic lib

```sh
 sudo apt-get install build-essential libboost-dev automake libtool flex bison pkg-config
```

1. Get Thrift:

```sh
 wget http://www.apache.org/dyn/closer.cgi?path=/incubator/thrift/0.2.0-incubating/thrift-0.2.0-incubating.tar.gz
```

2. Install Thrift

```sh
tar zxvf thrift-0.2.0-incubating.tar.gz
cd thrift-0.2.0-incubating
./bootstrap.sh
./configure --with-boost=/usr/local
make
sudo make install
```

3. Done 🙂
