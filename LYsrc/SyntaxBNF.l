
%{
//-----------------------------------------------------------------------------
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
//-----------------------------------------------------------------------------
//----Compile with -DP_VERBOSE=2 to list tokens as they are seen.
#ifndef P_VERBOSE
#  define P_VERBOSE 0
#  endif
int verbose2 = P_VERBOSE;

//----If tptp_prev_tok == PERIOD, you are outside any sentence.
#ifndef PERIOD
#  define PERIOD 46
#  endif

#define TPTP_STORE_SIZE 1048576

//----These have to be external as they are references from other code that
//----is generated by lex/yacc.
int tptp_prev_tok = PERIOD;
int tptp_store_size = TPTP_STORE_SIZE;
char* tptp_lval[TPTP_STORE_SIZE];
//-----------------------------------------------------------------------------
void tptp_print_tok(char* lval) { 

    printf("%3d:%s;\n", tptp_prev_tok, lval);

    return; 
}
//-----------------------------------------------------------------------------
int tptp_update_lval(char* lval) { 

    static int tptp_next_store = 0;
    int next = tptp_next_store;

    free(tptp_lval[tptp_next_store]);
    tptp_lval[tptp_next_store] = strdup(lval);
    tptp_next_store = (tptp_next_store+1) % TPTP_STORE_SIZE;
    if (verbose2 == 2) {
        tptp_print_tok(lval);
    }

    return next; 
}
//-----------------------------------------------------------------------------
//----%Start: INITIAL begin sentence, B before formula. No others.
%}

comment               {comment_line}|{comment_block}
comment_line          [%]{printable_char}*
comment_block         [/][*]{not_star_slash}[*][*]*[/]
not_star_slash        ([^*]*[*][*]*[^/*])*[^*]*
single_quoted         {single_quote}{sq_char}{sq_char}*{single_quote}
distinct_object       {double_quote}{do_char}*{double_quote}
dollar_word           {dollar}{alpha_numeric}*
dollar_dollar_word    {dollar}{dollar}{alpha_numeric}*
upper_word            {upper_alpha}{alpha_numeric}*
lower_word            {lower_alpha}{alpha_numeric}*
vline                 [|]
star                  [*]
plus                  [+]
arrow                 [>]
less_sign             [<]
hash                  [#]
real                  ({signed_real}|{unsigned_real})
signed_real           {sign}{unsigned_real}
unsigned_real         ({decimal_fraction}|{decimal_exponent})
rational              ({signed_rational}|{unsigned_rational})
signed_rational       {sign}{unsigned_rational}
unsigned_rational     {decimal}{slash}{positive_decimal}
integer               ({signed_integer}|{unsigned_integer})
signed_integer        {sign}{unsigned_integer}
unsigned_integer      {decimal}
decimal               ({zero_numeric}|{positive_decimal})
positive_decimal      {non_zero_numeric}{numeric}*
decimal_exponent      ({decimal}|{decimal_fraction}){exponent}{exp_integer}
decimal_fraction      {decimal}{dot_decimal}
dot_decimal           {dot}{numeric}{numeric}*
exp_integer           ({signed_exp_integer}|{unsigned_exp_integer})
signed_exp_integer    {sign}{unsigned_exp_integer}
unsigned_exp_integer  {numeric}{numeric}*
percentage_sign       [%]
double_quote          ["]
do_char               ([\40-\41\43-\133\135-\176]|[\\]["\\])
single_quote          [']
sq_char               ([\40-\46\50-\133\135-\176]|[\\]['\\])
sign                  [+-]
dot                   [.]
exponent              [Ee]
slash                 [/]
zero_numeric          [0]
non_zero_numeric      [1-9]
numeric               [0-9]
lower_alpha           [a-z]
upper_alpha           [A-Z]
alpha_numeric         ({lower_alpha}|{upper_alpha}|{numeric}|[_])
dollar                [$]
printable_char        .
viewable_char         [.\n]

%Start B FF SQ1 SQ2 Q1 Q2
%%

"&" {
    tptp_prev_tok=AMPERSAND;
    yylval.ival = tptp_update_lval(yytext);
    return(AMPERSAND);
}
"@@-" {
    tptp_prev_tok=AT_AT_SIGN_MINUS;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_AT_SIGN_MINUS);
}
"@@+" {
    tptp_prev_tok=AT_AT_SIGN_PLUS;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_AT_SIGN_PLUS);
}
"@" {
    tptp_prev_tok=AT_SIGN;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_SIGN);
}
"@=" {
    tptp_prev_tok=AT_SIGN_EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_SIGN_EQUALS);
}
"@-" {
    tptp_prev_tok=AT_SIGN_MINUS;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_SIGN_MINUS);
}
"@+" {
    tptp_prev_tok=AT_SIGN_PLUS;
    yylval.ival = tptp_update_lval(yytext);
    return(AT_SIGN_PLUS);
}
"^" {
    tptp_prev_tok=CARET;
    yylval.ival = tptp_update_lval(yytext);
    return(CARET);
}
":" {
    tptp_prev_tok=COLON;
    yylval.ival = tptp_update_lval(yytext);
    return(COLON);
}
":=" {
    tptp_prev_tok=COLON_EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(COLON_EQUALS);
}
"," {
    tptp_prev_tok=COMMA;
    yylval.ival = tptp_update_lval(yytext);
    return(COMMA);
}
"=" {
    tptp_prev_tok=EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(EQUALS);
}
"==" {
    tptp_prev_tok=EQUALS_EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(EQUALS_EQUALS);
}
"=>" {
    tptp_prev_tok=EQUALS_GREATER;
    yylval.ival = tptp_update_lval(yytext);
    return(EQUALS_GREATER);
}
"!" {
    tptp_prev_tok=EXCLAMATION;
    yylval.ival = tptp_update_lval(yytext);
    return(EXCLAMATION);
}
"!=" {
    tptp_prev_tok=EXCLAMATION_EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(EXCLAMATION_EQUALS);
}
"!!" {
    tptp_prev_tok=EXCLAMATION_EXCLAMATION;
    yylval.ival = tptp_update_lval(yytext);
    return(EXCLAMATION_EXCLAMATION);
}
"!>" {
    tptp_prev_tok=EXCLAMATION_GREATER;
    yylval.ival = tptp_update_lval(yytext);
    return(EXCLAMATION_GREATER);
}
"{" {
    tptp_prev_tok=LBRACE;
    yylval.ival = tptp_update_lval(yytext);
    return(LBRACE);
}
"[" {
    tptp_prev_tok=LBRKT;
    yylval.ival = tptp_update_lval(yytext);
    return(LBRKT);
}
"<=" {
    tptp_prev_tok=LESS_EQUALS;
    yylval.ival = tptp_update_lval(yytext);
    return(LESS_EQUALS);
}
"<=>" {
    tptp_prev_tok=LESS_EQUALS_GREATER;
    yylval.ival = tptp_update_lval(yytext);
    return(LESS_EQUALS_GREATER);
}
"<<" {
    tptp_prev_tok=LESS_LESS;
    yylval.ival = tptp_update_lval(yytext);
    return(LESS_LESS);
}
"<~>" {
    tptp_prev_tok=LESS_TILDE_GREATER;
    yylval.ival = tptp_update_lval(yytext);
    return(LESS_TILDE_GREATER);
}
"(" {
    tptp_prev_tok=LPAREN;
    yylval.ival = tptp_update_lval(yytext);
    return(LPAREN);
}
"-->" {
    tptp_prev_tok=MINUS_MINUS_GREATER;
    yylval.ival = tptp_update_lval(yytext);
    return(MINUS_MINUS_GREATER);
}
"." {
    BEGIN INITIAL;
    tptp_prev_tok=PERIOD;
    yylval.ival = tptp_update_lval(yytext);
    return(PERIOD);
}
"?" {
    tptp_prev_tok=QUESTION;
    yylval.ival = tptp_update_lval(yytext);
    return(QUESTION);
}
"??" {
    tptp_prev_tok=QUESTION_QUESTION;
    yylval.ival = tptp_update_lval(yytext);
    return(QUESTION_QUESTION);
}
"?*" {
    tptp_prev_tok=QUESTION_STAR;
    yylval.ival = tptp_update_lval(yytext);
    return(QUESTION_STAR);
}
"}" {
    tptp_prev_tok=RBRACE;
    yylval.ival = tptp_update_lval(yytext);
    return(RBRACE);
}
"]" {
    tptp_prev_tok=RBRKT;
    yylval.ival = tptp_update_lval(yytext);
    return(RBRKT);
}
")" {
    tptp_prev_tok=RPAREN;
    yylval.ival = tptp_update_lval(yytext);
    return(RPAREN);
}
"*" {
    tptp_prev_tok=STAR;
    yylval.ival = tptp_update_lval(yytext);
    return(STAR);
}
"~" {
    tptp_prev_tok=TILDE;
    yylval.ival = tptp_update_lval(yytext);
    return(TILDE);
}
"~&" {
    tptp_prev_tok=TILDE_AMPERSAND;
    yylval.ival = tptp_update_lval(yytext);
    return(TILDE_AMPERSAND);
}
"~|" {
    tptp_prev_tok=TILDE_VLINE;
    yylval.ival = tptp_update_lval(yytext);
    return(TILDE_VLINE);
}
"|" {
    tptp_prev_tok=VLINE;
    yylval.ival = tptp_update_lval(yytext);
    return(VLINE);
}
"$cnf" {
    tptp_prev_tok=_DLR_cnf;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_cnf);
}
"$fof" {
    tptp_prev_tok=_DLR_fof;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_fof);
}
"$fot" {
    tptp_prev_tok=_DLR_fot;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_fot);
}
"$ite" {
    tptp_prev_tok=_DLR_ite;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_ite);
}
"$let" {
    tptp_prev_tok=_DLR_let;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_let);
}
"$tff" {
    tptp_prev_tok=_DLR_tff;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_tff);
}
"$thf" {
    tptp_prev_tok=_DLR_thf;
    yylval.ival = tptp_update_lval(yytext);
    return(_DLR_thf);
}
<INITIAL>"cnf" {
    BEGIN B;
    tptp_prev_tok=_LIT_cnf;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_cnf);
}
<INITIAL>"fof" {
    BEGIN B;
    tptp_prev_tok=_LIT_fof;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_fof);
}
<INITIAL>"include" {
    BEGIN B;
    tptp_prev_tok=_LIT_include;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_include);
}
"tcf" {
    tptp_prev_tok=_LIT_tcf;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_tcf);
}
<INITIAL>"tff" {
    BEGIN B;
    tptp_prev_tok=_LIT_tff;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_tff);
}
<INITIAL>"thf" {
    BEGIN B;
    tptp_prev_tok=_LIT_thf;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_thf);
}
"tpi" {
    tptp_prev_tok=_LIT_tpi;
    yylval.ival = tptp_update_lval(yytext);
    return(_LIT_tpi);
}

{single_quoted} {
    tptp_prev_tok=single_quoted;
    yylval.ival = tptp_update_lval(yytext);
    return(single_quoted);
}
{distinct_object} {
    tptp_prev_tok=distinct_object;
    yylval.ival = tptp_update_lval(yytext);
    return(distinct_object);
}
{dollar_word} {
    tptp_prev_tok=dollar_word;
    yylval.ival = tptp_update_lval(yytext);
    return(dollar_word);
}
{dollar_dollar_word} {
    tptp_prev_tok=dollar_dollar_word;
    yylval.ival = tptp_update_lval(yytext);
    return(dollar_dollar_word);
}
{upper_word} {
    tptp_prev_tok=upper_word;
    yylval.ival = tptp_update_lval(yytext);
    return(upper_word);
}
{lower_word} {
    tptp_prev_tok=lower_word;
    yylval.ival = tptp_update_lval(yytext);
    return(lower_word);
}
{vline} {
    tptp_prev_tok=vline;
    yylval.ival = tptp_update_lval(yytext);
    return(vline);
}
{star} {
    tptp_prev_tok=star;
    yylval.ival = tptp_update_lval(yytext);
    return(star);
}
{plus} {
    tptp_prev_tok=plus;
    yylval.ival = tptp_update_lval(yytext);
    return(plus);
}
{arrow} {
    tptp_prev_tok=arrow;
    yylval.ival = tptp_update_lval(yytext);
    return(arrow);
}
{less_sign} {
    tptp_prev_tok=less_sign;
    yylval.ival = tptp_update_lval(yytext);
    return(less_sign);
}
{hash} {
    tptp_prev_tok=hash;
    yylval.ival = tptp_update_lval(yytext);
    return(hash);
}
{real} {
    tptp_prev_tok=real;
    yylval.ival = tptp_update_lval(yytext);
    return(real);
}
{signed_real} {
    tptp_prev_tok=signed_real;
    yylval.ival = tptp_update_lval(yytext);
    return(signed_real);
}
{unsigned_real} {
    tptp_prev_tok=unsigned_real;
    yylval.ival = tptp_update_lval(yytext);
    return(unsigned_real);
}
{rational} {
    tptp_prev_tok=rational;
    yylval.ival = tptp_update_lval(yytext);
    return(rational);
}
{signed_rational} {
    tptp_prev_tok=signed_rational;
    yylval.ival = tptp_update_lval(yytext);
    return(signed_rational);
}
{unsigned_rational} {
    tptp_prev_tok=unsigned_rational;
    yylval.ival = tptp_update_lval(yytext);
    return(unsigned_rational);
}
{integer} {
    tptp_prev_tok=integer;
    yylval.ival = tptp_update_lval(yytext);
    return(integer);
}
{signed_integer} {
    tptp_prev_tok=signed_integer;
    yylval.ival = tptp_update_lval(yytext);
    return(signed_integer);
}
{unsigned_integer} {
    tptp_prev_tok=unsigned_integer;
    yylval.ival = tptp_update_lval(yytext);
    return(unsigned_integer);
}
{decimal} {
    tptp_prev_tok=decimal;
    yylval.ival = tptp_update_lval(yytext);
    return(decimal);
}
{positive_decimal} {
    tptp_prev_tok=positive_decimal;
    yylval.ival = tptp_update_lval(yytext);
    return(positive_decimal);
}
{decimal_exponent} {
    tptp_prev_tok=decimal_exponent;
    yylval.ival = tptp_update_lval(yytext);
    return(decimal_exponent);
}
{decimal_fraction} {
    tptp_prev_tok=decimal_fraction;
    yylval.ival = tptp_update_lval(yytext);
    return(decimal_fraction);
}
{dot_decimal} {
    tptp_prev_tok=dot_decimal;
    yylval.ival = tptp_update_lval(yytext);
    return(dot_decimal);
}
{exp_integer} {
    tptp_prev_tok=exp_integer;
    yylval.ival = tptp_update_lval(yytext);
    return(exp_integer);
}
{signed_exp_integer} {
    tptp_prev_tok=signed_exp_integer;
    yylval.ival = tptp_update_lval(yytext);
    return(signed_exp_integer);
}
{unsigned_exp_integer} {
    tptp_prev_tok=unsigned_exp_integer;
    yylval.ival = tptp_update_lval(yytext);
    return(unsigned_exp_integer);
}
{comment}    tptp_update_lval(yytext);
[ \t\n]    ;
[\000-\040]|[\177]    ;
[\041-\176]    return(unrecognized);
%%
