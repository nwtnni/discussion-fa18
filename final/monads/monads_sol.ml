module type Monad = sig

  type 'a t

  val return: 'a -> 'a t

  (* Sequencing (also goes by infix operator [>>=])*)
  val bind: 'a t -> ('a -> 'b t) -> 'b t

end

module type MonadExt = sig

  include Monad

  (* Transforming (also goes by infix operator [>>|])*)
  (* Also goes by just plain [map] *)
  val fmap: 'a t -> ('a -> 'b) -> 'b t

  (* Collapsing two levels of monad structure into one *)
  val join: 'a t t -> 'a t

end

module MakeMonadExt (M: Monad) : MonadExt = struct

  include M
  
  let fmap m f =
    M.bind m (fun v -> M.return (f v))

  let join mm =
    M.bind mm (fun m -> m)

end

(* Functor for monad infix operator definitions *)
module MonadSyntax (M: MonadExt) = struct
  let (>>=) = M.bind
  let (>>|) = M.fmap
end

module type Error = sig
  type t
end

module Result (E: Error) = struct

  type 'a t =
  | Ok of 'a
  | Err of E.t

  let return v = Ok v

  let bind res f = match res with
  | Ok v -> f v
  | Err e -> Err e

  let fmap res f = match res with
  | Ok v -> Ok (f v)
  | Err e -> Err e

  let join res = match res with
  | Ok v -> v
  | Err e -> Err e

end

module Option = struct

  type 'a t =
  | None
  | Some of 'a

  let return v = Some v

  let bind opt f = match opt with
  | None -> None
  | Some v -> f v

  let fmap opt f = match opt with
  | None -> None
  | Some v -> Some (f v)

  let join opt = match opt with
  | None -> None
  | Some v -> v

end

module Loggable = struct

  type 'a t = (string * 'a)

  let return v = ("", v)

  let bind (log, v) f =
    let (log', v') = f v in
    (log ^ log', v')

  let fmap (log, v) f =
    (log, f v)

  let join (log, (log', v)) =
    (log ^ log', v)

end

module List = struct

  type 'a t = 'a list

  let return v = [v]

  let bind l f =
    List.flatten (List.map f l)

  let fmap l f =
    List.map f l

  let join l =
    List.flatten l

end
