module util::RunCFG

import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::CFGUtil;

import vis::Render;
import IO;
import Relation;
import analysis::graphs::Graph;

BExp b = Gt(Var("y"), Num(1));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("y", Var("x"), 1); 
Stmt s2 = Assignment("z", Num(1), 2); 
Stmt s4 = Assignment("z", Mult(Var("z"), Var("y")), 4);
Stmt s5 = Assignment("y", Sub(Var("y"), Num(1)), 5);
Stmt s6 = Assignment("y", Num(0), 6);

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s6)));

WhileProgram p = WhileProgram(stmt);

public void main(){
	println("labels=<labels(s3)>");

	CFG cfg = flow(p);
	
	println("CFG=<cfg>");	
	println("carrier=<carrier(cfg)>");
	println("top=<top(cfg)>");
	println("bottom=<bottom(cfg)>");
	println("closure=<cfg+>");
	println("connectedComponents=<connectedComponents(cfg)>");
		
	render(toFigure(cfg));
}
