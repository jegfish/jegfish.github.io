let rec of_list xs =
  match xs with
  | [] -> Nil
  | x::xs -> Cons (x, fun () -> of_list xs)

let bool : bool lazylist = of_list [true; false]

let rec down_from n = Cons (n, fun () -> down_from (n - 1))
