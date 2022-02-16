module programs::NestedIf

import lang::\while::Syntax;
import lang::\while::CFG;

Stmt s1 = Assignment("p", Num(0), 1);

BExp b1 = Gt(Var("p"), Num(1000));
Condition c1 = Condition(b1, 2);
BExp b2 = Gt(Var("p"), Num(100));
Condition c2 = Condition(b2, 4);

Stmt s3 = Assignment("p", Num(2), 3);
Stmt s5 = Assignment("p", Num(1), 5);
Stmt s6 = Skip(6);
Stmt s4 = IfThenElse(c2, s5, s6);
Stmt s2 = IfThenElse(c1, s3, s4);

Stmt stmt = Seq(s1, s2);

WhileProgram nestedIf = WhileProgram(stmt);

test bool nestedIfStmt() = flow(stmt) == {<1,2>,<2,3>,<2,4>,<4,5>,<4,6>};

public WhileProgram nestedIfProgram(){
	return nestedIf;
}



/*
public void option(int num) {
	[1] int p = 0;

	if [2](num > 1000) {
		[3] p = 2;
	} else {
		if [4](num > 100) {
			[5]p = 1;
		} else {
			[6]//skip
		}
	}
	
}*/