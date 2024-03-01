%option case-insensitive
%option noyywrap
%{
#include <stdio.h>
%}

%%

and     { printf("KW_AND\n");} 
or      { printf("KW_OR\n"); }
not     { printf("KW_NOT\n"); }
equal   { printf("KW_EQUAL\n"); }
less    { printf("KW_LESS\n"); }
nil     { printf("KW_NIL\n"); }
list    { printf("KW_LIST\n"); }
append  { printf("KW_APPEND\n"); }
concat  { printf("KW_CONCAT\n"); }
set     { printf("KW_SET\n"); }
def     { printf("KW_DEF\n"); }
for     { printf("KW_FOR\n"); }
if      { printf("KW_IF\n"); }
exit    { printf("KW_EXIT\n"); }
load    { printf("KW_LOAD\n"); }
display { printf("KW_DISPLAY\n"); }
true    { printf("KW_TRUE\n"); }
false   { printf("KW_FALSE\n"); }

"+"     { printf("OP_PLUS\n"); }
"-"     { printf("OP_MINUS\n"); }
"/"     { printf("OP_DIV\n"); }
"*"     { printf("OP_MULT\n"); }
"("     { printf("OP_OP\n"); }
")"     { printf("OP_CP\n"); }
","     { printf("OP_COMMA\n"); }

";;"[^\n]*   {printf("COMMENT: %s\n", yytext); }
[[:space:]]+ /* Ignoring spaces. */
[0-9]+b[0-9]+ { printf("VALUEF: %s\n", yytext); }	
[a-zA-Z][a-zA-Z0-9]* { printf("IDENTIFIER: %s\n", yytext); }

[0-9]+      { printf("SYNTAX_ERROR %s cannot be tokenized\n", yytext); /* Syntax error for integers.*/}
[0-9]+[a-zA-Z]+ { printf("SYNTAX_ERROR %s cannot be tokenized\n", yytext); /* Syntax error for starting with integers and continues with alphabetic characters.*/ }
.		{ printf("SYNTAX_ERROR %s cannot be tokenized\n", yytext); /* Syntax error for other characters.*/}
%%

int main(int argc, char* argv[]) {
    yylex();
    return 0;
}


