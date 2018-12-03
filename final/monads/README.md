# Monads

## TODO

The file `monads.ml` contains the following:

- The `Monad` signature

```ocaml
module type Monad = sig

  type 'a t

  val return: 'a -> 'a t

  (* Sequencing (also goes by infix operator [>>=])*)
  val bind: 'a t -> ('a -> 'b t) -> 'b t

end
```

- The `MonadExt` signature, which extends `Monad` with two
  useful additional functions:

```ocaml
module type MonadExt = sig

  include Monad

  (* Transforming (also goes by infix operator [>>|])*)
  (* Also goes by just plain [map] *)
  val fmap: 'a t -> ('a -> 'b) -> 'b t

  (* Collapsing two levels of monad structure into one *)
  val join: 'a t t -> 'a t

end
```

- The `MakeMonadExt` functor, which explores how `MonadExt` functions
  `fmap` and `join` can be implemented with primitive `Monad` functions
  `bind` and `return`:

```ocaml
module MakeMonadExt (M: Monad) : MonadExt = struct

  include M
  
  (* Implement [fmap] with nothing but [M.bind] and [M.return] *)
  let fmap m f = failwith "Unimplemented"

  (* Implement [join] with nothing but [M.bind] and [M.return] *)
  let join mm = failwith "Unimplemented"

end
```

- The `MonadSyntax` functor, which defines syntactic sugar for a given `MonadExt` module:

```ocaml
module MonadSyntax (M: MonadExt) = struct
  let (>>=) = M.bind
  let (>>|) = M.fmap
end
```

- And finally, several familiar `Monad` modules: `Result`, `Option`, `Loggable`, and `List`
  for you to implement.

## Examples

The file `examples.ml` contains some examples of pipelining data
using `Monad.bind` and `MonadExt.fmap`
