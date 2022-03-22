module programs::Fibonacci

import lang::\while::interprocedural::InterproceduralSyntax;

Procedure fib = Procedure("fib",[ByValue("z"),ByReference("v")],1,
	IfThenElse(Condition(Lt(Var("z"),Num(3)),2),
		Assignment("v",Add(Var("u"),Num(1)),3),
	Seq(Call("fib",[Sub(Var("z"),Num(1)),Var("u"),Var("v")],4,5),
		Call("fib",[Sub(Var("z"),Num(2)),Var("v"),Var("v")],6,7))),8);

Stmt c = Call("fib",[Var("x"),Num(0),Var("y")],9,10);

WhileProgram fibonacci = WhileProgramProcedural([fib],c);

public WhileProgram fibonacciProgram(){
	return fibonacci;
}

public str fibonacciProgramStr(){
	return "begin 
	       'proc fib(val z, res v) is[1]
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
}