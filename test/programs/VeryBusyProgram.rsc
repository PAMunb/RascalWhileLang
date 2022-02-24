module programs::VeryBusyProgram


import lang::\while::Syntax;
import lang::\while::CFG;
import lang::\while::Parser;



public WhileProgram veryBusyProgram(){
	BExp b1 = Gt(Var("a"), Var("b"));
	Condition c1 = Condition(b1, 1);
	Stmt s2 = Assignment("x", Sub(Var("b"), Var("a")), 2);
	Stmt s3 = Assignment("y", Sub(Var("a"), Var("b")), 3);
	Stmt s4 = Assignment("y", Sub(Var("b"), Var("a")), 4);
	Stmt s5 = Assignment("x", Sub(Var("a"), Var("b")), 5);
	Stmt s1 = IfThenElse(c1, Seq(s2, s3), Seq(s4, s5));

	WhileProgram program = WhileProgram(s1);
	return program;
}

public WhileProgram veryBusyProgramFromStr(){
	return parse("if ( a\>b, 1) then
				 '	x := b-a [2];
				 ' 	y := a-b [3]
				 'else
				 '	y := b-a [4];
				 '  x := a-b [5]
				 'end"); 
}

test bool veryBusyParser() = veryBusyProgram() == veryBusyProgramFromStr();


