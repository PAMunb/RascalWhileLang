module lang::\while::dataflow::AvailableExpressionsTest

import lang::\while::dataflow::AvailableExpressions; 
import lang::\while::dataflow::Support; 
import lang::\while::Syntax; 
import lang::\while::Parser;
import ParseTree;

import programs::Prog;
import programs::Factorial;

public AExp parseExp(str x) {
	return implode(#AExp, parse(#AExpSpec, x));
}

test bool testKill() {
	Block assignZ = stmt(Assignment("z",Num(0),4));
	WhileProgram facProg = factorialProgram();
	
	set[AExp] generated = kill(assignZ, facProg);
	set[AExp] expected = {Mult(Var("z"),Var("y"))};
	return generated == expected;
}

test bool testGenCond(){
	Block cond = condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3));
	set[AExp] generated = gen(cond);
	set[AExp] expected = {Add(Var("a"),Var("b"))};
	
	return generated == expected;
}

test bool testGenInc(){
	Block increment = stmt(Assignment("a", Add(Var("a"), Num(1)), 4));
	set[AExp] generated = gen(increment);
	set[AExp] expected = {};
	return generated == expected;
}

test bool testGenAssign() = gen(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2))) == { Mult(Var("a"), Var("b")) };

test bool testAvailableExpressionProgram() {
  WhileProgram p = progProgram();  // take a look at programs::Prog. 
  
  return aeProgTest(p);
}

private bool aeProgTest(WhileProgram p) {
  tuple[Mapping genEntry, Mapping genExit] res = availableExpressions(p);
  
  Mapping expectedEntry = 
   ( 1 : {}
   , 2 : {parseExp("a+b")}
   , 3 : {parseExp("a+b")}
   , 4 : {parseExp("a+b")}
   , 5 : {} );
  
  Mapping expectedExit = 
   ( 1 : {parseExp("a+b")}
   , 2 : {parseExp("a+b"), parseExp("a*b")}
   , 3 : {parseExp("a+b")}
   , 4 : {}
   , 5 : {parseExp("a+b")} );
    
  return res.genEntry == expectedEntry && res.genExit == expectedExit; 
}
