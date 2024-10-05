%option yylineno

%{

    #include <iostream>

    #include <vector>

    #include <string>

    #include <unordered_map>

    #include <algorithm>

    #include <cctype>

    using namespace std;

    vector<pair<string, int>> lexemes; 

    unordered_map<string, int> lexeme_count; 

    unordered_map<string, string> lexeme_token; 

%}

WS [ \t\f\n\r\v]

COMMENT \{[^\}]*\}

DELIMITERS [;:,\[\]\{\}\(\)]

DIGIT [0-9]

LETTER [a-zA-Z]

STRING (\"[^\"\']*\")|(\'[^\"\']*\')

ID {LETTER}({LETTER}|{DIGIT})*

DECIMAL [1-9][0-9]*|0

HEXADECIMAL 0[xX]([1-9a-fA-F][0-9a-fA-F]*|0)

FLOAT ([1-9][0-9]*|0)\.[0-9]{1,6}

%%

{WS}

{COMMENT}


[aA][rR][rR][aA][yY]|[bB][eE][gG][iI][nN]|[bB][oO][oO][lL][eE][aA][nN]|[cC][oO][mM][mM][eE][nN][tT]|[cC][oO][nN][tT][iI][nN][uU][eE]|[dD][oO]|[dD][oO][uU][bB][lL][eE]|[eE][lL][sS][eE]|[eE][nN][dD]|[fF][aA][lL][sS][eE]|[fF][oO][rR]|[iI][fF]|[iI][nN][tT][eE][gG][eE][rR]|[lL][aA][bB][eE][lL]|[lL][iI][sS][tT]|[lL][oO][nN][gG]|[oO][wW][nN]|[pP][rR][oO][cC][eE][dD][uU][rR][eE]|[sS][tT][eE][pP]|[sS][wW][iI][tT][cC][hH]|[tT][hH][eE][nN]|[tT][rR][uU][eE]|[uU][nN][tT][iI][lL]|[vV][aA][lL][uU][eE]|[wW][hH][iI][lL][eE] { /* action for the matched keyword */

        pair<string, int> target = {yytext, 1};

        string lowercase_lexeme = yytext;

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            lexeme_token[lowercase_lexeme] = "KEYWORD";

        }

        transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

            return tolower(c);

        });

        lexeme_count[lowercase_lexeme]++;

    }

[aA][nN][dD]|[oO][rR]|[lL][eE][qQ]|[lL][tT]|[gG][eE][qQ]|[gG][tT]|[nN][oO][tT]|[eE][qQ][lL]|[nN][eE][qQ]|":="|"+"|"-"|"*"|"/"|"%"|"^"|"|"|"&"|"<<"|">>"|"<="|">=" { /* action for the matched operator */

        pair<string, int> target = {yytext, 1};

        string lowercase_lexeme = yytext;

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            lexeme_token[lowercase_lexeme] = "OPERATOR";

        }

        transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

            return tolower(c);

        });

        lexeme_count[lowercase_lexeme]++;

    }

{DELIMITERS} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "DELIMITER";

        }

        lexeme_count[yytext]++;

    }

{ID} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "IDENTIFIER";

        }

        lexeme_count[yytext]++;

    }

{STRING} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "STRING";

        }

        lexeme_count[yytext]++;

    }

{FLOAT} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "FLOATING_POINT";

        }

        lexeme_count[yytext]++;

    }

{DECIMAL} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "INTEGER";

        }

        lexeme_count[yytext]++;

    }

{HEXADECIMAL} {

        pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "HEXADECIMAL";

        }

        lexeme_count[yytext]++;

    }

.   {
    cout << "Error: Invalid character at line " << yylineno << ": " << yytext << "\n";
}

\"[^\'\"]*\'[^\"]*\"    {
    string s = yytext;
    int count_newline = 0;
    for(char ch : s){
        if(ch == '\n'){
            count_newline++;
        }
    }
    cout << "Error: Ill formed string, single quote inside double quoted string at line " << yylineno - count_newline << ": " << yytext << "\n";
}

\'[^\'\"]*\"[^\']*\'    {
    string s = yytext;
    int count_newline = 0;
    for(char ch : s){
        if(ch == '\n'){
            count_newline++;
        }
    }
    cout << "Error: Ill formed string, double quote inside single quoted string at line " << yylineno - count_newline<< ": " << yytext << "\n";
}

\"[^\"]*|\'[^\']*    {
    string s = yytext;
    int count_newline = 0;
    for(char ch : s){
        if(ch == '\n'){
            count_newline++;
        }
    }
    cout << "Error: Unclosed string at line " << yylineno - count_newline << ": " << yytext << "\n";  
}


%%

int main(){

    yylex();

    cout<<"TOKEN\tCOUNT\tLEXEME\n";

    sort(lexemes.begin(), lexemes.end());

    for(auto lexeme : lexemes){

        if (lexeme.second){

            string lowercase_lexeme = lexeme.first;

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            cout<<lexeme_token[lowercase_lexeme]<<"\t"<<lexeme_count[lowercase_lexeme]<<"\t"<<lexeme.first<<'\n';

        }

        else{

            cout<<lexeme_token[lexeme.first]<<"\t"<<lexeme_count[lexeme.first]<<"\t"<<lexeme.first<<'\n';

        }

    }

    return 0;

}