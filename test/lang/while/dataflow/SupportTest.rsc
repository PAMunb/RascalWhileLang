module lang::\while::dataflow::SupportTest


import lang::\while::Parser;
import lang::\while::Syntax; 
import lang::\while::CFG;
import programs::Factorial;
import programs::VeryBusyProgram;
import ParseTree; 
import lang::\while::dataflow::Support;

/**
	Tests for non trivial arithmetic expressions
	1. Resolving a variable "v" should be simple.
	2. Resolving "1+2" is non trivial
	3. Resolving "(2*x) + y is also non trivial
*/
test bool testNonTrivialArithmeticExpressions() {
	Exp trivialVar = exp(Var("v"));
	bool b1 = nonTrivialExpression(trivialVar) == {};
	
	Exp nonTrivial1 = exp(Add(Num(1), Num(2)));
	bool b2 = nonTrivialExpression(nonTrivial1) == {nonTrivial1};

	AExp nonTrivial2 = Mult(Num(2),Var("x"));
	Exp nonTrivial3 = exp(Add(nonTrivial2, Var("y")));
	bool b3 = nonTrivialExpression(nonTrivial3) == {nonTrivial3, exp(nonTrivial2)};
	return b1 && b2 && b3;
}

/**
	Tests for non trivial boolean expressions
	1. Resolving "True", "False" and a variable "b" should be simple
	2. Resolving ( 5 + 2 ) > 6 should be non trivial
*/
test bool testNonTrivialBooleanExpressions(){
	Exp bolConstant = exp(True());
	bool b1 = nonTrivialExpression(bolConstant) == {};
	
	AExp addition = Add(Num(5),Num(2));
	Exp bolNonTrivial = exp(Gt(addition, Num(6)));
	bool b2 = nonTrivialExpression(bolNonTrivial) == {exp(addition)};
	return b1 && b2;
}


test bool testFinalLabels() = finalLabels(factorialProgram()) == {6};
test bool getBlockByLabel() = getBlock(6, factorialProgram()) == blockAbstraction(stmt(Assignment("y",Num(0),6)));
