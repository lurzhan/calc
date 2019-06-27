%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror (const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:

%union {
  int ival;
  char *sval;
}

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:

%token <ival> INT
%token <sval> STRING

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
expr:
  expr INT      {
      printf ("bison found an int: %d\n", ($2));
    }
  | expr STRING {
      printf ("bison found a string: %s\n", ($2)); free($2);
    }
  | INT            {
      printf ("bison found an int: %d\n", ($1));
    }
  | STRING         {
      printf ("bison found a string: %s\n", ($1)); free($1);
    }
  ;
%%

int main(int argc, char** argv) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("bin/expr.txt", "r");
  // Make sure it is valid:
  if (!myfile) {
    printf ("I can't open expr.txt file!\n");
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // Parse through the input:
  yyparse();

}

void yyerror(const char *s) {
  printf ("EEK, parse error!  Message: %s\n", s);
  // might as well halt now:
  exit(-1);
}
