open Monads_sol

module OptionSyntax = MonadSyntax (Option)

let inspect_int i =
  Format.printf "%i\n" i; i

let inspect_string s =
  Format.printf "\"%s\"\n" s; s

let inspect_opt f (opt: 'a Option.t) = match opt with
| None -> Format.printf "None\n"; Option.None
| Some v -> Format.printf "Some "; Option.Some (f v)

let divide n ~divisor : int Option.t =
  if divisor = 0 then Option.None else Option.Some (n / divisor)

let () = let open OptionSyntax in
  100 |>  inspect_int

      (* [int -> int option], input is [int], use regular pipeline to get [int Option.t] *)
      |>  divide ~divisor:100         
      |>  inspect_opt inspect_int

      (* [int -> int], input is [int Option.t], use [map] to get [int Option.t] *)
      >>| (+) 5
      |>  inspect_opt inspect_int

      (* [int -> string], input is [int Option.t], use [map] to get [string Option.t] *)
      >>| string_of_int               
      |>  inspect_opt inspect_string

      (* [string -> int], input is [string Option.t], use [map] to get [int Option.t] *)
      >>| int_of_string               
      |>  inspect_opt inspect_int

      (* [int -> int option], input is [int Option.t], use [bind] to get [int Option.t] *)
      >>= divide ~divisor:0           
      |> inspect_opt inspect_int

      (* Ignore final result *)
      |>  ignore

module LogSyntax = MonadSyntax (Loggable)

let inspect_log f (log, v) =
  Format.printf "Log: \"%s\", value: " log;
  (log, f v)

let add n m : int Loggable.t =
  let log = Printf.sprintf "[%i + %i = %i]" n m (n + m) in
  (log, n + m)

let concat s1 s2 : string Loggable.t =
  let log = Printf.sprintf "[%s ^ %s = %s]" s1 s2 (s1 ^ s2) in
  (log, s1 ^ s2)

(* Try to annotate the types like we did above! *)
let () = let open LogSyntax in
  100 |>  inspect_int
      |>  add 1
      |>  inspect_log inspect_int
      >>= add 2
      |>  inspect_log inspect_int
      >>| string_of_int
      |>  inspect_log inspect_string
      >>= concat "hello, "
      |>  inspect_log inspect_string
      |>  ignore
