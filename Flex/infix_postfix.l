%option noyywrap

%{
	#include<bits/stdc++.h>
	using namespace std;

	struct TNode {
		string symbol;
		struct TNode *right;
		struct Tnode *left;
	};

	void operater(char*);
	void operand(char*);
	stack<struct TNode*> s;
	stack<string> sstr;
%}

%%

[\+\-\*\/\@]|"um"		/*{cout<<"Operator "<<yytext<<endl;}*/ {operater(yytext);}
[a-zA-Z1-9]				/*{cout<<"Operand "<<yytext<<endl;}*/ {operand(yytext);}
.|[ \t\n]					{}  //ignore

%%

int prec(string p){
	if(p=="um")
		return 5;
	if(p=="@")
		return 4;
	if(p=="*"||p=="/")
		return 3;
	if(p=="+"||p=="-")
		return 2;
	cout<<"Error!";
}

void operater(char* str){
	string op(str);
	//cout<<op;
	if(sstr.empty()){
		sstr.push(op);
		return;
	}
	
	if(prec(op)>prec(sstr.top())){
		sstr.push(op);
		return;
	}
	
	while(!sstr.empty()){
		if(prec(op)<=prec(sstr.top())){
			cout<<sstr.top();
			sstr.pop();
		}
		else
		break;
	}

	sstr.push(op);
	return;

}

void operand(char* str){
	cout<<str;
}

int main(){
	yylex();

	while(!sstr.empty()){
		cout<<sstr.top();
		sstr.pop();
	}
	cout<<endl;
	return 0;
}