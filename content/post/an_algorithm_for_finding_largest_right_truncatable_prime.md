---
title: "An algorithm for finding right-truncatable primes"
date: 2019-08-06T12:10:30+07:00
lastmod: 2019-08-06T12:10:30+07:00
draft: false
keywords: ["algorithms", "right-truncatable-prime", "prime", "python"]
description: ""
tags: ["algorithms", "right-truncatable-prime", "prime", "python"]
categories: []
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: false
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: true
---

Inspired from [my status on Facebook](https://www.facebook.com/doquocduy/posts/10212275741143230):

> The prime number 73939133 is very special, if removing each digit from right to left of that number we get another prime numbers: 7393913, 739391, 73939, 7393, 739, 73 and 7.

One of my friends gave a challenge:

> Can you write a program reading a number N from keyboard then finding the nearest prime number to N that satisfies the characteristics of 73939133?

As promised him, I would solve this challenge.

<!--more-->

In order to find out an algorithm, we try to do analysis first.

Suppose *p(k)* is the prime, satisfies the characteristics of right-truncatable prime, has k digits: *a(1), a(2),...,a(k)*, value of each digit is in set *{0, 9}*:

\\[p(k) = \overline {a(1)a(2)...a(k)}\\]

Removes one digit from right to left of the number p(i), with i = 1..k, we get:
\\[p(k-1) = \overline {a(1)a(2)...a(k-1)}\\]
\\[p(k-2) = \overline {a(1)a(2)...a(k-2)}\\]
\\[...\\]
\\[p(2) = \overline {a(1)a(2)}\\]
\\[p(1) = \overline {a(1)}\\]

*p(1)* is prime number therefore the value of *a(1)* must be 2, 3, 5 or 7.

Represent the *p(k)* in base 10, we get:

\\[p(k) = 10^{(k-1)}a(1) + 10^{(k-2)}a(2) +...+ 10^1a(k-1) + a(k)\\]


\\[= 10(10^{(k-2)}a(1) + 10^{(k-3)}a(2)+...+a(k-1)) + a(k)\\]

The expression:
\\[10^{(k-2)}a(1) + 10^{(k-3)}a(2)+...+a(k-1)\\]
is actually *p(k-1)*, so we get:

\\[p(k) = 10p(k-1) + a(k)\\]

*p(k)* is prime therefore *a(k)* and *10p(k-1)*, or 2*5*p(k-1), must not have common divisors. This leads to value of *a(k)* must be 1, 3, 7 or 9.

From above analysis we have an algorithm to find the largest right-truncatable prime as following:
```
Algorithm of Finding Largest Right-Truncatable Prime (Input: N)
(1) Let K = number of digits of N
(2) Initialize A = {2, 3, 5, 7}, B = {1, 3, 7, 9}, MAX_PRIME
(3) For i = 2, 3,... up to K:
      Let P = empty list, this list stores primes are found for each i
      With each a in A
          With each b in B:
              Calculate p = 10*a + b
              If p > n: Exit loop (3)
              If p is prime:
                  Set MAX_PRIME = p
                  Add p to P
      If P is empty: Exit loop (3)
      Else: Set A = P
(4) Return MAX_PRIME
```
In step (3), in order to check if a number is prime we can use different algorithms such as: Eratosthenes, Atkin, AKS and Miller-Rabin. I choose [Miller-Rabin](https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test) for testing large input number.

Below is a program I wrote in Python to implement the algorithm. The algorithm can be optimized for more efficient but I leave it for now as an exercise for whom is interested in.

```python
from random import randrange

__author__ = "duydo"

def is_prime(n):
    """Check if n is prime using Miller-Robin test
    :param n: a number to test
    :return: True if n is prime, otherwise False
    """

    def decompose(p):
        """p = 2^k * m"""
        k, m = 0, p
        while m & 1 == 0:
            m >>= 1
            k += 1
        return k, m

    def witness(a, k, m, n):
        r = pow(a, m, n)
        if r == 1:
            return True
        for i in xrange(k - 1):
            if r == n - 1:
                return True
            r = pow(r, 2, n)
        return r == n - 1

    def miller_rabin(n, t=10):
        k, m = decompose(n - 1)  # n - 1 = 2^k * m
        for _ in xrange(t):
            a = randrange(2, n - 1)
            if not witness(a, k, m, n):
                return False
        return True

    if n == 2:
        return True
        # n is even?
    if n & 1 == 0:
        return False

    return miller_rabin(n)


def find_largest_right_truncatable_prime(n):
    """Returns largest right-truncatable prime less than or equals n."""

    assert n > 0
    k = len(str(n))
    a = [2, 3, 5, 7]
    ak = [1, 3, 7, 9]
    max_prime = None
    for i in xrange(2, k + 1):
        r = []
        for u in a:
            for v in ak:
                pk = 10 * u + v
                if pk > n:
                    break
                if is_prime(pk):
                    max_prime = pk
                    r.append(pk)
        if len(r) == 0:
            break
        a = r
    return max_prime


def main():
    n = raw_input('Enter N: ')
    rt_prime = find_largest_right_truncatable_prime(int(n))
    print 'Largest right-truncatable prime <= N:', rt_prime


if __name__ == '__main__':
    main()
```

Modifies above program a little bit, we can print out all right-truncatable prime numbers as followings:

```
23, 29, 31, 37, 53, 59, 71, 73, 79, 233, 239, 293, 311, 313, 317, 373,
379, 593, 599, 719, 733, 739, 797, 2333, 2339, 2393, 2399, 2939, 3119,
3137, 3733, 3739, 3793, 3797, 5939, 7193, 7331, 7333, 7393, 23333, 23339,
23399, 23993, 29399, 31193, 31379, 37337, 37339, 37397, 59393, 59399,
71933, 73331, 73939, 233993, 239933, 293999, 373379, 373393, 593933,
593993, 719333, 739391, 739393, 739397, 739399, 2339933, 2399333, 2939999,
3733799, 5939333, 7393913, 7393931, 7393933, 23399339, 29399999, 37337999,
59393339, 73939133
```

Happy coding <3.
