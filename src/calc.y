%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror (const char *s);
%}

%union {
  int ival;
}


%token <ival> INT
%token LBRACKET RBRACKET EOL
%token PLUS MINUS MUL DIV
%left PLUS MINUS
%left MUL DIV

%type <ival> expr add_expr mul_expr primary

%%

input:
     | input line
;

line: EOL
    | expr EOL { printf("=%d\n", $1); }
;

expr: add_expr
;

add_expr: mul_expr
	| add_expr PLUS mul_expr { $$ = (int)$1 + (int)$3; }
	| add_expr MINUS mul_expr { $$ = (int)$1 - (int)$3; }
;

mul_expr: primary
	| mul_expr MUL primary { $$ = $1 * $3; }
	| mul_expr DIV primary { $$ = $1 / $3; }
;

primary: INT { $$ = $1; }
       | LBRACKET expr RBRACKET { $$ = $2; }
;

%%

/* Entry point */
int main(int argc, char **argv)
{	
	yyin = stdin;
	yyparse();
}

void yyerror(const char *s) {
  printf ("EEK, parse error!  Message: %s\n", s);
  // might as well halt now:
  exit(-1);
}

