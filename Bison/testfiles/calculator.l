%option noyywrap

%{
	#include <iostream>
	#include <bits/stdc++.h>
	#include <string.h>
	using namespace std;

	#include "calculator.tab.h"
%}

%%

[ \t]	{}
[0-9]+	{yylval.ival = atoi(yytext); return IINT;}
\n {return NEWLINE;}
"display"	{return DISP;}
"let"	{return LET;}
"%"		{return MOD;}
"-"		{return MINUS;}
"+"		{return PLUS;}
"@"		{return EXP;}
"*"		{return MULTIPLY;}
"/"		{return DIVIDE;}
"um"	{return UM;}
"="		{return ASSG;}
"=="	{return EQUAL;}
"!="	{return NOTEQUAL;}
">"		{return GREATER;}
"<"		{return LESS;}
"("		{return LEFT;}
")"		{return RIGHT;}
"if"	{return IF;}
"else"	{return ELSE;}
"then"	{return THEN;}
"quit"	{return QUIT;}
[a-zA-Z][a-zA-Z0-9]* {strcpy(yylval.cval, yytext); return ID;}

%%