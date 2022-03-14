module lang::\while::dataflow::AvailableExpressionsTest

import lang::\while::dataflow::AvailableExpressions; 
import lang::\while::dataflow::Support; 
import lang::\while::Syntax; 
import lang::\while::Parser;
import ParseTree;

import programs::Prog;
import programs::Factorial;

// import IO;

public Exp parseExp(str x) {
	return exp(implode(#AExp, parse(#AExpSpec, x)));
}

test bool testKill() {
	Block assignZ = stmt(Assignment("z",Num(0),4));
	WhileProgram facProg = factorialProgram();
	
	set[Exp] generated = killAE(assignZ, facProg);
	set[Exp] expected = {exp(Mult(Var("z"),Var("y")))};
	
	// println(generated);
	
	return generated == expected;
}

test bool testGenCond(){
	Block cond = condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3));
	set[Exp] generated = genAE(cond);
	set[Exp] expected = {exp(Add(Var("a"),Var("b")))};
	// println(generated);
	return generated == expected;
}

test bool testGenInc(){
	Block increment = stmt(Assignment("a", Add(Var("a"), Num(1)), 4));
	set[Exp] generated = genAE(increment);
	set[Exp] expected = {};
	// println(generated);
	return generated == expected;
}

test bool testGenAssign() = genAE(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2))) == { exp(Mult(Var("a"), Var("b"))) };

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
  
//  return res.first == expectedEntry ;//&& 
//  return res.second == expectedExit; 
  
  return res.genEntry == expectedEntry && res.genExit == expectedExit; 
}
