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
  
  (* Implement [fmap] with nothing but [M.bind] and [M.return] *)
  let fmap m f = failwith "Unimplemented"

  (* Implement [join] with nothing but [M.bind] and [M.return] *)
  let join mm = failwith "Unimplemented"

end

(* Functor for monad infix operator definitions *)
module MonadSyntax (M: MonadExt) = struct
  let (>>=) = M.bind
  let (>>|) = M.fmap
end

(* Generic error type *)
module type Error = sig
  type t
end

module Result (E: Error) = struct
  type 'a t =
  | Ok of 'a
  | Err of E.t

  let return v = failwith "Unimplemented"
  let bind res f = failwith "Unimplemented" 
  let fmap res f = failwith "Unimplemented" 
  let join res = failwith "Unimplemented"
end

module Option = struct
  type 'a t =
  | None
  | Some of 'a

  let return v = failwith "Unimplemented"
  let bind opt f = failwith "Unimplemented"
  let fmap opt f = failwith "Unimplemented"
  let join opt = failwith "Unimplemented"
end

module Loggable = struct
  type 'a t = (string * 'a)

  let return v = failwith "Unimplemented"
  let bind logged f = failwith "Unimplemented"
  let fmap logged f = failwith "Unimplemented"
  let join logged = failwith "Unimplemented"
end

module List = struct
   type 'a t = 'a list

  let return v = failwith "Unimplemented"

  (* HINT: see List.flatten in standard library *)
  let bind l f = failwith "Unimplemented"

  let fmap l f = failwith "Unimplemented"

  let join l = failwith "Unimplemented"
end
