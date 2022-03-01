module lang::\while::dataflow::AvailableExpressionsTest

import lang::\while::dataflow::AvailableExpressions; 
import lang::\while::Syntax; 
import lang::\while::Parser;

import programs::Prog;


test bool killAndGenTest() {

	k1 = kill(stmt(Assignment("x", Add(Var("a"), Var("b")), 1))) == {};
	g1 = gen(stmt(Assignment("x", Add(Var("a"), Var("b")), 1))) == {"a+b"};
	
	k2 = kill(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2))) == {};
	g2 = gen(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2))) == {"a*b"};
	
	k3 = kill(condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3))) == {};
	g3 = gen(condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3))) == {"a+b"};
	
	k4 = kill(stmt(Assignment("a", Add(Var("a"), Num(1)), 4))) == {"a+b", "a*b", "a+1"};
	g4 = gen(stmt(Assignment("a", Add(Var("a"), Num(1)), 4))) == {};
	
	k5 = kill(stmt(Assignment("x", Add(Var("a"), Var("b")), 5))) == {};
	g5 = gen(stmt(Assignment("x", Add(Var("a"), Var("b")), 5))) == {"a+b"};

	return k1 && k2 && k3 && k4 && k5 && g1 && g2 && g3 && g4 && g5; 
}


test bool AvailableExpressionsTestProgTest() {
  WhileProgram p = progProgram();  // take a look at programs::Prog. 
  
  return aeProgTest(p);
}

private bool aeProgTest(WhileProgram p) {
  tuple[map[Label, set[str]] first, map[Label, set[str]] second] res = availableExpressions(p);
  
  map[Label, set[str]] expectedEntry = 
   ( 1 : {}
   , 2 : {"a+b"}
   , 3 : {"a+b"}
   , 4 : {"a+b"}
   , 5 : {} );
  
  map[Label, set[str]] expectedExit = 
   ( 1 : {"a+b"}
   , 2 : {"a+b", "a*b"}
   , 3 : {"a+b"}
   , 4 : {}
   , 5 : {"a+b"} );
  
//  return res.first == expectedEntry ;//&& 
//  return res.second == expectedExit; 
  
  return res.first == expectedEntry && res.second == expectedExit; 
}