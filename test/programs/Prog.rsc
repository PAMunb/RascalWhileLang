module programs::Prog

import lang::\while::Syntax; 

BExp b = Gt(Var("y"), Add(Var("a"), Var("b")));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("x", Add(Var("a"), Var("b")), 1); 
Stmt s2 = Assignment("y", Mult(Var("a"), Var("b")), 2); 

Stmt s4 = Assignment("a", Add(Var("a"), Num(1)), 4); 
Stmt s5 = Assignment("x", Add(Var("a"), Var("b")), 5); 

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, s3));

WhileProgram prog = WhileProgram(stmt);

public WhileProgram progProgram(){
	return prog;
}

/*
public str progProgramStr(){
	return "y := x [1]; 
	       'z := 1 [2]; 
	       'while (y \> 1, 3) do 
	       '  z := z * y [4]; 
	       '  y := y - 1 [5]
	       'end;  
	       'y := 0 [6]";
}
*/
