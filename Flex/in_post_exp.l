%option noyywrap

%{
	#include<bits/stdc++.h>
	using namespace std;

	struct TNode {
		string symbol;
		struct TNode *right;
		struct TNode *left;
	};

	void operater(char*);
	void operand(char*);
	stack<struct TNode*> opd;
	stack<struct TNode*> opr;
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
	struct TNode *root = new (struct TNode);
	struct TNode *tmp;
	root->symbol = op;
	root->right = NULL;
	root->left = NULL;

	if(opr.empty()){
		opr.push(root);
		return;
	}
	
	if(prec(op)>prec(opr.top()->symbol)){
		opr.push(root);
		return;
	}
	
	while(!opr.empty()){
		if(prec(op)<=prec(opr.top()->symbol)){
			if(op=="@"&&prec(op)==prec(opr.top()->symbol))
				break;
			tmp = opr.top();
			opr.pop();
			
				tmp->right = opd.top(); opd.pop();
				tmp->left = opd.top(); opd.pop();
			
			
			opd.push(tmp);
		}
		else
		break;
	}

	opr.push(root);
	return;

}

void operand(char* str){
	string op(str);
	struct TNode *root = new (struct TNode);
	root->symbol = op;
	root->right = NULL;
	root->left = NULL;
	opd.push(root);
}

void postorder(struct TNode *root){
	if(!root)
		return;

	postorder(root->left);
	postorder(root->right);
	cout<<root->symbol;
}

int main(){
	yylex();
	struct TNode *tmp;
	while(!opr.empty()){
		tmp = opr.top(); opr.pop();
		tmp->right = opd.top(); opd.pop();
		tmp->left = opd.top(); opd.pop();
		opd.push(tmp);
	}
	
	if(opd.size()==1)
		postorder(opd.top());
	else
		cout<<"Error!";

	cout<<endl;
	return 0;
}