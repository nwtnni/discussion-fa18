module M = Map.Make (Char)

type t = {
  word: bool;
  next: t M.t;
}

let empty = {
  word = false;
  next = M.empty;
}

let to_list =
  let rec to_list' prefix node =
    let append c = prefix ^ (String.make 1 c) in
    let fold c next acc = acc @ to_list' (append c) next in
    let subtree = M.fold fold node.next [] in
    if node.word then prefix :: subtree else subtree
  in to_list' ""

let rec explode s = match String.length s with
| 0 -> []
| n -> s.[0] :: explode (String.sub s 1 (n - 1))

let plumb f =
  fun s -> f (explode s)

let insert =
  let rec insert' cs node = match cs with
  | []     -> { node with word = true }
  | c :: t -> match M.find_opt c node.next with
              | None      -> let step = insert' t empty in
                             { node with next = M.add c step node.next }
              | Some next -> let step = insert' t next in
                             { node with next = M.add c step node.next }
  in plumb insert'

let contains = 
  let rec contains' cs node = match cs with
  | []     -> node.word
  | c :: t -> match M.find_opt c node.next with
              | None      -> false (* changed from true *)
              | Some step -> contains' t step
  in plumb contains'

let remove =
  let rec remove' cs node = match cs with
  | []     -> { node with word = false } (* changed from { node with word = not node.word } *)
  | c :: t -> match M.find_opt c node.next with
              | None      -> node
              | Some next -> let step = remove' t next in
                             { node with next = M.add c step node.next }
  in plumb remove'
