---
title: "Cấu trúc thư mục hệ điều điều hành Linux"
date: 2007-06-15T12:39:40+07:00
lastmod: 2023-01-03T12:39:40+07:00
draft: false
keywords: []
description: ""
tags: ["linux"]
categories: ["Engineering"]
author: ""
---



Lần đầu tiên bước vào khám phá thế giới của các “chú chim cánh cụt” có lẽ các bạn sẽ ngạc nhiên khi thấy Linux có khá nhiều thư mục và không có khái niệm ổ đĩa như trên Windows. Nhìn chung các thư mục này đã được chuẩn hóa với những mục đích sử dụng nhất định. Mộ hệ thống Linux thường có những thư mục sau:

<!--more-->

**/bin**: Thư mục này chứa các file chương trình thực thi dạng nhị phân và các chương trình khởi động của hệ thống.

**/boot**: Các file ảnh (image file) của kernel dùng cho quá trình khởi động thường đặt trong thư mục này.

**/dev**: Thư mục này chứa các file thiết bị. Trong thế giới *nix và Linux các thiết bị phần cứng (device) được xem như là các file. Đĩa cứng và phân vùng cũng là file như hda1, hda2, hdb1, hdb2, đĩa mềm thì mang tên fd0… các file thiết bị này thường được đặt trong này.

**/etc**: Thư mục này chứa các file cấu hình toàn cục của hệ thống. Có thể có nhiều thư mục con trong thư mục này nhưng nhìn chung chúng chứa các file script để khởi động hay phục vụ cho mục đích cấu hình chương trình trước khi chạy.

**/home**: Thư mục này chứa các thư mục con đại diện cho mỗi user khi đăng nhập. Nơi đây là thư việc làm việc thường xuyên của người dùng. Khi người quản trị tạo tài khoản cho bạn họ sẽ cấp cho bạn một thư mục cùng tên với tên tài khoản nàm trong thư mục /home. Bạn có mọi quyền thao tác trên thư mục của mình và mà không ảnh hưởng đến người dùng khác.

**/lib**: Thư mục này chứa các file thư viện .so (shared object) hoặc .a. Các thư viện C và liên kết động cần cho chương trình chạy và cho toàn hệ thống. Thư mục này tương tự như thư mục SYSTEM32 của Windows.

**/lost+found**: Cái tên nghe lạ lạ phải không các bạn ? :), nhưng mang đúng nghĩa của nó. Khi hệ hệ thống khởi động hoặc khi bạn chạy trình fsck, nếu tìm thấy một chuỗi dữ liệu nào thất lạc trên đĩa cứng và không liên quan đến đến các tập tin, Linux sẽ gộp chúng lại và đặt trong thư mục này để nếu cần bạn có thể đọc và giữ lại dữ liệu bị mất.

**/mnt**: Thư mục này chứa các kết gán (mount) tạm thời đến các ổ đĩa hoặc thiết bị khác. Bạn có thể tìm thấy trong /mnt các thư mục con như cdrom hoặc floppy.

**/media**: Tương tự như /mnt (các phiên bản linux mới mới có thư mục này).

**/sbin**: Thư mục này chứa các file thực thi của hệ thống dành cho người quản trị (root).

**/tmp**: Thư mục tạm dùng để chứa các file tạm mà chương trình tạo ra trong lúc chạy. Các file này sẽ được hệ thống dọn dẹp khi khi các chương trình kết thúc.

**/usr**: Thư mục này chứa rất nhiều thư mục con như /usr/bin, /usr/local… Và đây cũng là mộ trong những thư mục con quan trọng của hệ thóng, bên trong thư mục con này (/usr/local) cũng chứa đầy đủ các thư mục con tương tự ngoài thư mục gốc như sbin, lib, bin… Nếu nâng cấp hệ thống thì các chương trình bạn cài đặt trong thư mục /usr/local vần giữ nguyên và bạn không phải sợ các chương trình bị mất mát. Thư mục này tương tự như thư mục C:\Program Files của Windows.

**/var**: Thư mục này chứa các file biến thiên bất thường như các file dữ liệu đột nhiên tăng kích thước trong một thời gian ngắn sau đó lại giảm kích thước xuống còn rất nhỏ. Điển hình là các file dùng làm hàng đợi chứa dữ liệu cần đưa ra máy in hoặc các hàng đợi chứa mail.

Ngoài ra nếu quan tâm đến lập trình thì ta có thể tìm hiểu thêm một số thư mục khác như:

**/usr/include, /usr/local/inlcude**: Chứa các file header cần dùng khi biên dịch các chương trình nguồn viết bằng C/C++.

**/usr/src**: Thư mục chứa mã nguồn kể cả mã nguồn của Linux.

**/usr/man**: Chứa tài liệu hướng dẫn (manual).
