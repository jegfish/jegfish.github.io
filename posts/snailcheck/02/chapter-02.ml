let rec of_list xs =
  match xs with
  | [] -> Nil
  | x::xs -> Cons (x, fun () -> of_list xs)

let bool : bool lazylist = of_list [true; false]

let rec down_from n = Cons (n, fun () -> down_from (n - 1))

let rec interleave xs ys =
  match xs, ys with
  | Nil, ys -> ys
  | Cons (x, xs), ys ->
     Cons (x, fun () -> interleave ys (force xs))
         (* Difference: append (force xs) ys *)

(* Operator form. *)
let ( @| ) = interleave

let int : int lazylist = nats @| (down_from (-1))

let rec map f xs =
  match xs with
  | Nil -> Nil
  | Cons (x, xs) ->
     Cons (f x,
           fun () -> map f (force xs))

let rec pair_with x ll =
  match ll with
  | Nil -> Nil
  | Cons (y, ys) ->
     Cons ((x,y), fun () -> pair_with x (force ys))

let rec pair xlist ylist =
  match xlist, ylist with
  | Cons (x, xrest), Cons (y, yrest) ->
     (* x paired with every y, interleaved with: pair xs ylist *)
     Cons ((x,y),
           fun () -> pair_with x (force yrest) @| pair (force xrest) ylist)
  | Nil, _ -> Nil
  | _, Nil -> Nil
