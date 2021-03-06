module lang::\while::dataflow::VeryBusyExpressionTest

import lang::\while::Parser;
import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::VeryBusyExpression;
import programs::Factorial;
import programs::VeryBusyProgram;
import ParseTree; 
import lang::\while::dataflow::Support;
import IO;


test bool genWithSubInAssignment() = gen(stmt(Assignment("y",Sub(Var("y"),Num(1)),5))) == {(Sub(Var("y"),Num(1)))};
test bool genWithMultInAssignment() = gen(stmt(Assignment("z",Mult(Var("z"),Var("y")),4))) == {(Mult(Var("z"),Var("y")))};
test bool killZVariableInFactorialProg() = kill(stmt(Assignment("z",Num(0),4)), factorialProgram()) == {(Mult(Var("z"),Var("y")))};

/*
	Tests for all non trivial expressions in a program
*/
test bool testExpInProgram() {
	WhileProgram program = factorialProgram();
	bool b1 = nonTrivialExpression(program) == {(Sub(Var("y"),Num(1))),(Mult(Var("z"),Var("y")))};
	return b1;
}

 
public AExp parseExp(str x) {
	return implode(#AExp, parse(#AExpSpec, x));
}

test bool testVeryBusyExpression(){
	tuple[Mapping, Mapping] expected = <(
		1:{parseExp("a - b"), parseExp("b - a")},
		2:{parseExp("a - b"), parseExp("b - a")},
		3:{parseExp("a - b")},
		4:{parseExp("a - b"), parseExp("b - a")},
		5:{parseExp("a - b")}
	),(
		1:{parseExp("a - b"), parseExp("b - a")},
		2:{parseExp("a - b")},
		3:{},
		4:{parseExp("a - b")},
		5:{}
	)>;
	return veryBusyExpression(veryBusyProgram()) == expected;
}
