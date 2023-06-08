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
