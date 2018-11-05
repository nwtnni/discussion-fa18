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
prog: stms EOF { $1 }

stms:
  | stm stms { Seq($1, $2) }
  | stm      { $1 }

stm:
  | VAR ASSIGN exp    { Assign($1, $3) }
  | PRINT exp         { Print($2) }
  | LBRACK stms RBRACK { Scope($2) }

exp:
  | prim ADD exp { Add($1, $3) }
  | prim         { $1 }

prim:
  | INT               { Int($1) }
  | VAR               { Var($1) }
  | LPAREN exp RPAREN { $2 }
