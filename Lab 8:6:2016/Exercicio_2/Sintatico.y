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
    
    typedef struct elemento {
        symbol_t *val;
        struct elemento *prox;
    } listaS;


    void ConstroiLista(listaS **epinicio) {
        //listaS *p1;
        //char c;
        printf("Construiu a lista\n");
        *epinicio = NULL;
    }
    
    void InsereLista(listaS **epinicio, char *tipo, char *id){
        listaS *p1, *p2;
        
        symbol_t s;
        
        s.id = id;
        s.tipo = tipo;
        s.usado = 0;
        
        
        p1 = malloc (sizeof (listaS));
        p1->val = &s;
        if (*epinicio == NULL) {
            *epinicio = p1;
            p1->prox = NULL;
        }
        else
        if ((*epinicio)->val > &s) {
            p1->prox = *epinicio;
            *epinicio = p1;
        }
        else {
            p2 = *epinicio;
            while ((p2->prox != NULL) && (p2->prox->val < &s))
            p2 = p2->prox;
            p1->prox = p2->prox;
            p2->prox = p1;
        }
        printf("valor na lista = %s %s\n",(*epinicio)->val->tipo, (*epinicio)->val->id);
    }
    
    
    /////////////////////////////////
    
    void InsereLista(listaS **epinicio, char *tipo, char *id){
        listaS *p1, *p2;
        
        //Valor da lista
        symbol_t *s;
        s = malloc(sizeof(s));
        s->id = id;
        s->tipo = tipo;
        s->usado = 0;
        
        //Elemento da lista
        p1 = malloc (sizeof (listaS));
        p1->val = s;
        p1->prox = NULL;
        
        if (*epinicio == NULL){//Lista vazia
            *epinicio = p1;
        }
        else{//Coloca elemento no fim da lista
            p2 = *epinicio;
            while( p2->prox != NULL )//percorre a lista ate' encontrar o u'ltimo elemento
            p2 = p2->prox;
            
            //Encontrei o u'ltimo elemento
            p2->prox = p1;
            
        }
        printf("valor na lista = %s %s\n",p2->val->tipo, p2->val->id);
    }

    
    ////////////////////////////////
    
    
    
    
    
    
    
    int ProcuraLista(listaS *pinicio, char *chave) {
        listaS *p1;
        
        p1 = pinicio;
        while ((p1 != NULL)) {
            //printf("percorrendo : %s\n",p1->val->id);
            printf("%s e %s\n",p1->val->id, chave);
            getchar();
            getchar();
            if(!strcmp( p1->val->id, chave)) {
                return 1;
            }
            p1 = p1->prox;
        }
        return 0;
    }
    
    listaS *lista = NULL;
    char *vetorTemp = NULL;
    
    
    

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
var_declaration:    type_specifier ID ';' {
                                            if (lista == NULL) {
                                                ConstroiLista(&lista);
                                            }
                                            if (ProcuraLista(lista, $<cadeia>2) == 0) {
                                                InsereLista(&lista, $<cadeia>1, $<cadeia>2);
                                            }
                                            else {
                                                printf("Variavel já presente\n");
                                            }
                                            printf("Aqui tem uma declaracao id %s %s!\n", $<cadeia>1, $<cadeia>2  );}
;
type_specifier: TYPE {  //vetorTemp = $$<cadeia>;
                        //printf("vetor temp = %s\n",$<cadeia>1);
                        }
;
lista_cmds:     cmd		{;}
            |   cmd ';' lista_cmds	{;}
;
cmd:		ID OP_ATTR exp			{
                                        if (ProcuraLista(lista, $<cadeia>1) == 0) {
                                            printf("Variavel não foi declarada\n");
                                        }
                                        else {
                                            printf("retornou 1\n");
                                        }
                                        printf("Aqui tem um uso de id %s!\n", $<cadeia>1 );}
            |   cond
;
exp:            INT				{;}
            |   ID				{
                
                                    printf("Aqui tem um uso de id %s!\n", $<cadeia>1 );
                                    if (ProcuraLista(lista, $<cadeia>1) == 0) {
                                        printf("Variavel não foi declarada\n");
                                    }
                                    else {
                                        printf("retornou 1\n");
                                    };}
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
