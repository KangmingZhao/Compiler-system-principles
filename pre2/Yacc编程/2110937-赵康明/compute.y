%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double 
#endif
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char* s);
%}

%token ADD MINUS
%token MUL DIV
%token LP	RP
%token NUMBER
%left ADD MINUS
%left MUL	DIV
%right UMINUS

%%

lines		:	lines expr ';' {printf("%f\n", $2);}
		|	lines ';'
		|
		;

expr		:	expr ADD expr {$$ = $1 + $3;}
		|	expr MINUS expr {$$ = $1 - $3;}
		|	expr MUL expr {$$ = $1 * $3;}
		|	expr DIV expr {$$ = $1 / $3;}
		|   LP expr RP  {$$ = $2;}
		|	MINUS expr %prec UMINUS {$$ = -$2;}
		|	NUMBER {$$ = $1;}
		;

%%

int yylex()
{
	int t;
	while(1){
		t = getchar();
		if(t == ' ' || t == '\t' || t == '\n'){

		}
		else if(isdigit(t))
		{
			yylval = 0;
			// 谨防2+3 2等不小心输错情况跳出循环
			while(isdigit(t)||t == ' ' || t == '\t' || t == '\n'){

				if(isdigit(t)){
				yylval = yylval * 10 + t - '0';
				}
				t = getchar();
			}
			
			ungetc(t, stdin);
			// 如果不是数字空格换行制表符 将字符返回到输入流继续处理
			return NUMBER;
			// 返回单词序列
			
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
