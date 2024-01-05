#lang pollen
◊title{SnailCheck: Generating values by enumeration}

2023-06-08

◊bloglink["snailcheck-lazy"]{Previous post in this series}.

In the previous post we saw the enumeration of the natural numbers. Now we will
learn to enumerate more complex types.

◊h2{Enumerating booleans}

Enumerating booleans is simpler than the naturals, but it's worth seeing. We'll
make a convenience function for converting a regular list to a lazy list; it
will also be useful for testing and for enumerating other types with few values.

◊codeblock[#:lang 'ocaml]{
  let rec of_list xs =
    match xs with
    | [] -> Nil
    | x::xs -> Cons (x, fun () -> of_list xs)
}

◊codeblock[#:lang 'ocaml]{
  let bool : bool lazylist = of_list [true; false]
}

◊codeblock[#:lang 'ocaml]{
  take 2 bool
}

◊stdout{
: - : bool list = [true; false]
}

◊note{
Note: We are doing some punning here to allow conciseness.◊footnote[1] When used
in types "bool" will still refer to the the standard boolean type. But when used
in expressions "bool" means this particular lazy list.
}

◊h2{Enumerating integers}
◊h3{Problem}
Listing the integers is non-obvious because unlike the naturals there is no
"starting point". In math you can discuss the range ◊code{(-\infty, \infty)}, but
in OCaml we can't start at negative infinity.

OCaml's ◊code{int} type does technically have a starting point, ◊code{min_int},
which seems to be ◊math{-2^{62}}. Maybe we could do ◊code{let int = up_from
min_int}? There are a few problems with this:

◊ol{
◊li{For a while all you'll be seeing is negative numbers with a large magnitude.
It's easier to work with smaller numbers, and we also want to check zero and
positive numbers. It's also nice to try the simplest cases first, to hopefully
report a failure that is easy to understand.}

◊li{"a while" is probably longer than a human lifespan. Rough calculations with
a 5 millisecond time per check gave me an 11-digit number of ◊em{years}. 5 ms is
perhaps a long time for executing a function, but even at the nanosecond scale
you can't exhaust the integers. A quick Internet search says even just
incrementing a counter from 0 to ◊math{2^{64}} (not even checking properties) would
take around 100 years.}

◊li{Sometimes we may want to use a special integer type that can represent
arbitrarily-large integers. Then there will be no such thing as ◊code{min_int}.}
}

◊h3{Solution}

There is a way to arrange the integers that gives them a starting point and
gives the simplest cases first: ◊math{0, -1, 1, -2, 2, -3, 3, \ldots}.
◊footnote[2]

We could express this as a single generator function like we did with the naturals:

◊codeblock[#:lang 'ocaml]{
  let int : int lazylist =
    let rec ints' n =
      Cons (-n, fun () ->
               Cons (n, fun () -> ints' (n + 1))) in
    Cons (0, fun () -> ints' 1)
  ;;

  take 9 int
}

◊stdout{
: - : int list = [0; -1; 1; -2; 2; -3; 3; -4; 4]
}

However, we will express it in a way that I feel is more elegant. It will be
useful to examine this technique with the integers first, because we will need
it for more complex types later.

◊mathblock{\mathbb{Z} = \mathbb{N} \cup \{-1, -2, -3, \ldots\}\}

We can break the integers into pieces. If we combine the natural numbers and the
negative integers, we get the set of all integers.

The common way to combine lists is appending.

◊codeblock[#:lang 'ocaml]{
  let rec append xs ys =
    match xs, ys with
    | Nil, ys -> ys
    | Cons (x, xs), ys ->
       Cons (x, fun () -> append (force xs) ys)
}

Let's confirm that our lazy list =append= works:

◊stdin[#:lang 'ocaml]{
  take 6 @@ append (of_list [1;2;3]) (of_list [4;5;6])
}

◊stdout{
: - : int list = [1; 2; 3; 4; 5; 6]
}

Now let's try making the integers:

◊codeblock[#:lang 'ocaml]{
  let rec down_from n = Cons (n, fun () -> down_from (n - 1))
}

◊codeblock[#:lang 'ocaml]{
  <<chp02-extra>>
  let int = append nats (down_from (-1)) in
  take 9 int
}

◊stdin[#:lang 'ocaml]{
: - : int list = [0; 1; 2; 3; 4; 5; 6; 7; 8]
}

Oh no, we aren't seeing any negatives! There are infinitely many naturals, so
we'll never get to the negatives.

If we make a slight change to our ◊code{append} function, we can get the behavior we want.

◊codeblock[#:lang 'ocaml]{
  let rec interleave xs ys =
    match xs, ys with
    | Nil, ys -> ys
    | Cons (x, xs), ys ->
       Cons (x, fun () -> interleave ys (force xs))
           (* Difference: append (force xs) ys *)

  (* Operator form. *)
  let ( @| ) = interleave

  let int : int lazylist = nats @| (down_from (-1))
}

In the recursive call we now swap the position of ◊code{xs} and ◊code{ys}, so we will get
the behavior of alternating which list we grab from.

◊codeblock[#:lang 'ocaml]{
  <<chp02-extra>>
  take 9 int
}

◊stdin[#:lang 'ocaml]{
: - : int list = [0; -1; 1; -2; 2; -3; 3; -4; 4]
}

◊h2{Enumerating tuples}

Not all functions deal with simple scalar types. We also want to enumerate
structured types, starting with tuples.

First let's add the ability to map over lazy lists.

◊codeblock[#:lang 'ocaml]{
  let rec map f xs =
    match xs with
    | Nil -> Nil
    | Cons (x, xs) ->
       Cons (f x,
             fun () -> map f (force xs))
}

◊codeblock[#:lang 'ocaml]{
  let square x = x * x in
  let perfect_squares = map square nats in
  take 10 perfect_squares
}

◊stdout{
: - : int list = [0; 1; 4; 9; 16; 25; 36; 49; 64; 81]
}

◊codeblock[#:lang 'ocaml]{
  let rec pair_with x ll =
    map (fun y -> (x, y)) ll

  let rec pair xlist ylist =
    match xlist, ylist with
    | Cons (x, xrest), Cons (y, yrest) ->
       (* x paired with every y, interleaved with: pair xs ylist *)
       Cons ((x,y),
             fun () -> pair_with x (force yrest) @| pair (force xrest) ylist)
    | Nil, _ -> Nil
    | _, Nil -> Nil
}

The key idea is to pair up the first ◊code{x} with every ◊code{y} in ◊code{ylist}, then combine
that with the pairing of ◊code{xrest} with ◊code{ylist}.

Note that ◊code{pair_with x (force yrest)} actually uses ◊code{yrest}, so it
skips the first ◊code{y}. This is fine though because we have the pairing of
◊code{x} and the first ◊code{y} with ◊code{Cons ((x,y), ...)}.

The ◊code{Cons ((x,y), ...)} piece is a bit inelegant, but necessary with the
current implementation of ◊code{interleave}. Later we will solve this issue and
clean up ◊code{pair}.

◊stdin[#:lang 'ocaml]{
  take 10 @@ pair_with 42 (of_list [1;2;3;4;5])
}

◊stdout{
: - : (int * int) list = [(42, 1); (42, 2); (42, 3); (42, 4); (42, 5)]
}

◊stdin[#:lang 'ocaml]{
  take 10 @@ pair bool bool
}

◊stdout{
: - : (bool * bool) list =
: [(true, true); (true, false); (false, true); (false, false)]
}

◊stdin[#:lang 'ocaml]{
  take 10 @@ pair int int
}

◊stdout{
: - : (int * int) list =
: [(0, 0); (0, -1); (-1, 0); (0, 1); (-1, -1); (0, -2); (1, 0); (0, 2);
:  (-1, 1); (0, -3)]
}

We can of course mix different types.

◊stdin[#:lang 'ocaml]{
  take 10 @@ pair int bool
}

◊stdout{
: - : (int * bool) list =
: [(0, true); (0, false); (-1, true); (-1, false); (1, true); (1, false);
:  (-2, true); (-2, false); (2, true); (2, false)]
}

◊h3{Triples and n-tuples}

Two is a magic number. We can mimic n-tuples using nested pairs.

For example: ◊code{(1, (2, 3))}.

◊codeblock[#:lang 'ocaml]{
  let triple xs ys zs =
    let triple_of_nest (a, (b, c)) = (a, b, c) in
    map triple_of_nest (pair xs (pair ys zs))
}

◊stdin[#:lang 'ocaml]{
  take 5 @@ triple int (pair bool int) int
}

◊stdout{
: - : (int * (bool * int) * int) list =
: [(0, (true, 0), 0); (0, (true, 0), -1); (-1, (true, 0), 0);
:  (0, (true, -1), 0); (-1, (true, 0), -1)]
}

◊h2{Enumerating algebraic data types (ADT)}

Here's an interesting but still simple ADT: a binary tree.

◊codeblock[#:lang 'ocaml]{
  type 'a tree = Leaf | Branch of 'a * 'a tree * 'a tree
}

The enumeration of ADT constructors can be built directly off of tuple
enumeration. We enumerate n-tuples, where n is the number of arguments to the
constructor, then construct values.

◊codeblock[#:lang 'ocaml]{
  let cons0 cons = of_list [cons]
  let cons1 cons a = map cons a
  let cons2 cons a b = map cons (pair a b)
  let cons3 cons a b c = map cons (triple a b c)
}

In OCaml constructors cannot be passed around like functions, so we will define
function wrappers to pass to ◊code{consN}.

◊codeblock[#:lang 'ocaml]{
  let leaf = Leaf;;
  let branch (v, l, r) = Branch (v, l, r)
}

The ◊code{branch} function converts an appropriate tuple into a tree branch.

◊codeblock[#:lang 'ocaml]{
  let rec tree_a typ =
    cons0 leaf
    @| cons3 branch typ (tree_a typ) (tree_a typ)
}

The type ◊code{tree} has two constructors. We start with the simple one,
◊code{Leaf}. It is a nullary constructor (no arguments), so we do ◊code{cons0 leaf}
to enumerate it.

The other constructor is ◊code{Branch}, which has 3 parts, so we use ◊code{cons3}. The
first part is of type ◊code{'a}, the type the tree is parameterized by. We have the
◊code{typ} argument to take in the enumeration of ◊code{'a}, so we do ◊code{cons3 branch typ}.
The next two parts are both of type tree, so we have ◊code{cons3 branch typ (tree_a
typ) (tree_a typ)}.

Writing enumerations of algebraic data types is a simple, mechanical process.◊footnote[3]

Let's check out the result.

◊stdin[#:lang 'ocaml]{
  take 5 @@ (tree_a int)
}

◊stdout{
: Stack overflow during evaluation (looping recursion?).
}

Turns out I lied a bit. What went wrong?

The top level function in the body of ◊code{tree_a} is ◊code{@|} (a.k.a.
◊code{interleave}). OCaml uses
◊hyperlink["https://en.wikipedia.org/wiki/Strict_programming_language"]{strict
evaluation}, so we evaluate the arguments before evaluating the function. The
left argument ◊code{cons0 leaf} is fine. The problem arises in the right argument,
which has recursive calls to ◊code{tree_a}.

With recursion it is usually important to have:

◊ol{
    ◊li{A base case.}
    ◊li{Recursive calls make the input "smaller", approaching the base case.}
    ◊li{Conditional that checks whether to perform the base or recursive case.}
}

We have a base case of ◊code{cons0 leaf}◊code{, but we don't have a conditional.
}Conditionals are special in that only some of their arguments/branches are
evaluated each time, while functions have ◊em{all} of their arguments evaluated
every time.

The problem is that we are always evaluating the recursive calls in ◊code{cons3
branch typ (tree_a typ) (tree_a typ)}, so we recurse infinitely.

◊h3{Solution}

Imagine you are ◊code{tree_a}=. This is roughly the behavior we want:

◊ul{
◊li{For the first tree, I'll give you a ◊code{Leaf}=.}
◊li{For the second tree, I'll give you a ◊code{Branch}=.
  ◊ul{
  ◊li{To make a branch, I need to make a ◊code{'a}. That's easy, I use ◊code{typ}.}
  ◊li{I also need to make two of ◊code{'a tree}. To do that, I make two nested calls of ◊code{tree_a typ}.
    ◊ul{
        ◊li{I'm the first nested call. I'll give you the first tree in the enumeration. That's ◊code{Leaf}.}
    ◊li{I'm the second nested call. I'll give you the first tree in the enumeration. That's ◊code{Leaf}.}
    }
  }
  ◊li{I've completed giving ◊code{Branch Leaf Leaf}.}
  }
}
◊li{For the third tree, ...}
}

If we grab the base case (◊code{Leaf}) first, we can manage to build recursive cases (◊code{Branch}).

We can't do this with strict evaluation, so we need to add a bit of laziness. We
will write ◊code{lazy_interleave} so that its arguments are both lazy (◊code{delayed}), so
we won't get stuck on recursive calls encountered while evaluating the arguments
to ◊code{lazy_interleave}.◊footnote[4]

◊codeblock[#:lang 'ocaml]{
  let rec lazy_interleave (xs : 'a lazylist delayed) (ys: 'a lazylist delayed) =
    let xs = force xs in
    match xs with
    | Nil -> force ys
    | Cons (x, xs) ->
       Cons (x, fun () -> lazy_interleave ys xs)

  let ( @|| ) = lazy_interleave
}

Now we can enumerate trees.

◊codeblock[#:lang 'ocaml]{
  let rec tree typ =
    let a = fun () -> cons0 leaf in
    let b = fun () -> cons3 branch typ (tree typ) (tree typ) in
    a @|| b
  in

  take 3 @@ tree int
}

◊stdout{
: - : int tree list =
: [Leaf; Branch (0, Leaf, Leaf); Branch (0, Leaf, Branch (0, Leaf, Leaf))]
}

◊h3{Order matters}

Remember when I said we needed to grab the base case(s) before the recursive
case(s)? With the current code, that's true.

◊codeblock[#:lang 'ocaml]{
  let rec tree_bad typ =
    let a = fun () -> cons3 branch typ (tree_bad typ) (tree_bad typ) in
    let b = fun () -> cons0 leaf in
    a @|| b
  in
  take 5 @@ tree_bad int
}

◊stdin{
: Stack overflow during evaluation (looping recursion?).
}

This is problematic. It's annoying to remember and results in an unhelpful error message.◊footnote[5]

It's not simply a matter of laziness.
◊hyperlink["http://jmct.cc/pearlcheck.pdf"]{PearlCheck}, which is written in the lazy
language Haskell, also faces this problem---though it is solved later in the
paper.◊footnote[6]

It is possible to solve this problem in SnailCheck if we switch from simple
enumerated lists to ◊code{tiers}, like PearlCheck uses. That may be covered in a
later post, but for now you can check out the PearlCheck paper.

◊h2{Enumerating lists}

Lists in OCaml are essentially an algebraic data type, so we can enumerate them now.

◊codeblock[#:lang 'ocaml]{
  let rec list typ =
    let cons (x, xs) = x :: xs in
    (fun () -> cons0 [])
    @|| (fun () -> cons2 cons typ (list typ))
}

◊stdin[#:lang 'ocaml]{
  take 5 @@ list bool
}

◊stdin{
: - : bool list list = [[]; [true]; [true; true]; [false]; [true; true; true]]
}

◊h2{Elegant ◊code{pair}}

As promised, here is the elegant version of ◊code{pair}. This eliminates the
◊code{Cons ((x,y), ...)} and expresses it only with ◊code{pair_with} and a
recursive call.

◊codeblock[#:lang 'ocaml]{
  let rec elegant_pair xlist ylist =
    match xlist, ylist with
    | Cons (x, xrest), Cons (y, yrest) ->
       (* x paired with every y, then repeat with xrest. *)
       (fun () -> pair_with x ylist)
       @|| (fun () -> elegant_pair (force xrest) ylist)
    | Nil, _ -> Nil
    | _, Nil -> Nil
}

◊stdin[#:lang 'ocaml]{
  take 10 @@ elegant_pair int int
}

◊stdout{
: - : (int * int) list =
: [(0, 0); (-1, 0); (0, -1); (1, 0); (0, 1); (-1, -1); (0, -2); (-2, 0);
:  (0, 2); (-1, 1)]
}

◊stdin[#:lang 'ocaml]{
  take 10 @@ pair int int
}

◊stdout{
: - : (int * int) list =
: [(0, 0); (0, -1); (-1, 0); (0, 1); (-1, -1); (0, -2); (1, 0); (0, 2);
:  (-1, 1); (0, -3)]
}

The order is a bit different, but it's still correct.

◊h2{See also}

This may be the last SnailCheck post, so I'll leave you with some pointers if you're interested in learning more.

◊ul{
  ◊li{As mentioned previously this series is essentially a port of the
    ◊hyperlink["http://jmct.cc/pearlcheck.pdf"]{PearlCheck} paper to OCaml.
    ◊ul{
    ◊li{PearlCheck is a "tutorial reconstruction" of LeanCheck: ◊url{https://hackage.haskell.org/package/leancheck}}
    ◊li{So far the SnailCheck posts have covered the parts I struggled to translate to OCaml, but there is a lot more covered by PearlCheck that's worth reading.}
    }
  }

  ◊li{According to PearlCheck, SmallCheck was the first enumerative PBT tool for Haskell.
    ◊ul{
    ◊li{Paper: ◊url{https://www.cs.york.ac.uk/fp/smallcheck/smallcheck.pdf}}
    ◊li{An implementation: ◊url{https://github.com/Bodigrim/smallcheck}}
    }
  }

◊li{Feat: functional enumeration of algebraic types
  ◊ul{
  ◊li{Paper: ◊url{https://dl.acm.org/doi/abs/10.1145/2364506.2364515}
    ◊ul{
    ◊li{"Feat provides efficient 'random access' to enumerated values. The
    primary application is property-based testing, where it is used to define
    both random sampling (for example QuickCheck generators) and exhaustive
    enumeration (in the style of SmallCheck)"}
    }
  }
  ◊li{An OCaml library inspired by Feat: ◊url{https://gitlab.inria.fr/fpottier/feat/}}
  }
}

◊li{There are a variety of testing frameworks for OCaml. Several of them support some form of property-based testing.
  ◊ul{
  ◊li{◊url{https://ocamlverse.net/content/testing.html}}
  }
}
}

◊h2{Footnotes}

◊def-footnote[1]{
We're also doing punning because [[https://c-cube.github.io/qcheck/][QCheck]]
does it that way, and we want to be compatible with QCheck.
}

◊def-footnote[2]{
Apparently this is called the
◊hyperlink["https://en.wikipedia.org/wiki/Well-order#Integers"]{well-ordering of the
integers}. I'd seen this ordering before, and I recently learned the
Well-Ordering Principle, but hadn't made the connection until looking it up just
now.
}

◊def-footnote[3]{
That means we can automate the generation of enumerations of algebraic data
types! I may write a post about this in the future.
}

◊def-footnote[4]{
There's not much use in keeping the non-lazy version of ◊code{interleave} around; I
consider it broken. I only gave ◊code{lazy_interleave} a new name as a shortcut to
appease the literate programming setup I'm using.
}

◊def-footnote[5]{
If you know of a way to detect the problem and provide a helpful error message, let me know!
◊br[]
Maybe stack overflow is a catchable exception, and could print an error message
that suggests that the problem could be the order of the ADT cases. However, I
say "suggest" because there could be other reasons for stack overflow; this
merely detects a symptom rather than the problem.

I'm thinking proper detection would require some sort of static analysis. Maybe
it could be done with a ◊hyperlink["https://ocaml.org/docs/metaprogramming"]{PPX}.
}

◊def-footnote[6]{
PearlCheck doesn't mention this problem, but if you copy the code up through
"Mark II: Algebraic Datatypes" you can reproduce the problem on this example:

◊codeblock[#:lang 'haskell]{
  instance Listable Expr where
    -- Different from the one in the paper.
    -- Recursive case comes first / on the left.
    list = cons2 Add \/ cons1 Val

  -- Gets stuck here on infinite recursion.
  take 5 (list :: [Expr])
}

The error goes away at "Mark IV: Fair Enumeration" because of the swap from ◊code{list} to ◊code{tiers}.
}
