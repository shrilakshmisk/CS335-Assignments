%option yylineno
%option caseless

%{
    #include <iostream>

    #include <vector>

    #include <string>

    #include <unordered_map>

    #include <algorithm>

    #include <cctype>

    #include "parser.tab.h"

    using namespace std;
%}


NEWLINE                 [\n]
ALPHABET                [a-zA-Z] 
TEXT                    {ALPHABET}+
BLANK                   [ \t]
LESSER_THAN             "<"
GREATER_THAN            ">"
EQUAL                   "="
DOUBLE_QUOTE            "\""
MARKS_                  [ \t]"marks"
MARKS                   "marks"
SLASH                   "/"
QUIZ                    "quiz"
SINGLESELECT            "singleselect"
MULTISELECT             "multiselect"
CHOICE                  "choice"
CORRECT                 "correct"
DIGIT                   [0-9]
INTEGER                 {DIGIT}+

%%

{NEWLINE}                  {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "NEWLINE "  << " " << yylineno - 1 << "\n";
    
    return NEWLINE;
}

"<"({BLANK}|{ALPHABET}|{NEWLINE})*"/"         {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "LESSER_THAN_SLASH " << yytext << " " << yylineno << "\n";
    return LESSER_THAN_SLASH;
}

{LESSER_THAN}              {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "LESSER_THAN " << yytext << " " << yylineno << "\n";
    return LESSER_THAN;
}

{GREATER_THAN}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
  //  cout << "GREATER_THAN " << yytext << " " << yylineno << "\n";
    return GREATER_THAN;
}

{EQUAL}              {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "EQUAL " << yytext << " " << yylineno << "\n";
    return EQUAL;
}

{DOUBLE_QUOTE}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
  //  cout << "DOUBLE_QUOTE " << yytext << " " << yylineno << "\n";
    return DOUBLE_QUOTE;
}


{MARKS_}              {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "MARKS_ " << yytext << " " << yylineno << "\n";
    return MARKS_;
}

{SLASH}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "SLASH " << yytext << " " << yylineno << "\n";
    return SLASH;
}

{QUIZ}              {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "QUIZ " << yytext << " " << yylineno << "\n";
    return QUIZ;
}

{SINGLESELECT}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "SINGLESELECT " << yytext << " " << yylineno << "\n";
    return SINGLESELECT;
}

{MULTISELECT}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "MULTISELECT " << yytext << " " << yylineno << "\n";
    return MULTISELECT;
}



{CHOICE}              {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "CHOICE " << yytext << " " << yylineno << "\n";
    return CHOICE;
}

{CORRECT}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "CORRECT " << yytext << " " << yylineno << "\n";
    return CORRECT;
}

{INTEGER}      {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "INTEGER " << yytext << " " << yylineno << "\n";
    return INTEGER;
}

{BLANK} {
    strcpy(yylval.attr.str, yytext);
    yylval.attr.lineno = yylineno;
   // cout << "BLANK " << yytext << " " << yylineno << "\n";
    return BLANK;
}


. {}

<<EOF>> {yyterminate();}








%%

int yywrap(){
    return 1;
}