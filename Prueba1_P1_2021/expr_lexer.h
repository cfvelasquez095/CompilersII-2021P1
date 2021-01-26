#ifndef _EXPR_LEXER_H
#define _EXPR_LEXER_H

enum class Token {
    Eof,
    Decimal,
    Binary,
    Octal,
    Hex
};

Token getNextToken();

#endif
