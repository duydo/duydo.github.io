---
title: "Debug stuck Celery worker"
date: 2019-08-05T14:09:54+07:00
lastmod: 2019-08-05T14:09:54+07:00
draft: true
keywords: []
description: ""
tags: ["celery", "python", "debug", "engineering"]
author: "duydo"

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: false
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
---

```sh
[2019-07-26 03:41:35,738 - celery - CRITICAL] Couldn't ack 6209, reason:error(32, 'Broken pipe')
```

```sh
duy@goku-worker-de:~$ sudo supervisorctl status
goku-worker                      RUNNING   pid 26738, uptime 11 days, 2:19:10
duy@goku-worker-de:~$
```
<!--more-->


```sh 
duy@goku-worker-de:~$ sudo strace -p 26738 -c
strace: Process 26738 attached
^Cstrace: Process 26738 detached
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 62.16    0.000023           1        25           epoll_wait
 18.92    0.000007           0        17        17 recvfrom
 18.92    0.000007           0        70           clock_gettime
------ ----------- ----------- --------- --------- ----------------
100.00    0.000037                   112        17 total
duy@goku-worker-de:~$
```

```sh 
duy@goku-worker-de:~$ sudo strace -p 26738 -f
...
[pid 26738] recvfrom(5, 0x7fbead4995c4, 7, 0, NULL, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399616, 441000388}) = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399616, 441208787}) = 0
[pid 26738] epoll_wait(15, [], 64, 502) = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399616, 944133989}) = 0
[pid 26738] recvfrom(21, 0x7fbead4995c4, 7, 0, NULL, NULL) = -1 EAGAIN (Resource temporarily unavailable)
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399616, 944706657}) = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399616, 944870229}) = 0
[pid 26738] epoll_wait(15, [], 64, 999) = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399617, 944471272}) = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399617, 944612143}) = 0
[pid 26738] epoll_wait(15, [], 64, 1)   = 0
[pid 26738] clock_gettime(CLOCK_MONOTONIC, {3399617, 945931383}) = 0
[pid 26738] recvfrom(21, 0x7fbead4995c4, 7, 0, NULL, NULL) = -1 EAGAIN (Resource temporarily unavailable)
```

```sh 
duy@goku-worker-de:~$ sudo ls -la /proc/26738/fd/5
lrwx------ 1 xomad xomad 64 Aug  2 06:05 /proc/26738/fd/5 -> socket:[99157475]
duy@goku-worker-de:~$ sudo ls -la /proc/26738/fd/21
lrwx------ 1 xomad xomad 64 Aug  2 06:05 /proc/26738/fd/21 -> socket:[99144296]
duy@goku-worker-de:~$ sudo ls -la /proc/26738/fd/15
lrwx------ 1 xomad xomad 64 Aug  2 06:05 /proc/26738/fd/15 -> anon_inode:[eventpoll]
duy@goku-worker-de:~$
```

```sh 
duy@goku-worker-de:~$ sudo lsof -p 26738 | grep 99157475
celery  26738 xomad    5u     IPv4 99157475      0t0      TCP goku-worker-de.c.xomad-1084.internal:50954->rabbit-de-2.c.xomad-1084.internal:amqp (ESTABLISHED)
```



```sh 
duy@goku-worker-de:~$ sudo lsof -p 26738 | grep 99144296
celery  26738 xomad   21u     IPv4 99144296      0t0      TCP goku-worker-de.c.xomad-1084.internal:38194->rabbit-de-2.c.xomad-1084.internal:amqp (ESTABLISHED)
```

```sh 
duy@goku-worker-de:~$ sudo head -n1 /proc/26738/net/tcp; grep -a 99157475 /proc/26738/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
  10: 8A01010A:C70A 5E00010A:1628 01 00000000:00000000 02:00000351 00000000  1005        0 99157475 2 0000000000000000 20 4 30 10 -1
```

```sh 
duy@goku-worker-de:~$ sudo head -n1 /proc/26738/net/tcp; grep -a 99144296 /proc/26738/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
  27: 8A01010A:9532 5E00010A:1628 01 00000000:00000000 02:00000B01 00000000  1005        0 99144296 2 0000000000000000 20 4 0 10 -1
duy@goku-worker-de:~$
 
```
