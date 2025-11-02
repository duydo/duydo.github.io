+++
tags = ["talks", "engineering", "celery", "python", "distributed-system", "queue"]
date = "2016-10-17T08:28:45+07:00"
title = "Celery - a Distributed Task Queue"
slug="celery-a-distributed-task-queue"
comment = true
+++

I gave a talk about [Celery](http://www.celeryproject.org) when working at [Sentifi](http://sentifi.com).
<!--more-->

> Celery is an asynchronous task queue/job queue based on distributed message passing. It is focused on real-time operation, but supports scheduling as well.
The execution units, called tasks, are executed concurrently on a single or more worker servers using multiprocessing, `Eventlet`, or `gevent`. Tasks can execute asynchronously (in the background) or synchronously (wait until ready).
Celery is used in production systems to process millions of tasks a day.
