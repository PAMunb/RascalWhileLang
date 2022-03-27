module lang::\while::interprocedural::InterproceduralSemanticsTest

import lang::\while::interprocedural::InterproceduralSemantics;
import lang::\while::Parser;
import lang::\while::interprocedural::InterproceduralSyntax;
import lang::\while::interprocedural::InterproceduralCFG;
import IO;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Tests for a very basic program, without any procedure:
					"begin 
	               'x := 1001 [1] 
	               'end."
*/
public WhileProgram basicProgram() {
	WhileProgram basic = WhileProgramProcedural({},Assignment("x", Num(1001), 1));
	return basic;
}

public WhileProgram basicProgramFromStr() {
	//TODO This is throwing "ambiguity" error... check later
	str basicStr = "begin 
	               'x := 1001 [1] 
	               'end.";
	return parseProgram(basicStr);
}

public test bool testBasicProgram() {
	resetLocations();
	program = basicProgram();
	configuration = run(program);
	return (configuration == Terminal(("x":1),(1:1001)));
}

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Test for a simple program with a very simple procedure definition
			"begin 
			'proc p(val x, res r) is[1] 
			'	r := x + 1 [2];
			'	return r [3]
			'end[4]
			'y := -1 [5];
			'call p(0,y) [6,7] 
			'end."
*/
public WhileProgram basicProcedureProgram() {
	Stmt s2 = Assignment("r",Add(Var("x"),Num(1)),2);
	Stmt s3 = Return(Var("r"), 3);
	Procedure d1 = Procedure("p",[ByValue("x"),ByReference("r")],1, Seq(s2, s3), 4);
	Stmt s5 = Assignment("y",Num(-1),5);
	Stmt s6 = Call("p",[Num(9999),Var("y")],6,7);
	prog = WhileProgramProcedural({d1},Seq(s5, s6));
	return prog;
}
public WhileProgram basicProcedureProgramFromStr() {
	//TODO this is throwing Parser Error - check later
	//TODO check later return syntax with the presence of byRef arguments
	str s =	"begin 
			'proc p(val x, res r) is[1] 
			'	r := x + 1 [2];
			'	return r [3]
			'end[4]
			'y := -1 [5];
			'call p(9999,y) [6,7] 
			'end.";
	program = parseProgram(s);
	return program;
}
public test bool testBasicProcedureProgram() {
	resetLocations();
	program = basicProcedureProgram();
	configuration = run(program);
	return configuration == Terminal(("y":1),(1:10000));
}

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Tests for a recursive and more complex program (fibonacci)
			"begin 
	       'proc fib(val z, val u, res v) is[1]
	       '  if (z \< 3, 2) 
	       '    then 
	       '      v := u + 1 [3] 
	       '    else 
	       '      call fib(z-1,u,v) [4,5] ; 
	       '      call fib(z-2,v,v) [6,7] 
	       '  end
	       'end[8]
	       'call fib(x,0,y) [9,10]
	       'end.";
*/

public WhileProgram fibonacciNumber(){
	Stmt c45 = Call("fib",[Sub(Var("z"),Num(1)),Var("j")],4,5);
	Stmt c67 = Call("fib",[Sub(Var("z"),Num(2)),Var("k")],6,7);
	Stmt s3 = Assignment("v",Num(1),3);
	Stmt s8 = Assignment("v",Add(Var("j"), Var("k")),8);
	Stmt s2 = IfThenElse(Condition(Lt(Var("z"),Num(3)),2), s3, Seq(c45, Seq(c67, s8)));
	Procedure fib = Procedure("fib",[ByValue("z"),ByReference("v")],1,s2,9);
	Stmt c = Call("fib",[Num(8),Var("y")],10,11);
	WhileProgram fibonacci = WhileProgramProcedural({fib},c);
	return fibonacci;
}

public WhileProgram fibonacciNumberFromStr() {
	str s ="begin 
	       'proc fib(val z, res v) is[1]
	       '  if (z \< 3, 2) 
	       '    then 
	       '      v := 1 [3] 
	       '    else 
	       '      call fib(z-1,j) [4,5] ; 
	       '      call fib(z-2,k) [6,7] ;
	       '      v := j+k [8];
	       '  end
	       'end[9]
	       'call fib(8,y) [10,11]
	       'end.";
	return parseProgram(s);	       
}
//TODO parsing problem
public bool testFibonacciParser() {
	return fibonacciNumberFromStr() == fibonacciNumber();
}

public test bool testFibonnaci() {
	resetLocations();
	program = fibonacciNumber();
	configuration = run(program);
	return configuration == Terminal(("y":2),(2:21));
}