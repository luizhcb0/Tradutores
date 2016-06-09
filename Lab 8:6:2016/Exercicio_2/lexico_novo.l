/*
 
 id letra maiuscula e/ou minuscula comecando por maiuscula : ok
 num inteiro com sinal opcional : ok
 op atrib <- - ok
 op arit * / + : ok
 op rel: <> == : ok
 del bloco abre e fecha : ok
 
 */
%{
    #include "Sintatico.tab.h"
%}
%%
("int"|"void")                    {return TYPE;}
("{")                             {return BLCK_DEL_O;}
("}")                             {return BLCK_DEL_C;}
("if")                                {return OP_IF;}
("else")                              {return OP_ELSE;}
[A-Z][a-zA-Z]*                    { yylval.cadeia= (char*) strdup(yytext); return ID;}
("+"|"-")?[0-9]+                  {return INT;}
("<-")                            {return OP_ATTR;}
("*"|"/"|"+"|"-")                 {return OP_ART;}
("<>"|"==")                       {return OP_REL;}
[ \t\n]+                              {;}
.                              {return yytext[0];}
%%
int yywrap () {
    return 1;
}
