@doc{
   Synopsis: A parser for the while language. 
  
  Description: This module comprises two sub-components:
     * The *concrete* syntax definition
     
     * The parser function, that recognizes a While program 
       and outputs an instance of the abstract-syntax tree.  
}
module lang::\while::Parser

import lang::\while::interprocedural::InterproceduralSyntax;

import ParseTree;
import Node;

start syntax Program 
   = WhileProgramProcedural: "begin" Declaration d StmtSpec s "end." ;
 
syntax Declaration 
  = Procedure: "proc" Identifier name "("  { FormalArgumentSpec ","}* args ")" "is[" Natural ln "]"  StmtSpec stmt "end[" Natural lx "]"
  > right ProcedureSeq: Declaration p1 ";" Declaration p2;

syntax FormalArgumentSpec 
  =  ByValue: "val" Identifier name
  |  ByReference: "res" Identifier name;

syntax StmtSpec 
  = Assignment: Identifier x ":=" AExpSpec exp "[" Natural l "]"
  | Call: "call" Identifier name "("  { AExpSpec ","}* args ")" "[" Natural lc "," Natural lr "]"
  | Return: "return" AExpSpec exp "[" Natural l "]" 
  | Skip: "skip" "[" Natural l "]" 
  | IfThenElse: "if" ConditionSpec c  "then" StmtSpec s1 "else" StmtSpec s2 "end"
  | While: "while" ConditionSpec c  "do" StmtSpec s "end" 
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


// The following comes from the Rascal documentation. 
// 
// see: https://tutor.rascal-mpl.org/Rascal/Rascal.html#/Rascal/Declarations/SyntaxDefinition/SyntaxDefinition.html

lexical Natural 
  = [0-9]+ ;     
  
// layout is lists of whitespace characters
layout MyLayout = [\t\n\ \r\f]*;

// identifiers are characters of lowercase alphabet letters, 
// not immediately preceded or followed by those (longest match)
// and not any of the reserved keywords
lexical Identifier = [a-z] !<< [a-z]+ !>> [a-z] \ MyKeywords;

// this defines the reserved keywords used in the definition of Identifier
keyword MyKeywords = "if" | "then" | "else" | "while" | "skip" | "end" | "return" | "call" | "proc" | "is";


private StmtSpec parse(str txt) = parse(#StmtSpec, txt);
private Stmt implode(StmtSpec s) = delAnnotationsRec(implode(#Stmt, s));

public WhileProgram parse(str txt) = WhileProgram(implode(parse(#StmtSpec, txt)));
//public WhileProgramProcedural parse(str txt) = WhileProgramProcedural(implode(parse(#Program, txt)));
