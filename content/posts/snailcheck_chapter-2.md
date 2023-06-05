+++
title = "SnailCheck: Chapter 2"
author = ["Jeffrey Fisher"]
date = 2023-05-28
tags = ["snailcheck", "ocaml"]
draft = true
math = true
+++

We've already seen the enumeration of the natural numbers.


## <span class="org-todo todo TODO">TODO</span> Mention that for integers we could do it without `interleave` {#mention-that-for-integers-we-could-do-it-without-interleave}

Could define a function for incrementing and alternating sign. However the code ends up being less elegant, and `interleave` comes in handy a lot and especially for ADTs.

Maybe this can be a footnote. Not sure if I want to show actual code for doing so. Maybe I'll write it out and decide based on how long it is.

```haskell
ints' n = n : (-n) : (ints' $ n + 1)
ints = 0 : (ints' 1)
```


## <span class="org-todo todo TODO">TODO</span> ? Enumerating algebraic data types (ADT) {#enumerating-algebraic-data-types--adt}

This may go in chapter 3. Decide based on how long (how many words / estimated reading time) chapter 2 ends up being.

On the one hand, would be nice to put all the type enumeration together. On the other hand, it could be nice to have a short and sweet post that describes the problem with a non-lazy `interleave`.
