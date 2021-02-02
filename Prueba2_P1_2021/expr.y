%define parse.error verbose
%parse-param { std::unordered_map<std::string, int>& vars}
%parse-param { std::ostringstream &sout }

%code requires {

#include <string>
#include <unordered_map>

}

%{
    #include <sstream>
    #include <iostream>
    #include <string>
    #include <stdexcept>
    #include <unordered_map>
    #include "expr_lexer.h"

    extern ExprLexer yylex;
    
    void yyerror(std::unordered_map<std::string, int>& vars, std::ostringstream &out ,const char * e) {
        throw std::runtime_error(e);
    }

%}

%union {
    int number_t;
    char *str_t;
}

%token<str_t> IDENT "identifier"
%token OPASSIGN "="
%token OPEN_PAR "("
%token<number_t> NUMBER "number"
%token OPADD "+"
%token OPSUB "-"
%token CLOSE_PAR ")"
%token OPMUL "*"
%token OPDIV "/"
%token EOL "\\n"
%token KWPRINT "print"
%token TKEOF

%type<number_t> expr term factor

%%

input: stmt_list opt_eol
    ;

opt_eol:
    | "\\n"
    ;

stmt_list: stmt_list "\\n" stmt
    | stmt
    ;

stmt: "identifier" "=" expr { vars.emplace($1, $3); }
    | "print" expr   { sout << $2 << '\n'; }
    ;

expr: expr "+" term {$$ = $1 + $3;}
    | expr "-" term {$$ = $1 - $3;}
    | term          {$$ = $1;}
    ;

term: term "*" factor {$$ = $1 * $3;}
    | term "/" factor {$$ = $1 / $3;}
    | factor          {$$ = $1;}
    ;

factor: "number" { $$ = $1; }
    |   "identifier" {
            std::string ident = $1;
            $$ = vars.at(ident);
            free($1);
    }
    | "(" expr ")" {$$ = $2;}
    ;

%%