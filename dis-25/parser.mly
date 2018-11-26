%{
  open Ast
%}

%token <string> ID
%token LPAREN RPAREN LAMBDA DOT
%token EOF

%start exp
%type <Ast.t> exp

%%

exp:
  abs EOF             { $1 }
;

abs:
    LAMBDA ID DOT abs { Abs ($2, $4) }
  | app               { $1 }
  ;

app:
    app var { App ($1, $2) }
  | var     { $1 }
  ;

var:
    ID                { Var $1 }
  | LPAREN abs RPAREN { $2 }
  ;
