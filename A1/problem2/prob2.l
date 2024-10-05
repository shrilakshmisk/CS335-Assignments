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

WS  [ \t\f\n\r\v]

COMMENT ^[ \t\n\r\f\v]*"!"[^\n]*

DELIMITERS  [\(\)\[\]]|"(/"|"/)"

NAME    [a-zA-Z][a-zA-Z0-9_]{0,62}

INT     [0-9]+

SIGNEDINT [+-]?[0-9]+

REAL    (([0-9]+\.[0-9]*|\.[0-9]+)([eEdD][+-]?[0-9]+)?)|([0-9]+[eEdD][+-]?[0-9]+)

SIGNEDREAL [+-]?{REAL}

LOGICAL .\[tT][rR][uU][eE]\.|\.[fF][aA][lL][sS][eE]\.

STRING  \"[^\"\']*\"

OPERATOR    "=="|"%"|"&&"|"&"|"<<"|">>"|"||"|"**"|"*"|"//"|"+"|"-"|"/"|\.[eE][qQ]\.|\.[nN][eE]\.|\.[lL][tT]\.|\.[lL][eE]\.|\.[gG][tT]\.|\.[gG][eE]\.|"="|"/="|"<"|"<="|">"|">="|\.[nN][oO][tT]\.|\.[aA][nN][dD]\.|\.[oO][rR]\.|\.[eE][qQ][vV]\.|\.[nN][eE][qQ][vV]\.

SPECIAL "\\"|"{"|"}"|","|"."|":"|";"|"~"|"?"|"`"|"|"|"$"|"#"|"@"|"'"|"^"|"!"

%%

{WS} 

{COMMENT}

{OPERATOR}  {
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

{DELIMITERS}    {
    pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "DELIMITER";

        }

        lexeme_count[yytext]++;
}

{SPECIAL}   {
    pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "SPECIAL_CHAR";

        }

        lexeme_count[yytext]++;
}

[aA][lL][lL][oO][cC][aA][tT][aA][bB][lL][eE]|[aA][lL][lL][oO][cC][aA][tT][eE]|[aA][sS][sS][iI][gG][nN]|[aA][sS][sS][oO][cC][iI][aA][tT][eE]|[aA][sS][yY][nN][cC][hH][rR][oO][nN][oO][uU][sS]|[bB][aA][cC][kK][sS][pP][aA][cC][eE]|[bB][iI][nN][dD]|[cC][aA][lL][lL]|[cC][aA][sS][eE]|[cC][lL][aA][sS][sS]|[cC][lL][oO][sS][eE]|[cC][oO][mM][mM][oO][nN]|[cC][oO][nN][tT][aA][iI][nN][sS]|[cC][oO][nN][tT][iI][nN][uU][eE]|[cC][yY][cC][lL][eE]|[cC][oO][dD][iI][mM][eE][nN][sS][iI][oO][nN]|[cC][oO][nN][tT][iI][gG][uU][oO][uU][sS]|[cC][rR][iI][tT][iI][cC][aA][lL]|[dD][aA][tT][aA]|[dD][eE][aA][lL][lL][oO][cC][aA][tT][eE]|[dD][eE][fF][eE][rR][rR][eE][dD]|[dD][iI][mM][eE][nN][sS][iI][oO][nN]|[dD][oO]|[eE][lL][sS][eE]|[eE][lL][sS][eE][wW][hH][eE][rR][eE]|[eE][nN][dD]|[eE][nN][dD][fF][iI][lL][eE]|[eE][nN][dD][iI][fF]|[eE][nN][tT][rR][yY]|[eE][qQ][uU][iI][vV][aA][lL][eE][nN][cC][eE]|[eE][xX][iI][tT]|[eE][xX][tT][eE][rR][nN][aA][lL]|[eE][nN][uU][mM]|[eE][nN][uU][mM][eE][rR][aA][tT][oO][rR]|[eE][xX][tT][eE][nN][dD][sS]|[fF][oO][rR][aA][lL][lL]|[fF][iI][nN][aA][lL]|[fF][lL][uU][sS][hH]|[fF][oO][rR][mM][aA][tT]|[fF][uU][nN][cC][tT][iI][oO][nN]|[gG][oO][tT][oO]|[gG][eE][nN][eE][rR][iI][cC]|[iI][mM][pP][oO][rR][tT]|[iI][fF]|[iI][mM][pP][lL][iI][cC][iI][tT]|[iI][nN][qQ][uU][iI][rR][eE]|[iI][nN][tT][rR][iI][nN][sS][iI][cC]|[iI][nN][cC][lL][uU][dD][eE]|[iI][nN][tT][eE][rR][fF][aA][cC][eE]|[iI][nN][tT][eE][nN][tT]|[lL][oO][cC][kK]|[mM][oO][dD][uU][lL][eE]|[nN][oO][pP][aA][sS][sS]|[nN][aA][mM][eE][lL][iI][sS][tT]|[nN][uU][lL][lL][iI][fF][yY]|[oO][pP][eE][nN]|[oO][nN][lL][yY]|[oO][pP][eE][rR][aA][tT][oO][rR]|[oO][pP][tT][iI][oO][nN][aA][lL]|[pP][aA][rR][aA][mM][eE][tT][eE][rR]|[pP][aA][uU][sS][eE]|[pP][rR][iI][nN][tT]|[pP][rR][oO][gG][rR][aA][mM]|[pP][oO][iI][nN][tT][eE][rR]|[pP][rR][iI][vV][aA][tT][eE]|[pP][aA][sS][sS]|[pP][rR][oO][tT][eE][cC][tT][eE][dD]|[pP][rR][oO][cC][eE][dD][uU][rR][eE]|[pP][uU][bB][lL][iI][cC]|[rR][eE][aA][dD]|[rR][eE][tT][uU][rR][nN]|[rR][eE][cC][uU][rR][sS][iI][vV][eE]|[rR][eE][sS][uU][lL][tT]|[rR][eE][wW][iI][nN][dD]|[rR][eE][wW][rR][iI][tT][eE]|[sS][aA][vV][eE]|[sS][tT][oO][pP]|[sS][uU][bB][rR][oO][uU][tT][iI][nN][eE]|[sS][eE][lL][eE][cC][tT]|[sS][eE][qQ][uU][eE][nN][cC][eE]|[sS][uU][bB][mM][oO][dD][uU][lL][eE]|[tT][aA][rR][gG][eE][tT]|[tT][hH][eE][nN]|[uU][sS][eE]|[vV][aA][lL][uU][eE]|[uU][nN][lL][oO][cC][kK]|[vV][oO][lL][aA][tT][iI][lL][eE]|[wW][hH][iI][lL][eE]|[wW][rR][iI][tT][eE]    {
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


{NAME}  {
    pair<string, int> target = {yytext, 1};

        string lowercase_lexeme = yytext;

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            lexeme_token[lowercase_lexeme] = "NAME";

        }

        transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

            return tolower(c);

        });

        lexeme_count[lowercase_lexeme]++;
}

{INT}|{SIGNEDINT}   {
    pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "INT_LITERAL";

        }

        lexeme_count[yytext]++;
}

{REAL}|{SIGNEDREAL} {
    pair<string, int> target = {yytext, 1};

        string lowercase_lexeme = yytext;

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            lexeme_token[lowercase_lexeme] = "REAL_LITERAL";

        }

        transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

            return tolower(c);

        });

        lexeme_count[lowercase_lexeme]++;
}

{LOGICAL}   {
    pair<string, int> target = {yytext, 1};

        string lowercase_lexeme = yytext;

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

                return tolower(c);

            });

            lexeme_token[lowercase_lexeme] = "LOGICAL_LITERAL";

        }

        transform(lowercase_lexeme.begin(), lowercase_lexeme.end(), lowercase_lexeme.begin(), [](unsigned char c) {

            return tolower(c);

        });

        lexeme_count[lowercase_lexeme]++;
}

{STRING}    {
    pair<string, int> target = {yytext, 0};

        if(find(lexemes.begin(), lexemes.end(), target) == lexemes.end()){

            lexemes.push_back(target);

            lexeme_token[yytext] = "CHAR_LITERAL";

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

\"[^\"]*    {
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

