module lang::\while::interprocedural::InterproceduralParserTest

import ParseTree; 

import lang::\while::interprocedural::InterproceduralParser;
import lang::\while::interprocedural::InterproceduralSyntax;
import lang::\while::interprocedural::InterproceduralCFG;

import programs::Fibonacci;

import Node; 

test bool parseReturn() {
  s = Return(Var("x"), 1); 
  return implode(#Stmt, parse(#StmtSpec, "return x [1]")) == s; 
}

test bool parseCall() {
  expected = Call("p",[Var("a"), Var("z")], 1, 2); 
  s1 = delAnnotationsRec(implode(#Stmt, parse(#StmtSpec, "call p(a,z) [1,2]")));
  return s1 == expected;
}

test bool parseFormalArgument(){
  a = ByValue("a");
  z = ByReference("z"); 
  cond1 = delAnnotationsRec(implode(#FormalArgument,parse(#FormalArgumentSpec, "val a"))) == a;
  cond2 = delAnnotationsRec(implode(#FormalArgument,parse(#FormalArgumentSpec, "res z"))) == z;
  return cond1 && cond2;
}

test bool parseProcedure() {
  expected = Procedure("p",[ByValue("a"), ByReference("z")], 1, Skip(3), 2); 
  s1 = delAnnotationsRec(implode(#Procedure, parse(#Declaration, "proc p(val a, res z) is[1] skip [3] end[2]")));
  return s1 == expected;
}

test bool parseProcedureNoArgs() {
  expected = Procedure("p",[], 1, Skip(3), 2); 
  s1 = delAnnotationsRec(implode(#Procedure, parse(#Declaration, "proc p() is[1] skip [3] end[2]")));
  return s1 == expected;
}

test bool parseProgram(){
  d = Procedure("p",[], 1, Skip(3), 2);
  s = Skip(4); 
  expected = WhileProgramProcedural({d},s);
  program = delAnnotationsRec(implode(#WhileProgram, parse(#Program, "begin proc p() is[1] skip [3] end[2] skip [4] end.")));
  return program == expected;
}

test bool parseFibonacci(){  
  program = parseProgram(fibonacciProgramStr());  
  return fibonacciProgram() == program;
}
