%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<bits/stdc++.h>
#include <fstream>
using namespace std;
extern int yylineno;
extern string yytext;
extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char *s);

int question_count = 0, singleselect_count = 0, multiselect_count = 0;
int choice_count = 0, correct_count = 0, total_marks = 0, choice_count_question = 0, error_line = 0, error_opening = 0, error_closing = 0;
int marks_distribution[8] = {0}; // From 1 to 8 marks
stack<pair<string, int>> st; 

void fun(){
    cout<<"Number of questions: "<<question_count<<"\n";
    cout<<"Number of singleselect questions: "<<singleselect_count<<"\n";
    cout<<"Number of multiselect questions: "<<multiselect_count<<"\n";
    cout<<"Number of answer choices: "<<choice_count<<"\n";
    cout<<"Number of correct answers: "<<correct_count<<"\n";
    cout<<"Total marks: "<<total_marks<<"\n";
    cout<<"Number of 1 marks questions: "<<marks_distribution[0]<<"\n";
    cout<<"Number of 2 marks questions: "<<marks_distribution[1]<<"\n";
    cout<<"Number of 3 marks questions: "<<marks_distribution[2]<<"\n";
    cout<<"Number of 4 marks questions: "<<marks_distribution[3]<<"\n";
    cout<<"Number of 5 marks questions: "<<marks_distribution[4]<<"\n";
    cout<<"Number of 6 marks questions: "<<marks_distribution[5]<<"\n";
    cout<<"Number of 7 marks questions: "<<marks_distribution[6]<<"\n";
    cout<<"Number of 8 marks questions: "<<marks_distribution[7]<<"\n";
}

%}

%union {
  struct{
    int token_count;
    char str[1000];
    int lineno;
  } attr;
  int type_count;
}

%token<attr> NEWLINE
%token<attr> BLANK
%token<attr> LESSER_THAN_SLASH
%token<attr> LESSER_THAN
%token<attr> GREATER_THAN
%token<attr> EQUAL
%token<attr> DOUBLE_QUOTE
%token<attr> MARKS_
%token<attr> MARKS
%token<attr> SLASH
%token<attr> QUIZ
%token<attr> SINGLESELECT
%token<attr> MULTISELECT
%token<attr> CHOICE
%token<attr> CORRECT
%token<attr> DIGIT
%token<attr> INTEGER




%%
quiz:
  quiz_start questions quiz_end //garbage outside quiz tags should be ignored
;

questions:
  %empty
| question questions 
;

question:
  singleselect       {question_count++;}
| multiselect        {question_count++;}
;

singleselect:
  singleselect_start choicecorrect singleselect_end {singleselect_count++; choice_count_question = 0; 
                                                    //yylineno = error_line;
                                                    } 
                                                 
;

multiselect:
  multiselect_start choicecorrect multiselect_end   {multiselect_count++; choice_count_question = 0; 
                                                    //yylineno = error_line;
                                                    }
;

choicecorrect:
  %empty 
| choice choicecorrect      {}
| correct choicecorrect     {}

;

choice: //this is fine
  choice_start choice_end { 
                        if(choice_count_question >= 4){
                         // yylineno = error_line;
                         
                           cout<<"Error: More than 4 choices; Parent tag line number = "<<error_line<<"\n";
                           fun();
                           exit(1);
                        }
                        choice_count++; choice_count_question++;
                        }
// | LESSER_THAN newlineblank CHOICE newlineblank GREATER_THAN newlineblank           {
//   cout<<"Error: Stray opening tag <"<< "choice" <<"> at line number = "<<($1).lineno<<"\n";
//   fun();
//   exit(1);
// }
// | LESSER_THAN_SLASH newlineblank CHOICE newlineblank GREATER_THAN newlineblank   {
//   cout<<"Error: Stray closing tag <"<< "choice" <<"> at line number = "<<($1).lineno<<"\n";
//   fun();
//   exit(1);
// }
;

correct: //this is fine
  correct_start correct_end {correct_count++;}
;

choice_start:
  LESSER_THAN newlineblank CHOICE newlineblank GREATER_THAN newlineblank {
      if(st.top().first == "multiselect" || st.top().first == "singleselect"){
        st.push({"choice", ($1).lineno});
      }
      // else{
      //   cout<<"Error: Stray opening tag <"<< st.top().first <<"> at line number = "<<st.top().second<<"\n";
      //   fun();
      //   exit(1);
      // }
    }
;

choice_end:
  LESSER_THAN_SLASH newlineblank CHOICE newlineblank GREATER_THAN newlineblank {
      if(st.top().first == "choice"){
        st.pop();
      }
      // else{
      //   cout<<"Error: Stray closing tag </choice> at line number = "<<($1).lineno<<"\n";
      //   fun();
      //   exit(1);
      // }
  }
;

correct_start:
  LESSER_THAN newlineblank CORRECT newlineblank GREATER_THAN newlineblank {
    if(st.top().first == "multiselect" || st.top().first == "singleselect"){
      st.push({"correct", ($1).lineno});
    }
    // else{
    //   cout<<"Error: Stray opening tag <"<< st.top().first <<"> at line number = "<<st.top().second<<"\n";
    //   fun();
    //   exit(1);
    // }
  }
;

correct_end:
  LESSER_THAN_SLASH newlineblank CORRECT newlineblank GREATER_THAN newlineblank  {
    if(st.top().first == "correct"){
      st.pop();
    }
    // else{
    //   cout<<"Error: Stray closing tag </correct> at line number = "<<($1).lineno<<"\n";
    //   fun();
    //   exit(1);
    // }
  }
;

quiz_start: 
  LESSER_THAN newlineblank QUIZ newlineblank GREATER_THAN newlineblank {
    if(st.empty()){
      st.push({"quiz", ($1).lineno});
    }
  }
;

quiz_end:
  LESSER_THAN_SLASH newlineblank QUIZ newlineblank GREATER_THAN newlineblank  {
    if(st.top().first == "quiz"){
      st.pop();
    }
    // else{
    //   cout<<"Error: Stray closing tag </quiz> at line number = "<<($1).lineno<<"\n";
    //   fun();
    //   exit(1);
    // }
  }
;

singleselect_start:
  LESSER_THAN newlineblank SINGLESELECT newlineblank MARKS_ newlineblank EQUAL newlineblank DOUBLE_QUOTE newlineblank INTEGER newlineblank DOUBLE_QUOTE newlineblank GREATER_THAN newlineblank {//check INTEGER is in range
                                                                                                                                                error_opening = ($1).lineno;
                                                                                                                                                error_line = ($1).lineno;
                                                                                                                                                if(st.top().first == "quiz"){
                                                                                                                                                  st.push({"singleselect", ($1).lineno});
                                                                                                                                                }
                                                                                                                                                // else{
                                                                                                                                                //   cout<<"Error: Stray opening tag <"<< st.top().first <<"> at line number = "<<st.top().second<<"\n";
                                                                                                                                                //   fun();
                                                                                                                                                //   exit(1);
                                                                                                                                                // }
                                                                                                                                                // cout<<"h1: "<<error_line<<"\n";
                                                                                                                                                //yylineno = error_line;
                                                                                                                                                int marks = stoi(($11).str);
                                                                                                                                                if (marks == 1 || marks == 2){
                                                                                                                                                  total_marks += marks;
                                                                                                                                                  marks_distribution[marks - 1]++;
                                                                                                                                                }
                                                                                                                                                else{
                                                                                                                                                  cout<<"Error: Single correct invalid marks; Parent tag line number = "<<error_line<<"\n";
                                                                                                                                                  fun();
                                                                                                                                                  exit(1);
                                                                                                                                                }

                                                                                                                                                
                                                                                                                                                
                                                                                                                                            }
| LESSER_THAN newlineblank SINGLESELECT newlineblank MARKS_ newlineblank EQUAL newlineblank INTEGER newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}

| LESSER_THAN newlineblank SINGLESELECT newlineblank MARKS_ newlineblank EQUAL newlineblank DOUBLE_QUOTE newlineblank INTEGER newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}

| LESSER_THAN newlineblank SINGLESELECT newlineblank MARKS_ newlineblank EQUAL newlineblank INTEGER newlineblank DOUBLE_QUOTE newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}
                                                                                                                                            
;

singleselect_end:
  LESSER_THAN_SLASH newlineblank SINGLESELECT newlineblank GREATER_THAN newlineblank {  //cout<<"h2"<<"\n";

                                                                                error_opening = 0; error_closing = ($1).lineno;

                                                                                if(st.top().first == "singleselect"){
                                                                                  st.pop();
                                                                                }
                                                                                // else{
                                                                                //   cout<<"Error: Stray closing tag </quiz> at line number = "<<($1).lineno<<"\n";
                                                                                //   fun();
                                                                                //   exit(1);
                                                                                // }

                                                                                if (choice_count_question < 3){
                                                                                //yylineno = error_line;
                                                                                cout<<"Error: Less than 3 choices; Parent tag line number = "<<error_line<<"\n";
                                                                                fun();
                                                                                exit(1);
                                                                            }
                                                                            
                                                                          }
;

multiselect_start:
  LESSER_THAN newlineblank MULTISELECT newlineblank MARKS_ newlineblank EQUAL newlineblank DOUBLE_QUOTE newlineblank INTEGER newlineblank DOUBLE_QUOTE newlineblank GREATER_THAN newlineblank {//check INTEGER is in range
                                                                                                                                                if(st.top().first == "quiz"){
                                                                                                                                                  st.push({"multiselect", ($1).lineno});
                                                                                                                                                }
                                                                                                                                                error_opening = ($1).lineno;
                                                                                                                                                error_line = ($1).lineno;
                                                                                                                                                //yylineno = error_line;
                                                                                                                                                int marks = stoi(($11).str);
                                                                                                                                                if (marks >= 2 && marks <= 8){
                                                                                                                                                  total_marks += marks;
                                                                                                                                                  marks_distribution[marks - 1]++;
                                                                                                                                                }
                                                                                                                                                else{
                                                                                                                                                  cout<<"Error: Multi correct invalid marks; Parent tag line number = "<<error_line<<"\n";
                                                                                                                                                  fun();
                                                                                                                                                  exit(1);
                                                                                                                                                }
                                                                                                                                                
                                                                                                                                            }
| LESSER_THAN newlineblank MULTISELECT newlineblank MARKS_ newlineblank EQUAL newlineblank INTEGER newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}

| LESSER_THAN newlineblank MULTISELECT newlineblank MARKS_ newlineblank EQUAL newlineblank DOUBLE_QUOTE newlineblank INTEGER newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}

| LESSER_THAN newlineblank MULTISELECT newlineblank MARKS_ newlineblank EQUAL newlineblank INTEGER newlineblank DOUBLE_QUOTE newlineblank GREATER_THAN newlineblank {
  cout<<"Error: Marks not enclosed in double quotes; Parent tag line number = "<<($1).lineno<<"\n";
                                                                                fun();
                                                                                exit(1);
}                                                                                                                                          
;

multiselect_end:
  LESSER_THAN_SLASH newlineblank MULTISELECT newlineblank GREATER_THAN newlineblank {if (choice_count_question < 3){
                                                                                //yylineno = error_line;
                                                                                if(st.top().first == "multiselect"){
                                                                                  st.pop();
                                                                                }
                                                                                error_opening = 0; error_closing = ($1).lineno;
                                                                                cout<<"Error: Less than 3 choices; Parent tag line number = "<<error_line<<"\n";
                                                                                fun();
                                                                                exit(1);
                                                                            }
                                                                          }
;

// ignoretag:
// LESSER_THAN newlineblank GREATER_THAN newlineblank
// | LESSER_THAN_SLASH newlineblank GR

// ignoretag:
// LESSER_THAN newlineblank GREATER_THAN newlineblank
// | LESSER_THAN_SLASH newlineblank GREATER_THAN newlineblank
// | %empty
// ;

newlineblank:
  %empty
| NEWLINE newlineblank
| BLANK newlineblank
;


// ;
%%



int main(){
    
    yyin = fopen("input.txt", "r");
    
    yyparse();
    cout<<"Number of questions: "<<question_count<<"\n";
    cout<<"Number of singleselect questions: "<<singleselect_count<<"\n";
    cout<<"Number of multiselect questions: "<<multiselect_count<<"\n";
    cout<<"Number of answer choices: "<<choice_count<<"\n";
    cout<<"Number of correct answers: "<<correct_count<<"\n";
    cout<<"Total marks: "<<total_marks<<"\n";
    cout<<"Number of 1 marks questions: "<<marks_distribution[0]<<"\n";
    cout<<"Number of 2 marks questions: "<<marks_distribution[1]<<"\n";
    cout<<"Number of 3 marks questions: "<<marks_distribution[2]<<"\n";
    cout<<"Number of 4 marks questions: "<<marks_distribution[3]<<"\n";
    cout<<"Number of 5 marks questions: "<<marks_distribution[4]<<"\n";
    cout<<"Number of 6 marks questions: "<<marks_distribution[5]<<"\n";
    cout<<"Number of 7 marks questions: "<<marks_distribution[6]<<"\n";
    cout<<"Number of 8 marks questions: "<<marks_distribution[7]<<"\n";

}

void yyerror(const char *s){

    // if(error_opening != 0){ // make it an array to report the tag later
    //     cout<<"Error: Stray opening tag at line number: "<<error_opening<<"\n";
    // }  
    if(st.empty() || st.size()==1){
      cout<<"Error at line number: "<<yylineno<<"\n"; 
    }
    else{
      string last_token = yylval.attr.str;
    string popped_text = st.top().first;
    int popped_line = st.top().second;
    st.pop();
    if(st.top().first == last_token){cout << "Error: opening stray tag <"<< popped_text <<"> at line number: "<< popped_line << "\n"; }
    else{
      cout << "Error: closing stray tag </"<< last_token <<"> at line number: "<< yylineno << "\n"; 
    }
    }
    
    // cout << "Error: closing tag at line number: "<< yylineno << "\n";
    
    
    // exit(1);
}
