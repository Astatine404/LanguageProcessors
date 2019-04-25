%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#include "calc.tab.h"

%}

%%

[ \t]+	; // ignore all whitespace
[0-9]+		{yylval.ival = atoi(yytext); return IINT;}
\n		{return NEWLINE;}
"display" {return DISP;}
"let" {return LET;}
"if" {return IF; }
"else" {return ELSE; }
"then" {return THEN; }
"=" 	{return ASSG;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return MULTIPLY;}
"@"		{return EXP;}	
"%"		{return MOD;}
"/"		{return DIVIDE;}
"("		{return LEFT;}
")"		{return RIGHT;}
"<"		{return LESS;}
">"		{return GREATER;}
"=="	{return EQUAL;}
"!="	{return NOTEQUAL;}
"exit"		{return QUIT;}
"quit"		{return QUIT;}
[a-zA-Z][a-zA-Z0-9]* {strcpy(yylval.cval, yytext); return ID;}
.		{yyerror("Mystery str: %s", yytext);}

%%