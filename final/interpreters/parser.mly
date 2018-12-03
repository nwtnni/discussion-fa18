%{ 
  open Ast
%}

%token INPUT
%token <int> INT
%token <string> VAR
%token TRUE FALSE
%token ADD SUB
%token EQ NE
%token SKIP
%token ASSIGN
%token PRINT
%token SEMICOLON LPAREN RPAREN
%token IF THEN ELSE
%token WHILE DO DONE
%token EOF

%type <Ast.comm> program

%left SEMICOLON
%nonassoc ELSE
%nonassoc EQ NE
%left ADD SUB

%start program

%%

program:
  | comm EOF { $1 }

comm:
  | SKIP                        { Skip }
  | VAR ASSIGN aexp             { Assign($1, $3) }
  | PRINT aexp                  { Print($2) }
  | IF bexp THEN comm ELSE comm { If($2, $4, $6) }
  | WHILE bexp DO comm DONE     { While($2, $4) }
  | comm SEMICOLON comm         { Seq($1, $3) }

aexp:
  | INPUT              { Input }
  | INT                { Int($1) }
  | VAR                { Var($1) }
  | aexp ADD aexp      { Add($1, $3) }
  | aexp SUB aexp      { Sub($1, $3) }
  | LPAREN aexp RPAREN { $2 }

bexp:
  | TRUE         { True }
  | FALSE        { False }
  | aexp EQ aexp { Eq($1, $3) }
  | aexp NE aexp { Ne($1, $3) }
