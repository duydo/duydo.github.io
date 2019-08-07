---
title: "Effective JPA with Enumeration"
date: 2010-01-24T08:17:50+07:00
lastmod: 2010-01-24T08:17:50+07:00
draft: false
keywords: []
description: ""
tags: ["java", "jpa", "engineering"]
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

How to persist an enumeration effectively? Here is my experience.

I will use Wordpress for example. We all know that every post in wordpress blog system has a status with possible values: draft, pending-review, published...

<!--more-->

There are some ways to model the post entity. We can save status as an integer value in database: draft -> 0, pending-review -> 1, published -> 2

### Version 1

```java
@Entity
public class Post {
	private Integer status;

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}
}
```

Well that's ok, clients can use it like this:
```java
Post post = ...;
	//Draft post
post.setStatus(0);
repository.store(post);
```

But this is not safe, the clients can set any integer value for status. For more safe, we can define constants for status values like that:

```java
public class PostStatus {
	public static final Integer DRAFT = 0;
	public static final Integer PENDING_REVIEW = 1;
	public static final Integer PUBLISHED = 2;
}
```
Now the clients can use:
```Java
Post post = ...;
//Draft post
post.setStatus(PostStatus.DRAFT);
repository.store(post);
```

But it is still not safe, because the client maybe do not use `PostStatus` class. So for more safe, what we need to do?
Yes, we can force the client use `PostStatus` by declaring `PostStatus` as an `Enum` and make it dependency in `Post` class:

### Version 2

```Java
public enum PostStatus {
	DRAFT, PENDING_REVIEW, PUBLISHED;
}

@Entity
public class Post {
	@Enumerated
	private PostStatus status;

	public PostStatus getStatus() {
		return status;
	}

	public void setStatus(PostStatus status) {
		this.status = status;
	}
}
```

And now the clients can use it:
```Java
Post post = ...;
//Draft post
post.setStatus(PostStatus.DRAFT);
repository.store(post);
```

Well, it is better. But wait...
We know that JPA persists all enum constants in order we declare them in `PostStatus` with value started from 0. This is limitation, we can not change order of constants, we only can append a new constant. How does we solve this limitation?

### Version 3

`Enum` type in Java 5 is wonderful, we can add constructor and do some business logic in it. Apply it we can re-write `PostStatus` like this:

```Java
public enum PostStatus {
	DRAFT(0),
	PENDING_REVIEW(1),
	PUBLISHED(2);

	private final Integer value;
	private PostStatus(Integer value) {
		this.value = value;
	}
	public Integer getValue() {
		return value;
	}
}
```

And Post class is rewritten like this:
```Java
@Entity
public class Post {
	private Integer status;

	public PostStatus getStatus() {
		//TODO we need a helper to convert status value to PostStatus enum
		return ...;
	}

	public void setStatus(PostStatus status) {
		this.status = status.getValue();
	}
}
```

Great!!!

Now client can use code safety and we can add many constants as we want into PostStatus without worry about order of them.

It reminds me of the sentence the guy talked in Java4Ever trailer: "Look how beautiful, robust, secure, portable and scalable it is" ;-)
