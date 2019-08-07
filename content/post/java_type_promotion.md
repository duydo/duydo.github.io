---
title: "Java: Type Promotion"
date: 2018-08-06T18:51:46+07:00
lastmod: 2018-08-06T18:51:46+07:00
draft: false
keywords: []
description: ""
tags: ["java",  "type-promotion", "engineering"]
categories: []
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: false
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
---

Cách đây khá lâu mình đem đoạn mã đơn giản bên dưới hỏi một số bạn làm Java, cả juniors và seniors, tất cả các bạn đều bảo rằng đoạn mã này không có vấn đề gì, biên dịch và chạy được.

```java
byte b = 1;
b = b * 2;
```
Thật ra thì đoạn mã trên không thể biên dịch được.

Trước tiên thử phân tích xem vì sao các bạn trả lời như vậy.
Nhìn vào đoạn mã thì thấy `b` được khai báo kiểu `byte` và gán giá trị `1`, khai báo này hoàn toàn hợp lệ vì tầm trị của kiểu `byte` trong Java từ -128 đến 127.

Dòng mã tiếp theo gán `b = b * 2`, lúc này biểu thức `b * 2` sẽ có giá trị là `1 * 2 = 2`, thuộc tầm trị [-128, 127] nên hoàn toàn có thể gán được lại cho b. Từ đây các bạn trả lời như đinh đóng cột đoạn mã trên biên dịch và chạy được là cái chắc :D

Nhưng các bạn đã nhầm, thực ra mọi thứ không diễn ra như vậy, vấn đề nằm ở dòng mã thứ 2, `b = b * 2`.

Khi thực hiện phép tính `b * 2`, Java tự động chuyển kiểu của `b` từ `byte` thành `int` để thực hiện phép * với 2, (2 là integer literal nên có kiểu int) và kết quả của `b * 2` có kiểu `int`. Tới đây thì ta đã rõ vì sao `b = b * 2` không thực hiện được vì thằng mang kiểu `int` thì không thể nào gán cho thằng mang kiểu `byte` được.

Quá trình tự động chuyển kiểu dữ liệu như vậy gọi là **Type Promotion**. Các bạn chỉ cần nhớ nguyên tắc chung khi thực hiện các biểu thức tính toán, Java sẽ tự động chuyển các kiểu dữ liệu của các toán hạng (operand) có tầm trị thấp sang kiểu dữ liệu của toán hạng có tầm trị cao hơn và kết quả của phép tính sẽ có kiểu dữ liệu của toán hạng có tầm trị cao nhất.

Cụ thể, các kiểu `byte`, `short` và `char` sẽ được chuyển thành `int` trước tiên, sau đó nếu toán hạng tiếp theo có kiểu `long` thì toàn bộ biểu thức sẽ chuyển thành `long`, cứ thế chuyển lên `float` và cuối cùng là `double`.

> byte, short, char => int => long => float => double


Chúc anh em code Java vui vẻ <3
