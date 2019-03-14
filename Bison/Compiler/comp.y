%{
	#include<string.h>
	#include<stdio.h>
	#include<stdlib.h>

	extern int yylex();
	extern int yyparse();
	extern FILE* yyin;
	char* addtotable(char*, char*, char*);
	char* toStr(int);
	int temp=0, ind=0;
	void yyerror(const char* s);

	struct expr {
		char opr1[10];
		char opr2[10];
		char otr[10];
		char res[10];
	};
%}

%union {
	char cval[100];
}

%token<cval> NUM
%token PLUS MINUS MULTIPLY DIVIDE LEFT RIGHT MOD EXP
%token NEWLINE QUIT ASSG EQUAL NOTEQUAL LESS GREATER
%left EQUAL NOTEQUAL LESS GREATER
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right EXP
%left MOD
%left ID

%type<cval> ID expression

%start line

%%

line: ID ASSG expression ';' NEWLINE {addtotable($1, $3, "=");}
	| QUIT NEWLINE { exit(0); }
	;

expression: NUM	{ strcpy($$, $1); }
	  | ID 			{ strcpy($$, $1); }
	  | expression PLUS expression	{ strcpy($$, addtotable($1, $3, "+")); }
	  | expression MINUS expression	{ strcpy($$, addtotable($1, $3, "-")); }
	  | expression MULTIPLY expression	{ strcpy($$, addtotable($1, $3, "*")); }
	  | expression DIVIDE expression {strcpy($$, addtotable($1, $3, "/")); }
	  | expression LESS expression {strcpy($$, addtotable($1, $3, "<")); }
	  | expression GREATER expression {strcpy($$, addtotable($1, $3, ">")); }
	  | expression EQUAL expression {strcpy($$, addtotable($1, $3, "==")); }
	  | expression NOTEQUAL expression {strcpy($$, addtotable($1, $3, "!=")); }
	  | expression EXP expression {strcpy($$, addtotable($1, $3, "@")); }
	  | expression MOD expression {strcpy($$, addtotable($1, $3, "%")); }
	  | LEFT expression RIGHT		{ strcpy($$, $2); }
	  ;

%%

struct expr arr[100];

char* addtotable(char* op1, char* op2, char* or){
	temp++;
	strcpy(arr[ind].opr1, op1);
	strcpy(arr[ind].opr2, op2);
	strcpy(arr[ind].otr, or);
	char *res = malloc(10*sizeof(char));
	sprintf(res, "t%d", temp);
	strcpy(arr[ind].res, res);
	ind++;

	return res;

}


void threeAdd(){
	for(int i=0; i<ind; i++){
		printf("%s = %s %s %s\n", arr[i].res, arr[i].opr1, arr[i].otr, arr[i].opr2);
	}
}

int main() {
	yyin = stdin;

	yyparse();
	threeAdd();

	return 0;
}

void yyerror(const char *s){
	fprintf(stderr, " ");
}