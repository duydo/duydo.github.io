---
title: "Debugging a Mysterious Celery Worker Freeze in Data Platform: A Linux Deep Dive"
date: 2025-11-02T22:51:59+07:00
tags: ["celery", "rabbitmq", "linux", "epoll", "debugging", "sre", "haproxy", "python"]
draft: true
---

Back in mid-2019, when I was a builder on the Data Platform team at Krom, we hit a wall that still haunts me to this day: Celery workers would silently freeze.

Supervisor insisted they were `RUNNING` — uptime measured in days — but they processed zero tasks. Data pipelines stalled. Alerts went quiet. The only whisper of failure? A cryptic Broken pipe in the logs.

For years, I carried this war story in the back of my mind. The fix we shipped worked — beautifully — but the root cause lived deep in the Linux kernel, untouchable by application code.

Today, I finally decided to write it down — not just to close a chapter, but because this bug is still out there, quietly breaking production systems that depend on Celery and RabbitMQ.

Six years later, [Celery Issue #3773](https://github.com/celery/celery/issues/3773) remains open. The Linux kernel hasn’t changed.

Here’s how I diagnosed a kernel-level `epoll` flaw using `strace`, `/proc`, and raw TCP dumps — and why I ultimately fixed it with HAProxy as an architectural shield.

### 1\. The Clue: A Silent Freeze and the Fatal Broken Pipe

It always started with the same error in the logs, usually when a worker tried to acknowledge a finished task:

```sh
[2019-07-26 03:41:35,738 - celery - CRITICAL] Couldn't ack 6209, reason:error(32, 'Broken pipe')
```

Yet, when I checked `Supervisor`, the process looked perfectly healthy:

```sh
$ sudo supervisorctl status
goku-worker                      RUNNING   pid 26738, uptime 11 days, 2:19:10
```

The process (`PID 26738`) was running, but functionally frozen — a true "zombie" process.

### 2\. Hunting the Hang: Deep Dive with `strace`

I needed to see what the worker was actually doing at the kernel level. Attaching `strace` immediately showed the problem area:

```sh
$ sudo strace -p 26738 -c
strace: Process 26738 attached

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 62.16    0.000023           1        25           epoll_wait
...
```
The worker was spending 62% of its time in `epoll_wait`. It was waiting for an event that would never come.

Running `strace -f` exposed the futile loop:
```sh
$ sudo strace -p 26738 -f
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
...
```
The worker kept trying to `recvfrom` on `FD 5` and `FD 21`, `epoll_wait` on `FD 15`, timing out, and going back to sleep. It was waiting on dead sockets.

### 3\. Tracing the Socket to RabbitMQ

To prove these were network connections, I checked the file descriptor symbolic links:
```sh
$ sudo ls -la /proc/26738/fd/5
lrwx------ 1 xxx xxx 64 Aug  2 06:05 /proc/26738/fd/5 -> socket:[99157475]
$ sudo ls -la /proc/26738/fd/21
lrwx------ 1 xxx xxx 64 Aug  2 06:05 /proc/26738/fd/21 -> socket:[99144296]
$ sudo ls -la /proc/26738/fd/15
lrwx------ 1 xxx xxx 64 Aug  2 06:05 /proc/26738/fd/15 -> anon_inode:[eventpoll]
```
`FD 5` and `FD 21` were clearly sockets, and `FD 15` was the epoll instance managing them. 

Using `lsof` confirmed they pointed straight at our RabbitMQ broker:
```sh
$ sudo lsof -p 26738 | grep 99157475
celery  26738 xxx    5u     IPv4 99157475      0t0      TCP xxx-1084:50954->rabbit.xxx-1084:amqp (ESTABLISHED)

$ sudo lsof -p 26738 | grep 99144296
celery  26738 xxx   21u     IPv4 99144296      0t0      TCP xxx-1084:38194->rabbit.xxx-1084:amqp (ESTABLISHED)
```

The kernel insisted the connection was `ESTABLISHED`. But a final look at the TCP queues told the real story:

```sh
$ sudo head -n1 /proc/26738/net/tcp; grep -a 99157475 /proc/26738/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
  10: 8A01010A:C70A 5E00010A:1628 01 00000000:00000000 02:00000351 00000000  1005        0 99157475 2 0000000000000000 20 4 30 10 -1

$ sudo head -n1 /proc/26738/net/tcp; grep -a 99144296 /proc/26738/net/tcp
  sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
  27: 8A01010A:9532 5E00010A:1628 01 00000000:00000000 02:00000B01 00000000  1005        0 99144296 2 0000000000000000 20 4 0 10 -1
```

Zero bytes in tx/rx queues — a ghost connection. Alive in name, dead in function.


### 4\. The Real Culprit: A Broken OS Mechanism

I realized that no amount of tweaking Celery or Kombu would help — the problem ran deeper than application code.

Core insight: [Linux’s epoll is fundamentally broken](https://idea.popcount.org/2017-02-20-epoll-is-fundamentally-broken-12/) in edge cases. When RabbitMQ crashes or closes a connection uncleanly (e.g., lost FIN packet), the kernel **fails to notify `epoll_wait`**. The socket lingers in `ESTABLISHED` state — alive in `/proc`, dead in reality.

Celery’s event loop, built on Kombu and `epoll`, was **permanently trapped** — waiting for an event that would never arrive.

> You can’t patch the Linux kernel in production.  
> You can’t fork Celery.  
> → **You work around it.**


I realized that no amount of Celery or Kombu code tweaking would fix this. The issue was deeper.

The core insight came from this analysis: [epoll is fundamentally broken 1/2](https://idea.popcount.org/2017-02-20-epoll-is-fundamentally-broken-12/). This is a known, long-standing flaw in Linux’s epoll implementation under edge cases of half-closed or lost FIN packets.  When RabbitMQ failed silently, the Linux kernel failed to report the disconnect to `epoll_wait`. The socket remained in `ESTABLISHED` state, but no events were ever delivered. 

Celery’s event loop — built on `kombu` and `epoll` — was permanently hung. Since I couldn't patch the kernel, the solution had to be external.

### 5\. The Architectural Fix: HAProxy

My solution was to introduce HAProxy as TCP proxy sitting between the Celery workers and RabbitMQ.

#### Why this worked where code failed:

1.  Forced disconnects: HAProxy is better at enforcing `TCP` health. I set strict `timeout client` and `timeout server` values. When RabbitMQ failed, HAProxy detected the failure and actively sent a clean `RST` packet to the `Celery` worker.
2.  Bypassing the flaw: This clean disconnect forced the Celery worker out of the `epoll_wait` hang state with an explicit error, allowing its recovery logic to fire immediately and reconnect cleanly.


This was a humbling lesson in system architecture. For issues rooted in fundamental OS limitations, you have to solve the problem at a higher layer. By deploying HAProxy, we successfully shielded our data platform workers from the silent, fatal connection drops, finally achieving the reliable and high-performance task processing pipeline we needed.