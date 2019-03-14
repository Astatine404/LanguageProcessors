%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#include "comp.tab.h"

%}

%%

[ \t]	{} // ignore all whitespace
[0-9]+		{strcpy(yylval.cval, yytext); strcat(yylval.cval, ".0"); return NUM;}
[0-9]+\.[0-9]+ {strcpy(yylval.cval, yytext); return NUM;}
\n		{return NEWLINE;}
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

%%