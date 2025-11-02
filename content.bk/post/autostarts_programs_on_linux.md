---
title: "Autostart Programs On Linux"
date: 2007-06-19T12:48:32+07:00
lastmod: 2023-01-03T12:48:32+07:00
tags: ["engineering", "linux"]

draft: true
---

Bài viết này nhằm cung cấp các cách để chương trình có thể khởi động ngay sau khi chúng ta đăng nhập vào hệ thống Linux (autostart programs).

<!--more-->

Chú ý: Các bạn mới tìm hiểu về Linux chú ý rẵng kí hiệu ~ thay thế cho đường dẫn đến thư mục home của user. Các chỉ dẫn này điều đã được kiểm tra trên Ubuntu và FC, mình nghĩ nó cũng sẽ work trên các distro khác 😀

### 1. Đối với KDE:
Ta đặt các chương trình mong muốn autostart vào `~/.kde/Autostart`.

Để cho đơn giản chúng ta tạo các “soft link” cho các chương trình ta muốn autostart rồi đặt vào.

```sh
 cd ~/.kde/Autostart
 ln -s /usr/bin/gaim gaim
```

### 2. Đối với FluxBox:
Ta đặt các chương trình mong muốn autostart vào `~/.fluxbox/startup`. Chú ý là danh sách các chương trình đưa vào phải được đặt trước dòng `exec /usr/bin/fluxbox`.

Ví dụ: Đưa GAIM và danh sách autostart:

Mở file `~/.fluxbox/startup` chèn `/usr/bin/gaim &` vào trước `exec /usr/bin/fluxbox`

### 3. Đối với GNOME:
Đưa danh sách các chương trình muốn autostart vào `~/.gnome2/session-manual` với cú pháp như sau:
```
[Default]num_clients=1
0,RestartClientHint=3
0,Priority=50
0,RestartCommand=gdesklets
0,Program=gdesklets
```
Nếu dùng GUI thì vào `Menu Preferences -> Sessions -> Startup Programs`, rồi add các chương trình chúng ta muốn khởi động vào.
