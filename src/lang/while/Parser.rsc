@doc{
   Synopsis: A parser for the while language. 
  
  Description: This module comprises two sub-components:
     * The *concrete* syntax definition
     
     * The parser function, that recognizes a While program 
       and outputs an instance of the abstract-syntax tree.  
}
module lang::\while::Parser

import lang::\while::Syntax;

import ParseTree;
import Node;


start syntax StmtSpec 
  = Assignment: Identifier x ":=" AExpSpec exp "[" Natural l "]" 
  | Skip: "skip" "[" Natural l "]" 
  | IfThenElse: "if" ConditionSpec c  "then" StmtSpec s1 "else" StmtSpec s2
  | While: "while" ConditionSpec c  StmtSpec s
  //| bracket Seq: "(" StmtSpec s1 ";" StmtSpec s2")"
  > right Seq: StmtSpec s1 ";" StmtSpec s2
  ;

syntax ConditionSpec = Condition: "(" BExpSpec b "," Natural l ")"; 

syntax AExpSpec 
  = Var: Identifier x
  | Num: Natural num
  | left Mult: AExpSpec a1 "*" AExpSpec a2
  > left ( Add : AExpSpec a1 "+" AExpSpec a2 
         | Sub : AExpSpec a1 "-" AExpSpec a2
         )
  ;

syntax BExpSpec 
   = True: "true"
   | False: "false"
   | Not: "!" BExpSpec
   | left Eq : AExpSpec "==" AExpSpec
   > left Gt : AExpSpec "\>"  AExpSpec
   > left And: BExpSpec b1 "&&" BExpSpec b2
   > left Or : BExpSpec b1 "||" BExpSpec b2  
   ; 

lexical Natural 
  = [0-9]+ ;     
  
// layout is lists of whitespace characters
layout MyLayout = [\t\n\ \r\f]*;

// identifiers are characters of lowercase alphabet letters, 
// not immediately preceded or followed by those (longest match)
// and not any of the reserved keywords
lexical Identifier = [a-z] !<< [a-z]+ !>> [a-z] \ MyKeywords;

// this defines the reserved keywords used in the definition of Identifier
keyword MyKeywords = "if" | "then" | "else" | "while" | "skip";


private StmtSpec parse(str txt) = parse(#StmtSpec, txt);
private Stmt implode(StmtSpec s) = delAnnotationsRec(implode(#Stmt, s));

public WhileProgram parse(str txt) = WhileProgram(implode(parse(#StmtSpec, txt)));
