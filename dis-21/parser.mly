%{
  open Ast
%}

%token <int> INT
%token LPAREN RPAREN
%token IF THEN ELSE
%token TRUE FALSE
%token PRINT
%token ADD AND OR
%token EOF

%type <Ast.stm> program

%start program

%%
program: stms EOF { $1 }

stms:
  | stm stms { Seq($1, $2) }
  | stm      { $1 }

stm:
  | IF exp THEN stm ELSE stm { If($2, $4, $6) }
  | PRINT exp                { Print($2) }

exp:
  | exp OR term  { Bin(Or, $1, $3) }
  | exp ADD term { Bin(Add, $1, $3) }
  | term         { $1 }

term:
  | term AND prim { Bin(And, $1, $3) }
  | prim          { $1 }

prim:
  | INT               { Int($1) }
  | TRUE              { True }
  | FALSE             { False }
  | LPAREN exp RPAREN { $2 }
