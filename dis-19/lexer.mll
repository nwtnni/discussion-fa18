{
  open Parser
}

let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' '0'-'9' ''' '_']*

rule token = parse
  | '\n'        { Lexing.new_line lexbuf; token lexbuf }
  | "{"         { LBRACK }
  | "}"         { RBRACK }
  | "("         { LPAREN }
  | ")"         { RPAREN }
  | ":="        { ASSIGN }
  | "+"         { ADD }
  | "print"     { PRINT }
  | id as v     { VAR(v) }
  | digit+ as n { INT(int_of_string n) }
  | eof         { EOF }
  | _           { token lexbuf }
