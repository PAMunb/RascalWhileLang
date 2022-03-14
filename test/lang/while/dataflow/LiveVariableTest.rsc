module lang::\while::dataflow::LiveVariableTest

import IO;
import lang::\while::dataflow::LiveVariable;
import lang::\while::Syntax; 
import lang::\while::Parser;
import programs::Factorial;

str example = "x:=2 [1]; y:=4 [2]; x:=1 [3]; if (y\>x, 4) then z:=y [5] else z:=y*y[6] end; x:=z[7]";


test bool killTest() {
  b1 = kill(stmt(Skip(4))) == {}; 
  b2 = kill(stmt(Assignment("y", Num(4), 5))) == {"y"};
  b3 = kill(condition(Condition(True(),1))) == {};
  b4 = kill(stmt(Assignment("y", Var("z"), 5))) == {"z"};
  
  return b1 && b2 && b3 && !b4; 
}

test bool genTest() {
  b1 = gen(stmt(Skip(4))) == {}; 
  b2 = gen(stmt(Assignment("y", Add(Var("x"), Var("z")), 5))) == {"x","z"};
  b3 = gen(condition(Condition(Gt(Var("x"), Num(3)),1))) == {"x"};
  b4 = gen(stmt(Assignment("y", Num(1), 5))) == {};
  b5 = gen(stmt(Assignment("y", Num(1), 5))) == {"y"};
  b6 = gen(stmt(Assignment("x",Var("z"),7))) == {"z"};
  
  return b1 && b2 && b3 && b4 && !b5 && b6; 
}

test bool FVTest() {
	b1 = FV(Add(Var("x") , Var("z"))) == {"x","z"};
	b2 = FV(Add(Var("x") , Mult(Var("z"), Sub(Var("y"),Num(5))))) == {"x","z","y"};
	b3 = FV(Mult(Num(2), Num(5))) == {};
	b4 = FV(Var("x")) == {"x"};
	b5 = FV(Condition(Gt(Var("x"), Num(3)),1)) == {"x"};
	
	return b1 && b2 && b3 && b4 && b5;
}

test bool lvFactorialWhileTest() {
  WhileProgram p = factorialProgram();  // take a look at programs::Factorial. 
  
  return lvFactorialTest(p);
}

private bool lvFactorialTest(WhileProgram p) {
  tuple[Mapping first, Mapping second] res = liveVariables(p); 
    
  Mapping expectedEntry = 
   ( 1 : {"x"}
   , 2 : {"y"}
   , 3 : {"y","z"}
   , 4 : {"y","z"}
   , 5 : {"y","z"}
   , 6 : {} ); 
  
  Mapping expectedExit = 
   ( 1 : {"y"}
   , 2 : {"y","z"}
   , 3 : {"y","z"}
   , 4 : {"y","z"}
   , 5 : {"y","z"}
   , 6 : {} ); 
  
  return res.first == expectedEntry && res.second == expectedExit; 
}