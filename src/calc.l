%{
  #include <stdio.h>

  #include "calc-bison.h"  // to get the token types from Bison
%}

%%

[ \t]  ;
[0-9]+   { yylval.ival = atoi(yytext); return INT; }
"("        { return LBRACKET; }
")"        { return RBRACKET; }
"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return MUL; }
"/"        { return DIV; }
[\n]       { return EOL; }

%%
