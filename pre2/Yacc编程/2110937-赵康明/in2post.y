%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char* // 修改为字符型
#endif
char id[100];
char num[100]; // 增加
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char* s);
%}
%token NUMBER
%token ID
%token ADD MINUS
%token MUL DIV
%token LP	RP
%left ADD MINUS
%left MUL	DIV
%right UMINUS

%%

lines		:	lines expr ';' {printf("%s\n", $2);}
		|	lines ';'
		|
		;

expr		:	expr ADD expr {$$=(char*)malloc(100*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"+");}
                      // expr expr +
		|	expr MINUS expr {$$=(char*)malloc(100*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"-");}
		
        |	expr MUL expr {$$=(char*)malloc(100*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"*");}
		
        |	expr DIV expr {$$=(char*)malloc(100*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"/");}
		
        |   LP expr RP  {$$=(char*)malloc(100*sizeof(char)); strcpy($$,$2);}
		
        |	NUMBER {$$=(char*)malloc(100*sizeof(char));strcpy($$,$1);strcat($$," ");}
       
        |   ID  {$$=(char*)malloc(100*sizeof(char));strcpy($$,$1);strcat($$," ");}
		;

%%

int yylex()
{
	int t;
	while(1){
		t = getchar();
		if(t == ' ' || t == '\t' || t == '\n'){

		}
		else if(t>='0'&&t<='9')// 数字
		{
			int len=0; // 记录长度
			while(t>='0'&&t<='9'){
                num[len]=t;
                len++;
				t = getchar();
			}
            num[len]='\0';
            yylval=num;
			ungetc(t, stdin);
			return NUMBER;
		}
        // 字母
        else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_'))
        {
            int len=0; // 长度
			while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){
                id[len]=t;
                len++;
				t = getchar();
			}
            id[len]='\0';
            yylval=id;
			ungetc(t, stdin);
			return ID;
        }
		else if(t == '+'){
			return ADD;
		}
		else if(t == '-'){
			return MINUS;
		}
		else if(t == '*'){
			return MUL;
		}
		else if(t == '/'){
			return DIV;
		}
		else if(t == '('){
			return LP;
		}
		else if(t == ')'){
			return RP;
		}
		else{
			return t;
		}
	}
}

int main(void)
{
	yyin = stdin;
	do{
		yyparse();
	}while(!feof(yyin));
	return 0;
}

void yyerror(const char* s){
	fprintf(stderr, "Parse error:%s\n", s);
	exit(1);
}
