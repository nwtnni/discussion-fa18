{
  open Parser
}

let digit = ['0'-'9']

rule token = parse
  | '\n'        { Lexing.new_line lexbuf; token lexbuf }
  | "("         { LPAREN }
  | ")"         { RPAREN }
  | "if"        { IF }
  | "then"      { THEN }
  | "else"      { ELSE }
  | "true"      { TRUE }
  | "false"     { FALSE }
  | "print"     { PRINT }
  | "and"       { AND }
  | "or"        { OR }
  | "+"         { ADD }
  | digit+ as n { INT(int_of_string n) }
  | eof         { EOF }
  | _           { token lexbuf }
