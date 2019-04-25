%{
	#include<iostream>
	#include<bits/stdc++.h>
	using namespace std;

	extern int yylex();
	extern int yyparse();
	extern FILE* yyin;

	void yyerror(const char* str);
	map<string, int> vars; 
%}

%union{
	int ival;
	char cval[100];
}

%token<ival> IINT
%token<cval> ID
%token NEWLINE DISP ASSG LET MOD MINUS PLUS EXP MULTIPLY DIVIDE EQUAL NOTEQUAL GREATER LESS LEFT RIGHT QUIT IF THEN ELSE UM
%left EQUAL NOTEQUAL LESS GREATER
%left MINUS PLUS
%left MULTIPLY DIVIDE
%left MOD
%right EXP
%right UM

%type<ival> expr elif iff


%start calculate

%%

calculate: 
		| calculate line 
		;

line: NEWLINE
	| DISP expr NEWLINE	{cout<<$2<<endl;};
	| DISP ID NEWLINE {if(vars.find($2)!=vars.end()){ cout<<vars[$2]<<endl; } else { yyerror("Undeclared identifier"); }}
	| LET ID NEWLINE	{vars[$2] = 0;}
	| ID ASSG expr NEWLINE {if(vars.find($1)!=vars.end()){ vars[$1] = $3; } else { yyerror("Undeclared identifier"); }}
	| ID ASSG ID NEWLINE	{if(vars.find($1)!=vars.end() && vars.find($3)!=vars.end()){ vars[$1] = vars[$3]; } else { yyerror("Undeclared identifier"); }}
	| QUIT NEWLINE 			{exit(0);}
	| iff NEWLINE {cout<<$1<<endl;}
	;

iff: IF expr THEN expr elif {if($2){$$ = $4;}else{$$ = $5;}}
	;

elif: 						{$$ = INT_MIN;}
	| ELSE iff 				{$$ = $2;}
	| ELSE expr				{$$ = $2;}
	;


expr: IINT {$$ = $1;}
	| ID {if(vars.find($1)!=vars.end()){ $$ = vars[$1]; } else { yyerror("Undeclared identifier"); }}
	| expr PLUS expr {$$ = $1 + $3;}
	| expr MINUS expr {$$ = $1 - $3;}
	| expr EXP expr {$$ = pow($1, $3);}
	| expr MOD expr {$$ = $1 % $3;}
	| expr MULTIPLY expr {$$ = $1 * $3;}
	| expr DIVIDE expr {$$ = $1 / $3;}
	| UM expr {$$ = -$2;}
	| expr EQUAL expr {$$ = $1 == $3;}
	| expr NOTEQUAL expr {$$ = $1 != $3;}
	| expr GREATER expr {$$ = $1 > $3;}
	| expr LESS expr {$$ = $1 < $3;}
	| LEFT expr RIGHT {$$ = $2;}
	;
	
%%

int main(){
	yyin = stdin;

	do {
		yyparse();
	}while(!feof(yyin));

	return 0;
}

void yyerror(const char* str){
	cout<<"Syntax Error: "<<str<<endl;
}