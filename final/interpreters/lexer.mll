{
  open Parser
}

let var = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' ''' '_']*
let int = ['0'-'9'] ['0'-'9']*
 
rule token = parse
| '\n'           { Lexing.new_line lexbuf; token lexbuf }
| int as n       { INT(int_of_string n) }
| "true"         { TRUE }
| "false"        { FALSE }
| ":="           { ASSIGN }
| "="            { EQ }
| "!="           { NE }
| "+"            { ADD }
| "-"            { SUB }
| ";"            { SEMICOLON }
| "("            { LPAREN }
| ")"            { RPAREN }
| "if"           { IF }
| "then"         { THEN }
| "else"         { ELSE }
| "print"        { PRINT }
| "skip"         { SKIP }
| "while"        { WHILE }
| "do"           { DO }
| "done"         { DONE }
| "input"        { INPUT }
| var as v       { VAR(v) }
| _              { token lexbuf }
| eof            { EOF }
