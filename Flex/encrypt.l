%option noyywrap

%{
	void special(char*);
	void word(char*);
	void number(char*);

%}

%%

"special"|"hello"|"bye"			{special(yytext); }

[a-zA-Z]+		{word(yytext); }

[0-9]+			{number(yytext); }

[ \t]+			{printf(" "); }

.|\n 			{printf("%s", yytext);} //as it is

%%

void special(char* str){
	//rotate by two pos right
	int len = strlen(str);
	char str_[100];

	str_[0] = str[len-2];
	str_[1] = str[len-1];

	for(int i=2; i<len; i++){
		str_[i] = str[i-2];
	}


	//reverse

	for(int i=0; i<len/2; i++){
		char tmp = str_[i];
		str_[i] = str_[len-i-1];
		str_[len-i-1] = tmp;
	}

	printf("%s", str_);
	return;

}

void word(char* str){
	int len = strlen(str), k = 15;

	for(int i=0; i<len; i++){
		if(str[i]>='a'&&str[i]<='z')
			str[i] = 'a' + (str[i] + k - 'a') % ('z'-'a');
		else
			str[i] = 'A' + (str[i] + k - 'A') % ('Z'-'A');
	}

	//reverse
	for(int i=0; i<len/2; i++){
		char tmp = str[i];
		str[i] = str[len-i-1];
		str[len-i-1] = tmp;
	}

	printf("%s", str);
	return;
}

void number(char* str){
	int len = strlen(str);

	/*if(len%2==0){
		for(int i=0; i<len; i++){
			char tmp = str[i];
			str[i] = str[len/2+i];
			str[len/2+i] = tmp;
		}
	}
	else{
		for(int i=0; i<len; i++){
			char tmp = str[i];
			str[i] = str[len/2+i+1];
			str[len/2+i+1] = tmp;
		}
	}*/

	for(int i=0; i<len/2; i++){
			char tmp = str[i];
			str[i] = str[len/2+i+len%2];
			str[len/2+i+len%2] = tmp;
	}

	printf("%s", str);
	return;

}

int main(int argc, char** argv){
	if(argc>1)
		yyin = fopen(argv[1], "r");

	yylex();
	return 0;
}