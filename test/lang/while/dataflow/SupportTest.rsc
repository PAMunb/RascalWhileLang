module lang::\while::dataflow::SupportTest


import lang::\while::Parser;
import lang::\while::Syntax; 
import lang::\while::CFG;
import programs::Factorial;
import programs::VeryBusyProgram;
import lang::\while::dataflow::Support;

import util::Maybe; 

/**
	Tests for non trivial arithmetic expressions
	1. Resolving a variable "v" should be simple.
	2. Resolving "1+2" is non trivial
	3. Resolving "(2*x) + y is also non trivial
*/
test bool testNonTrivialArithmeticExpressions() {
	trivialVar = Var("v");
	bool b1 = nonTrivialExpression(trivialVar) == {};
	
	nonTrivial1 = Add(Num(1), Num(2));
	bool b2 = nonTrivialExpression(nonTrivial1) == {nonTrivial1};
	
	nonTrivial2 = Mult(Num(2),Var("x"));
	nonTrivial3 = Add(nonTrivial2, Var("y"));
	bool b3 = nonTrivialExpression(nonTrivial3) == {nonTrivial3, nonTrivial2};
	
	return b1 && b2 && b3;
}

/**
	Tests for non trivial boolean expressions
	1. Resolving "True", "False" and a variable "b" should be simple
	2. Resolving ( 5 + 2 ) > 6 should be non trivial
*/
test bool testNonTrivialBooleanExpressions(){
	bolConstant = True();
	bool b1 = nonTrivialExpression(bolConstant) == {};
	
	AExp addition = Add(Num(5),Num(2));
	bolNonTrivial = Gt(addition, Num(6));
	bool b2 = nonTrivialExpression(bolNonTrivial) == {addition};
	return b1 && b2;
}


test bool testFinalLabels() = finalLabels(factorialProgram()) == {6};
test bool getBlockByLabel() = getBlock(6, factorialProgram()) == just(stmt(Assignment("y",Num(0),6)));
