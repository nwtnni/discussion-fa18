let () = open_in (Sys.argv.(1))
  |> Lexing.from_channel
  |> Parser.exp Lexer.token
  |> Ast.to_string
  |> print_endline
