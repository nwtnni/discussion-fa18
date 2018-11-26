{
  open Parser
}

rule token = parse
    [' ' '\t']                                    { token lexbuf }
  | ['\n'    ]                                    { EOF }
  | "lambda" | "λ" | "\\"                         { LAMBDA }
  | '('                                           { LPAREN }
  | ')'                                           { RPAREN }
  | '.'                                           { DOT }
  | ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '_']* as id { ID id }
  | eof                                           { EOF }
