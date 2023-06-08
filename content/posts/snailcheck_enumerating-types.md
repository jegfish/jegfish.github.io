+++
title = "SnailCheck: Enumerating types"
author = ["Jeffrey Fisher"]
date = 2023-06-07
tags = ["snailcheck", "ocaml"]
draft = true
math = true
+++

##  {#d41d8c}

[Previous post in this series](/posts/snailcheck_laziness-from-scratch-in-ocaml).

In the previous post we saw the enumeration of the natural numbers. Now we will learn to enumerate more complex types.


## Enumerating booleans {#enumerating-booleans}

Enumerating booleans is simpler than the naturals, but it's worth seeing. We'll make a convenience function for converting a regular list to a lazy list; it will also be useful for testing and for enumerating other types with few values.

```ocaml
let rec of_list xs =
  match xs with
  | [] -> Nil
  | x::xs -> Cons (x, fun () -> of_list xs)
```

```ocaml
let bool : bool lazylist = of_list [true; false]
```

```ocaml

take 2 bool
```

```text
- : bool list = [true; false]
```

Note: We are doing some punning here to allow conciseness.&nbsp;[^fn:1] When used in types "bool" will still refer to the the standard boolean type. But when used in expressions "bool" means this particular lazy list.


## Enumerating integers {#enumerating-integers}


### Problem {#problem}

Listing the integers is non-obvious because unlike the naturals there is no "starting point". In math you can discuss the range \\((-\infty, \infty)\\), but we can't start at negative infinity.

OCaml's `int` type does technically have a starting point, `min_int`, which seems to be \\(-2^{62}\\). Maybe we could do `let int = up_from min_int`? There are a few problems with this:

1.  For a while all you'll be seeing is negative numbers with a large magnitude. It's easier to work with smaller numbers, and we also want to check zero and positive numbers. One of the benefits of enumerative property-based testing is trying the simplest cases first---with random generation you tend to get huge test values that need to be "shrinked".
2.  "a while" is probably longer than a human lifespan. Rough calculations with a 5 millisecond time per check gave me an 11-digit number of _years_. A quick Internet search says even just incrementing a counter from 0 to 2<sup>64</sup> (not even checking properties) would take around 100 years.
3.  Sometimes we may want to use a special integer type that can represent arbitrarily-large integers. Then there will be no such thing as `min_int`.


### Solution {#solution}

There is a way to arrange the integers that gives them a starting point and gives the simplest cases first: \\(0, -1, 1, -2, 2, -3, 3, \ldots\\)&nbsp;[^fn:2]

We could express this as a single generator function like we did with the naturals:

```ocaml

let int : int lazylist =
  let rec ints' n =
    Cons (-n, fun () ->
	     Cons (n, fun () -> ints' (n + 1))) in
  Cons (0, fun () -> ints' 1)
;;

take 9 int
```

```text
- : int list = [0; -1; 1; -2; 2; -3; 3; -4; 4]
```

However, we will express it in a way that I feel is more elegant. It will be useful to examine this technique with the integers first, because we will need it for more complex types later.

\\[\mathbb{Z} = \mathbb{N} \cup \\{-1, -2, -3, \ldots\\}\\]

We can break the integers into pieces. If we combine the natural numbers and the negative integers, we get the set of all integers.

The common way to combine lists is appending.

```ocaml
let rec append xs ys =
  match xs, ys with
  | Nil, ys -> ys
  | Cons (x, xs), ys ->
     Cons (x, fun () -> append (force xs) ys)
```

Let's confirm that our lazy list `append` works:

```ocaml

take 6 @@ append (of_list [1;2;3]) (of_list [4;5;6])
```

```text
- : int list = [1; 2; 3; 4; 5; 6]
```

Now let's try making the integers:

```ocaml
let rec down_from n = Cons (n, fun () -> down_from (n - 1))
```

```ocaml

let int = append nats (down_from (-1)) in
take 9 @@ int
```

```text
- : int list = [0; 1; 2; 3; 4; 5; 6; 7; 8]
```

Oh no, we aren't seeing any negatives!


## <span class="org-todo todo TODO">TODO</span> ? Enumerating algebraic data types (ADT) {#enumerating-algebraic-data-types--adt}

This may go in chapter 3. Decide based on how long (how many words / estimated reading time) chapter 2 ends up being.

On the one hand, would be nice to put all the type enumeration together. On the other hand, it could be nice to have a short and sweet post that describes the problem with a non-lazy `interleave`.


## <span class="org-todo todo TODO">TODO</span> If don't rely on previous chapter tangled code, maybe break this out into its own directory {#if-don-t-rely-on-previous-chapter-tangled-code-maybe-break-this-out-into-its-own-directory}


## <span class="org-todo todo TODO">TODO</span> ? Maybe add a link to the top of the previous post pointing to this post {#maybe-add-a-link-to-the-top-of-the-previous-post-pointing-to-this-post}

[^fn:1]: We're also doing punning because [QCheck](https://c-cube.github.io/qcheck/) does it that way, and we want to be compatible with QCheck.
[^fn:2]: Apparently this is called the [well-ordering of the integers](https://en.wikipedia.org/wiki/Well-order#Integers). I'd seen this ordering before, and I recently learned the Well-Ordering Principle, but hadn't seen this aspect. I'm glad to have learned this connection.