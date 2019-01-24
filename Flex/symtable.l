%option noyywrap nodefault yylineno case-insensitive

%{

	struct symbol {
		char *name;
		struct ref *reflist;
	};

	struct ref {
		struct ref *next;
		int flags;
		int lineno;
	};

	#define NHASH 9997
	struct symbol symtab[NHASH];

	struct symbol *lookup(char*);
	void addref(int, char*, int);


%}

%%

[a-z]+(\'(s|t))?	{addref(yylineno, yytext, 0); }
.|\n 				/*ignore*/

%%

static unsigned symhash(char *sym){
	unsigned int hash = 0;
	unsigned c;

	while(c = *sym++) hash = hash*9 ^ c;
}

struct symbol *lookup(char* sym){
	struct symbol *sp = &symtab[symhash(sym)%NHASH];
	int scount = NHASH;

	while(--scount >= 0) {
		if(sp->name && !strcmp(sp->name, sym)) //found
			return sp;

		if(!sp->name) { //not found
			sp->name = strdup(sym);
			sp->reflist = 0;
			return sp;
		}

		if(++sp >= symtab+NHASH) //reached end of table
			sp = symtab;		//go to beginning
	}

	fputs("Overflow Error\n", stderr);
	abort();
}

void addref(int lineno, char *word, int flags){
	struct ref *r;
	struct symbol *sp = lookup(word);

	if(sp->reflist && sp->reflist->lineno == lineno)
		return;

	r = malloc(sizeof(struct ref));
	if(!r) {fputs("out of space\n", stderr); abort(); }

	r->next = sp->reflist;
	r->lineno = lineno;
	r->flags = flags;
	sp->reflist = r;
}

void printrefs(){
	struct symbol *sp;

	for(sp = symtab; sp->name && sp < symtab+NHASH; sp++){
		//reverse reference list
		struct ref *rp = sp->reflist;
		struct ref *rpp = 0; //prev
		struct ref *rpn; //next

		do{
			rpn = rp->next;
			rp->next = rpp;
			rpp = rp;
			rp = rpn;
		} while(rp);

	
		printf("%10s", sp->name);
		for(rp = rpp; rp; rp = rp->next) {
			printf(" %d", rp->lineno);
		}
		printf("\n");
	}
}

int main(int argc, char** argv){
	int i;

	yylineno = 1;
	yylex();

	printrefs();
}

