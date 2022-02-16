module programs::Power

import lang::\while::Syntax; 

BExp b = Gt(Var("x"), Num(0));
Condition c = Condition(b, 2);  

Stmt s1 = Assignment("z", Num(1), 1); 
Stmt s3 = Assignment("z", Mult(Var("z"), Var("y")), 3);
Stmt s4 = Assignment("x", Sub(Var("x"), Num(1)), 4);

Stmt s2 = While(c, Seq(s3, s4)); 

Stmt stmt = Seq(s1, s2);

WhileProgram power = WhileProgram(stmt);

public WhileProgram powerProgram(){
	return power;
}