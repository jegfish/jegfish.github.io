let rec append xs ys =
  match xs, ys with
  | Nil, ys -> ys
  | Cons (x, xs), ys ->
     Cons (x, fun () -> append (force xs) ys)
