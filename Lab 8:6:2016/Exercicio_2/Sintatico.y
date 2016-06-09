/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
    #include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
//	#define YYDEBUG 1

	typedef struct s_table{
		char* tipo;	
		char* id;
		int usado;	
	} symbol_t;
	
	symbol_t st;

	typedef struct node {
	    symbol_t* val;
	    struct node * next;
	} node_t;

	node_t* create(void){
		node_t * head = NULL;
		head = malloc(sizeof(node_t));
		if (head == NULL) {
		    
			printf("Erro na criacao da lista\n");
			return NULL;
		}
		
		head->next = NULL;
		return head;
	}

	void push(node_t * head, symbol_t* val) {
	    node_t * current = head;
	    while (current->next != NULL) {
	        current = current->next;
	    }
	
	    /* now we can add a new variable */
	    current->next = malloc(sizeof(node_t));
	    current->next->val = val;
	    current->next->next = NULL;
	}

	int search_list(node_t * head, char* token_var) {
	    node_t * current = head;
	
	    while (current != NULL) {
		if( !strcmp( current->val->id, token_var) )
			return 1; //se igual
	    }
		return 0;
	}
%}

%union{
	char* cadeia;
}
%token BLCK_DEL_O
%token BLCK_DEL_C
%token  ID
%token INT
%token OP_ATTR
%token OP_ART
%token OP_REL
%token OP_IF
%token OP_ELSE
%token TYPE
%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */

//programa '\n'  { printf ("Programa sintaticamente correto!\n"); }
//;
programa:	BLCK_DEL_O declaration_list lista_cmds BLCK_DEL_C	{printf ("Programa sintaticamente correto!\n");}
            | BLCK_DEL_O lista_cmds BLCK_DEL_C	{printf ("Programa sintaticamente correto!\n");}
            | BLCK_DEL_O declaration_list BLCK_DEL_C	{printf ("Programa sintaticamente correto!\n");}
;
declaration_list:   declaration_list declaration  {;}
                    | declaration   {;}
;
declaration:       var_declaration  {;}
;
var_declaration:    type_specifier ID ';' { 	st.id = $<cadeia>2; printf("Aqui tem uma declaracao id %s!\n", st.id  );
					}
;
type_specifier: TYPE {;}
;
lista_cmds: cmd		{;}
            | cmd ';' lista_cmds	{;}
;
cmd:		ID OP_ATTR exp			{printf("Aqui tem um uso de id %s!\n", $<cadeia>1 );}
            | cond
;
exp:		INT				{;}
            | ID				{printf("Aqui tem um uso de id %s!\n", $<cadeia>1 );}
            | exp exp OP_ART		{;}
;
cond:       OP_IF cmd OP_ELSE cmd  {;}
;
%%
main (int argc, char *argv[]) {

    extern FILE *yyin;
    extern FILE *yyout;
//	extern int yydebug;
//  	yydebug = 1; 
    if (argc > 1) {
        yyin = fopen(argv[1],"rt");
        yyout = fopen(argv[2], "wt");
    }
    //else {
    //    yyin = stdin;
    //}
    yyparse ();
    fclose(yyin);
    fclose(yyout);
}
yyerror (s) /* Called by yyparse on error */
char *s;

{
    printf ("Problema com a analise sintatica! %s\n", s);
}
