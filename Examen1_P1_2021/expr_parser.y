%require "3.0"
%language "c++"
%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}
%parse-param { std::unordered_map<std::string, int>& vars }
%parse-param { std::vector<int>& values}

%code requires {

#include <string>
#include <unordered_map>
#include <vector>

}

%{
#include <iostream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>
#include "expr_tokens.h"

namespace Expr {
    void Parser::error(const std::string &msg) {
        throw std::runtime_error(msg);
    }
}

int yylex(Expr::Parser::semantic_type *yylval);

%}

%token Tk_OpenPar       "("
%token Tk_ClosePar      ")"
%token Tk_Semicolon     ";"

%token Op_Assign        "="
%token Op_Add           "+"
%token Op_Sub           "-"
%token Op_Mul           "*"
%token Op_Div           "/"
%token Op_Mod           "%"

%token<int> Tk_Number "number"
%token<std::string> Tk_Id "id"

%token Tk_EOL "\\n"

%type<int> expr term factor

%%

stmt_list: opt_eol stmt opt_eol
    | stmt_list stmt opt_eol
    ;

stmt: "id" "=" expr { vars.emplace($1, $3); }
    | expr { values.push_back($1); }
    ;

opt_eol: opt_eol "\\n"
    |   opt_eol ";"
    | 
    ;

expr: expr "+" term { $$ = $1 + $3; }
    | expr "-" term { $$ = $1 - $3; }
    | term { $$ = $1; }
;

term: term "*" factor { $$ = $1 * $3; }
    | term "/" factor { $$ = $1 / $3;  }
    | term "%" factor { $$ = $1 % $3; }
    | factor { $$ = $1; }
;

factor: "number" { $$ = $1; }
      | "id" { $$ = vars[$1]; }
      | "(" expr ")" { $$ = $2 ; } 
;

%%