%{
  open Ast
%}

%token <int> INT
%token <string> VAR
%token LPAREN RPAREN LBRACK RBRACK
%token ASSIGN ADD
%token PRINT
%token EOF

%type <Ast.stm> prog

%start prog

%%
prog: 
  | stm EOF  { $1 }
  | stm prog { Seq($1, $2) }

stm:
  | VAR ASSIGN exp    { Assign($1, $3) }
  | PRINT exp         { Print($2) }
  | LBRACK stm RBRACK { Scope($2) }

exp:
  | prim ADD exp { Add($1, $3) }
  | prim         { $1 }

prim:
  | INT               { Int($1) }
  | VAR               { Var($1) }
  | LPAREN exp RPAREN { $2 }
