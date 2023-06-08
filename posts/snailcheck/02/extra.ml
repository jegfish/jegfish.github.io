let rec append xs ys =
  match xs, ys with
  | Nil, ys -> ys
  | Cons (x, xs), ys ->
     Cons (x, fun () -> append (force xs) ys)

type 'a tree = Leaf | Branch of 'a * 'a tree * 'a tree

let leaf = Leaf;;
let branch (v, l, r) = Branch (v, l, r)

let rec tree_a typ =
  cons0 leaf
  @| cons3 branch typ (tree_a typ) (tree_a typ)

let rec elegant_pair xlist ylist =
  match xlist, ylist with
  | Cons (x, xrest), Cons (y, yrest) ->
     (* x paired with every y, then repeat with xrest. *)
     (fun () -> pair_with x ylist)
     @|| (fun () -> elegant_pair (force xrest) ylist)
  | Nil, _ -> Nil
  | _, Nil -> Nil
