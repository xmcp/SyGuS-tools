%{
    #include <utility>
    #include <vector>
    #include <SynthLib2ParserIFace.hpp>
    using namespace std;
    using namespace SynthLib2Parser;

    #include "SynthLib2Parser.tab.h"
    /* C includes, etc */
    extern long yylinenum;
    extern long yycolnum;
%}

%option noyywrap
%option nodefault

%x                      linecomment
WS                      [ \t\f\r]
LETTER                  [a-zA-Z_]
DIGIT                   [0-9]
HEXDIGIT                {DIGIT}|[a-f]|[A-F]
BIT                     "0"|"1"
INTEGER                 (-?{DIGIT}+)
INTCONST                {INTEGER}
BVCONST                 "#x"{HEXDIGIT}+|"#b"{BIT}+
REALCONST               (-?{DIGIT}+"."{DIGIT}+)
SYMBOLCC                [a-z]|[A-Z]|"_"|"+"|"-"|"*"|"&"|"|"|"!"|"~"|"<"|">"|"="|"/"|"%"|"?"|"."|"$"|"^"
SYMBOL                  {SYMBOLCC}({SYMBOLCC}|{DIGIT})*
QUOTEDLIT               "\""([a-z]|[A-Z]|{DIGIT}|".")+"\""
STRINGCONST             "\""({SYMBOLCC}|{WS}|{DIGIT}|","|"("|")")*"\""

%%

{WS}                    { yycolnum++; }
[\n]                    { yylinenum++; yycolnum = 0; }
";"                     { BEGIN linecomment; yycolnum += 1; }
<linecomment>\n         { BEGIN INITIAL; yylinenum++; yycolnum = 0; }
<linecomment>.          { yycolnum++; }
"define-sort"           { yycolnum += strlen(yytext); return TK_DEFINE_SORT; }
"define-fun"            { yycolnum += strlen(yytext); return TK_DEFINE_FUN; }
"declare-fun"           { yycolnum += strlen(yytext); return TK_DECLARE_FUN; }
"set-options"           { yycolnum += strlen(yytext); return TK_SET_OPTIONS;}
"check-synth"           { yycolnum += strlen(yytext); return TK_CHECK_SYNTH; }
"declare-var"           { yycolnum += strlen(yytext); return TK_DECLARE_VAR; }
"declare-primed-var"    { yycolnum += strlen(yytext); return TK_DECLARE_PRIMED_VAR; }
"synth-fun"             { yycolnum += strlen(yytext); return TK_SYNTH_FUN; }
"synth-inv"             { yycolnum += strlen(yytext); return TK_SYNTH_INV; }
"set-logic"             { yycolnum += strlen(yytext); return TK_SET_LOGIC; }
"constraint"            { yycolnum += strlen(yytext); return TK_CONSTRAINT; }
"inv-constraint"        { yycolnum += strlen(yytext); return TK_INV_CONSTRAINT; }
"("                     { yycolnum += strlen(yytext); return TK_LPAREN; }
")"                     { yycolnum += strlen(yytext); return TK_RPAREN; }
"_"                     { yycolnum += strlen(yytext); return TK_UNDERSCORE; }
"BitVec"                { yycolnum += strlen(yytext); return TK_BV; }
"Array"                 { yycolnum += strlen(yytext); return TK_ARRAY; }
"Int"                   { yycolnum += strlen(yytext); return TK_INT; }
"String"                { yycolnum += strlen(yytext); return TK_STRING; }
"Bool"                  { yycolnum += strlen(yytext); return TK_BOOL; }
"Enum"                  { yycolnum += strlen(yytext); return TK_ENUM; }
"Real"                  { yycolnum += strlen(yytext); return TK_REAL; }
"Constant"              { yycolnum += strlen(yytext); return TK_CONSTANT; }
"Variable"              { yycolnum += strlen(yytext); return TK_VARIABLE; }
"InputVariable"         { yycolnum += strlen(yytext); return TK_INPUT_VARIABLE; }
"LocalVariable"         { yycolnum += strlen(yytext); return TK_LOCAL_VARIABLE; }
"let"                   { yycolnum += strlen(yytext); return TK_LET; }
"::"                    { yycolnum += strlen(yytext); return TK_DOUBLECOLON; }
"true"                  { 
                            yylval.LexerString = new string(yytext); 
                            yycolnum += strlen(yytext); 
                            return TK_BOOL_LITERAL; 
                        }
"false"                 { 
                            yylval.LexerString = new string(yytext); 
                            yycolnum += strlen(yytext); 
                            return TK_BOOL_LITERAL; 
                        }
{INTCONST}              {
                            yycolnum += strlen(yytext);
                            yylval.LexerString = new string(yytext);
                            return TK_INT_LITERAL;
                        }
{STRINGCONST}           {
                            yycolnum += strlen(yytext);
                            string *SymbolVal = new string(yytext);
                            yylval.LexerString = SymbolVal;
                            return TK_STRING_LITERAL;
                        }
{REALCONST}             {
                            yycolnum += strlen(yytext);
                            yylval.LexerString = new string(yytext);
                            return TK_REAL_LITERAL;
                        }
{BVCONST}               {
                            yycolnum += strlen(yytext);
                            yylval.LexerString = new string(yytext);
                            return TK_BV_LITERAL;
                        }
{SYMBOL}                {
                            yycolnum += strlen(yytext);
                            string *SymbolVal = new string(yytext); 
                            yylval.LexerString = SymbolVal;
                            return TK_SYMBOL;
                        }
{QUOTEDLIT}             {
                            yycolnum += strlen(yytext);
                            string* SymbolVal = new string(yytext);
                            yylval.LexerString = SymbolVal;
                            return TK_QUOTED_LITERAL;
                        }
.                       { return TK_ERROR; }

