%option noyywrap

%{
#include <iostream>
#include "expr_lexer.h"

#define YY_DECL Token getNextToken()

%}

hex [0-9a-fA-F]+
oct [0-7]+
bin [0-1]+
dec [0-9]+

%%
[ ] { /* Nothing */}
"0"[xX]{hex} return Token::Hex;
"0"[bB]{bin} return Token::Binary;
"0"{oct} return Token::Octal;
{dec} return Token::Decimal;
. throw std::string("invalid symbol");
<<EOF>>  return Token::Eof;

%%