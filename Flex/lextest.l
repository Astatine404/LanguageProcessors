%option noyywrap

%{
	#include<iostream>
	#include<bits/stdc++.h>
	using namespace std;
%}

%%

[a-zA-Z]+ {cout<<"Word"<<" "<<yytext<<endl;}
[0-9]+ {cout<<"Number"<<" "<<yytext<<endl;}
[ \t] {}
\n {cout<"New line!\n";}
. {cout<<"Unknown"<<" "<<yytext<<endl;}

%%

int main(int argc, char** argv){
	yyin = stdin;

	if(argc>1)
		yyin = fopen(argv[1], "r");

	/*do{
		yylex();
	}while(!feof(yyin));*/
	yylex();

	return 0;
}	