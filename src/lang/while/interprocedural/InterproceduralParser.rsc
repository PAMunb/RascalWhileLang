module lang::\while::interprocedural::InterproceduralParser

import lang::\while::interprocedural::InterproceduralSyntax;
import lang::\while::interprocedural::CallProcedureTransformation;

import ParseTree;
import Node;

extend lang::\while::Parser;

start syntax Program 
   = WhileProgramProcedural: "begin" { Declaration ";"}* d StmtSpec s "end." ;
 
syntax Declaration 
  = Procedure: "proc" Identifier name "("  { FormalArgumentSpec ","}* args ")" "is[" Natural ln "]"  StmtSpec stmt "end[" Natural lx "]";

syntax FormalArgumentSpec 
  =  ByValue: "val" Identifier name
  |  ByReference: "res" Identifier name;
  
syntax StmtSpec 
  = Call: "call" Identifier name "("  { AExpSpec ","}* args ")" "[" Natural lc "," Natural lr "]"
  | Return: "return" AExpSpec exp "[" Natural l "]" 
  ;
  
private StmtSpec parse(str txt) = parse(#StmtSpec, txt);
private Stmt implode(StmtSpec s) = delAnnotationsRec(implode(#Stmt, s));

public WhileProgram parseProgram(str txt) = processProcedureLabels(delAnnotationsRec(implode(#WhileProgram, parse(#Program, txt))));

  