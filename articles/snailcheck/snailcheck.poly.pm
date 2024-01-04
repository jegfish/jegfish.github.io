#lang pollen

◊title{SnailCheck: Laziness from scratch in OCaml}

◊note{
You do not need to be well versed in OCaml or property-based testing to
understand this article. I believe the core idea should apply to any language
with closures.
}

I will be taking you through the design of an enumerative property-based testing (PBT) library, inspired by PearlCheck◊footnote[1] and LeanCheck. Like them, SnailCheck’s main focus is on being easy to understand. One reason I am doing this is to develop a deeper understanding of the details that PearlCheck (rightfully) skips.

Our first stop will be laziness.

◊h2{Property-based testing (PBT)}

Later posts will give a better idea of what property-based testing is, but for now I’ll give a quick definition.

A property is a fact about our program, represented by a predicate (function that returns a boolean). A PBT library checks properties against many inputs.

For example, a function that reverses a list should always obey the property that if you apply it twice, you get back the original list.

◊codeblock[#:lang 'ocaml]{
let prop xs =
  xs = reverse (reverse xs)
}

The PBT library would apply this function to many different lists, making sure that it evaluates to ◊code{true} each time.

◊h2{Motivation for laziness}

Because we are doing enumerative PBT, we want to list (enumerate) the values of a type, so we can plug them into our tests one after another.

Many types have either too many values to reasonably store in memory at once, or infinitely many values. To handle this, we will be using lazy lists, which can be infinite in size.

◊h3{Attempt #1 at the natural numbers}

The natural numbers are ◊math["{0,1,2,3,…}"].

There is a pattern here: the "current" number is the previous number plus
one.◊footnote[2] We repeatedly call the function ◊code{fun n -> n + 1} on the
"current" number, then consider the result the new "current" number.

Let’s list them out.

◊codeblock[#:lang 'ocaml]{
let rec nats n = n :: nats (n + 1);;
nats 0
}
◊stdout{
Stack overflow during evaluation (looping recursion?).
}

There’s a small problem. There are infinitely many natural numbers. We will never reach the end of generating them, and even if we did we wouldn’t have enough memory to store them.

We need to be lazy, to delay computation until later.◊footnote[3]

◊h2{Laziness}

How do we represent computation without immediately evaluating it?

Functions! If you define a function with an infinite loop, it won’t actually freeze your program unless you call the function.

We will represent lazy values with the type ◊code{unit -> 'a}, a function that
takes one argument of type ◊code{unit}, and returns our value. ◊code{unit} is a
special type that only has one value, which is also called “unit” and is written
as empty paired parentheses, ◊code{()}. The argument to our lazy values carries
no information, it’s more of an implementation detail. Really the intention is a
function that takes no arguments, but this is not possible in OCaml.

TODO: Maybe instead do codeblock[#:lang 'ocaml] as the syntax?
◊codeblock[#:lang 'ocaml]{
type 't delayed = unit -> 't
}

A more standard name for "delayed" would be ◊hyperlink["https://en.wikipedia.org/wiki/Thunk"]{thunk}.

Here are some sample lazy values:

◊codeblock[#:lang 'ocaml]{
let a : int delayed = fun () -> 42;;
let b : int delayed = fun () -> List.fold_left (+) 0 [1;2;3];;
}

For readability we will write a function for evaluating lazy values, ◊code{force}.

◊codeblock[#:lang 'ocaml]{
let force lazy_val = lazy_val ()
}

◊stdin[#:lang 'ocaml]{
sprintf "%d\n" (force a)
^ sprintf "%d\n" (force b);;
}
◊stdout{
42
6
}

◊h3{Attempt #2 at natural numbers}

◊codeblock[#:lang 'ocaml]{
let rec up_from n = n :: up_from (n + 1)
let nats : int list delayed = fun () -> up_from 0
}

We break out the implementation of ◊code{nats} into ◊code{up_from}.

We can now pass around the value ◊code{nats} without freezing, but if we try to unwrap the lazy value, we’ll still infinitely recurse. We’ve merely delayed a problematic expression, not fixed the problem.

Instead of wrapping the whole problematic expression with laziness, we want to break the expression up so that it can be computed incrementally instead of all at once. This is how laziness benefits us when working with large or infinite lists.

We want to grab the first number and a lazy value representing the rest of the list. Then we can unwrap that lazy value to get the second number and a new lazy value.

◊codeblock[#:lang 'ocaml]{
let rec up_from n = n :: (fun () -> up_from (n + 1))
}
◊stderr{
Line 1, characters 25-52:
1 | let rec up_from n = n :: (fun () -> up_from (n + 1));;
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: This expression should not be a function, the expected type is 'a list
}

This code is basically what we want, but we’ll need to create our own type to represent it.

◊h2{Lazy lists}

◊codeblock[#:lang 'ocaml]{
type 'a lazylist = Nil | Cons of 'a * 'a lazylist delayed
}

Each element of the list contains its own value, and a lazy value representing the next element in the list. This allows us to process one value at a time.

Some example lazy lists:

◊codeblock{
let _ : 'a lazylist = Nil;;
let _ : int lazylist = Cons (1, fun () -> Nil);;
let _ : string lazylist = Cons ("a", fun () -> Cons ("b", fun () -> Nil));;
}

Though we created lazy lists to have infinite lists, we can have finite lazy lists as well. We want to enumerate both finite and infinite types.

◊enumerate{
  ◊item{Infinite: lazy lists}
  ◊item{Finite: lazy lists OR lists}
}

Lazy lists support both, so we always use them for the sake of uniformity.

The above examples explicitly specify finite lists. If we have a large (but still finite) list, we may want to avoid computing the whole thing up front, to make use of the benefits of laziness.

◊codeblock{
let rec int_range first last =
  if first > last then
    Nil
  else
    Cons (first, fun () -> int_range (first + 1) last)
}

Now we can dynamically represent an arbitrary range of numbers. We could write it out explicitly, but it would take up more memory because the whole thing is evaluated at once; and of course this way has a lot less typing.

◊codeblock{
let one_to_twenty = int_range 1 20
}

To view lazy lists, we can grab the first few elements as a regular list.

◊codeblock{
(* Returns a regular list of the first [n] elements of [ll]. If [n] greater than
   the length of [ll], returns [ll] as a regular list. *)
let rec take n ll =
  if n = 0 then
    []
  else (
    match ll with
    | Nil -> []
    | Cons (x, xs) -> x :: take (n - 1) (force xs)
  )
}

◊stdin{
take 100 @@ int_range 1 20
}

◊h2{Infinite lists}

The simplest infinite lists are just cycles.

◊codeblock{
let rec rocks name =
  Cons (name ^ " rocks!", fun () -> rocks name) in
take 3 @@ rocks "Property-based testing"
}

It doesn’t have to be a function:

◊codeblock{
let rec xs = Cons (1, fun () -> Cons (2, fun () -> xs)) in
take 5 xs
}

◊h3{Enumerating the natural numbers}

We’ve already seen the key idea, now we need to translate it to use ◊code{lazylist}.

◊codeblock{
let rec up_from n = Cons (n, fun () -> up_from (n + 1))

let nats : int lazylist = up_from 0
}
◊stdin{
take 10 nats
}

◊h2{OCaml built-in Lazy}

OCaml has a ◊hyperlink["https://v2.ocaml.org/api/Lazy.html"]{built-in lazy library}, which also does "memoization". It remembers the result, so the next time you force the lazy value it quickly returns the stored result. It not only avoids doing work it doesn’t have to, it also avoids redoing work it has already done.

OCaml also has built-in library for delayed lists, ◊hyperlink["https://v2.ocaml.org/api/Seq.html"]{Seq}. I will not use it in this article series because we will encounter an interesting problem from using our own lazy lists.

◊h2{Sources}

I learned how lazy lists worked from the ◊hyperlink["https://cs3110.github.io/textbook/chapters/ds/sequence.html"]{Cornell CS 3110 textbook}, and my explanation of enumerating naturals ended up being essentially the same as the CS 3110 one.

◊h2{Footnotes}

◊def-footnote[1]{
◊url{http://jmct.cc/pearlcheck.pdf}
SnailCheck would not be possible without PearlCheck. You can think of SnailCheck as a port of PearlCheck to OCaml.

If you are more interested in Haskell than OCaml, you may want to read the PearlCheck paper instead of this series. You should also check out PearlCheck anyways, as it is a great paper and much of its material probably won’t be covered in this series.
}

◊def-footnote[2]{
In fact there is a representation of the natural numbers based on this fact, called the Peano numbers.

◊codeblock{
type peano = Z | S of peano
}

Z = "zero", S = "successor".

◊enumerate{
◊item{Zero: Z}
◊item{One: S (Z)}
◊item{Two: S (S (Z))}
}
}

◊def-footnote[3]{
Ignoring slight syntactic differences, this definition for a list of the natural numbers would do exactly what we want in Haskell, which is lazy by default.

◊codeblock[#:lang 'haskell]{
let nats n = n : nats (n + 1) in
let xs = nats 0 in
take 10 xs
}
◊stdout{
[0,1,2,3,4,5,6,7,8,9]
}
}
