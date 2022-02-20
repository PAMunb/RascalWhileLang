module programs::Factorial

import lang::\while::Syntax; 

BExp b = Gt(Var("y"), Num(1));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("y", Var("x"), 1); 
Stmt s2 = Assignment("z", Num(1), 2); 
Stmt s4 = Assignment("z", Mult(Var("z"), Var("y")), 4);
Stmt s5 = Assignment("y", Sub(Var("y"), Num(1)), 5);
Stmt s6 = Assignment("y", Num(0), 6);

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s6)));

WhileProgram factorial = WhileProgram(stmt);

public WhileProgram factorialProgram(){
	return factorial;
}

public str factorialProgramStr(){
	//return "y := x [1]; z := 1 [2]; while (y \> 1, 3) (z := z * y [4]; y := y - 1 [5]); y := 0 [6]";
	return "y := x [1]; z := 1 [2]; while (y \> 1, 3) z := z * y [4]; y := y - 1 [5]; y := 0 [6]";
}
