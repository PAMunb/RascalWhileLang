module util::RunICFG

import lang::\while::interprocedural::InterproceduralParser;
import lang::\while::interprocedural::InterproceduralSyntax;
import lang::\while::interprocedural::InterproceduralCFG;
import lang::\while::interprocedural::CallProcedureTransformation;
import lang::\while::CFGUtil;

import programs::Fibonacci;

import vis::Render;
import IO;
import Relation;
import util::Math;
import analysis::graphs::Graph;

public void main(){
	cfgFactorial();
}

public void cfgFactorial(){
	WhileProgram p = fibonacciProgram();
	CFG cfg = flow(p);
	
	println("cfg=<cfg>");
	
	println("CFG=<cfg>");	
	println("carrier=<carrier(cfg)>");
	println("top=<top(cfg)>");
	println("bottom=<bottom(cfg)>");
	println("closure=<cfg+>");
	println("connectedComponents=<connectedComponents(cfg)>");
	
	Graph[str] complete = {<toString(from),toString(to)> | <from,to> <- cfg};
	complete = complete + {<"START",top> | top <- top(complete)};
	complete = complete + {<bottom,"END"> | bottom <- bottom(complete)};
		
	//render(toFigure(cfg));
	render(toFigureComplete(complete)); 

}

private void findStmtByLabel(Label l, WhileProgramProcedural(set[Procedure] d, Stmt s)){

}

