module lang::\while::ParserTest

import ParseTree; 

import lang::\while::Parser;
import lang::\while::Syntax;
import lang::\while::CFG;

import programs::Factorial;

import Node; 


test bool parseTrue() {
   return implode(#BExp, parse(#BExpSpec, "true")) == True(); 
}

test bool parseFalse() {
   return implode(#BExp, parse(#BExpSpec, "false")) == False(); 
}

test bool parseComplexBoolExp() {
    exp = And(Eq(Var("a"), Var("b")), Not(Gt(Var("b"), Var("d"))));
    return implode(#BExp, parse(#BExpSpec, "a == b && ! b \> d")) == exp;
}

test bool parseNatural() {
   return implode(#AExp, parse(#AExpSpec, "5")) == Num(5); 
}

test bool parseComplexArithmeticExp() {
    exp = Sub(Mult(Var("a"), Var("b")), Var("c"));
    return implode(#AExp, parse(#AExpSpec, "a * b - c")) == exp;
}

test bool parseSkip() {
  s = Skip(1); 
  return implode(#Stmt, parse(#StmtSpec, "skip [1]")) == s; 
}

test bool parseAssignment() {
  s = Assignment("x", Num(5), 3); 
  return implode(#Stmt, parse(#StmtSpec, "x := 5 [3]")) == s; 
}

test bool parseSequence() {
  s1 = Assignment("x", Num(5), 1);
  s2 = Assignment("y", Num(10), 2);
  s3 = Assignment("z", Num(15), 3);
   
  s = implode(#Stmt, parse(#StmtSpec, "x := 5 [1]; y := 10 [2] ; z := 15 [3]"));  
  return implode(#Stmt, parse(#StmtSpec, "x := 5 [1]; y := 10 [2] ; z := 15 [3]")) == Seq(s1, Seq(s2, s3)); 
}

test bool parseIf(){
  i = IfThenElse(Condition(True(), 1), Skip(2), Skip(3));
  s = delAnnotationsRec(implode(#Stmt, parse(#StmtSpec, "if (true, 1) then skip [2] else skip [3] end")));  
  return i == s;
}
