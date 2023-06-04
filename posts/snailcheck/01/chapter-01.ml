type 't delayed = unit -> 't

let a : int delayed = fun () -> 42;;
let b : int delayed = fun () -> List.fold_left (+) 0 [1;2;3];;

let force lazy_val = lazy_val ()

type 'a lazylist = Nil | Cons of 'a * 'a lazylist delayed

let _ : 'a lazylist = Nil;;
let _ : int lazylist = Cons (1, fun () -> Nil);;
let _ : string lazylist = Cons ("a", fun () -> Cons ("b", fun () -> Nil));;

let rec int_range first last =
  if first > last then
    Nil
  else
    Cons (first, fun () -> int_range (first + 1) last)

(* Returns a list of the first [n] elements of [ll]. If [n] greater than the
   length of [ll], returns [ll] as a regular list. *)
let rec take n ll =
  if n = 0 then
    []
  else (
    match ll with
    | Nil -> []
    | Cons (x, xs) -> x :: take (n - 1) (force xs)
  )

let rec up_from n = Cons (n, fun () -> up_from (n + 1))

let nats : int lazylist = up_from 0
