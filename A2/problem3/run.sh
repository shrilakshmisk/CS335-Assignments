bison -d parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c -lfl
./a.exe < input.txt
