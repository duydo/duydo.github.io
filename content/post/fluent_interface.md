---
title: "Fluent Interface"
date: 2009-03-25T08:11:23+07:00
lastmod: 2009-03-25T08:11:23+07:00
draft: true
keywords: []
description: ""
tags: ["java", "fluent-interface", "engineering"]
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

I've played with my own  framework recently, I found a new term, called "Fluent Interface". There is a great [article](http://martinfowler.com/bliki/FluentInterface.html) of Martin Fowler about this term, you can read it if you have not heard about it yet.

The idea of  "Fluent Interface" is instead of returning void in  setter methods of an object, returning an object to promote object chaining.

<!--more-->

Example:
```java
class Query {
    private String props;
    private String table;
    private String condition;

    public Query select(String props) {
        this.props = props;
        return this;
    }

    public Query from(String table) {
        this.table = table;
        return this;
    }

    public Query where(String condition) {
        this.condition = condition;
        return this;
    }

    public String buildQuery() {
        return String.format("SELECT %s FROM %s WHERE %s", props, table, condition);
    }
}
```
Instead of:
```java
Query q = new Query();
q.select("username");
q.from("user");
q.where("username = 'duydo'");
String sql = q.buildQuery();
```
We can write:
```Java
Query q = new Query();
String sql = q.select("username").from("user").where("username = 'duydo'").buildQuery();
```
This will make code more readable, but be careful when use this technique.
