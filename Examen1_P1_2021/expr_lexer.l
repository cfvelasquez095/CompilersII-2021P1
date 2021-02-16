%option noyywrap
%option nodefault

%{
  #include <iostream>
  #include <cstdio>
  #include <cstring>
  #include "expr_tokens.h"
  #define YY_DECL int yylex(Expr::Parser::semantic_type *yylval)

  using Token = Expr::Parser::token;
%}

%x bcomment

%%

[ \t] { /* Nothing */ }
[\n]+ return Token::Tk_EOL;
"#"[^\n]* { /* Nothing */ }
"{" {BEGIN(bcomment);}
[+]  return Token::Op_Add;
[-]  return Token::Op_Sub;
[/]  return Token::Op_Div;
[*]  return Token::Op_Mul;
[(]  return Token::Tk_OpenPar;
[)]  return Token::Tk_ClosePar;
[=]  return Token::Op_Assign;
[;]  return Token::Tk_Semicolon;
[%]  return Token::Op_Mod;
[_a-zA-Z][_a-zA-Z0-9]* { yylval->emplace<std::string>(yytext, yyleng); return Token::Tk_Id; }
[0-9]+("."[0-9]+)?  { yylval->emplace<int>(atoi(yytext)); return Token::Tk_Number; }
. std::cout << "Unexpected error";

<bcomment>"}" { BEGIN(INITIAL); }
<bcomment>.|\n { /* Nothing */}
<bcomment><<EOF>> { std::cout << "Error no cerró comentario" << '\n'; }

%%