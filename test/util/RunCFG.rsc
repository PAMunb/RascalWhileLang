module util::RunCFG

import lang::\while::CFG;
import lang::\while::CFGUtil;

import programs::Factorial;
import programs::Fibonacci;
import programs::Power;

import vis::Render;
import IO;
import Relation;
import analysis::graphs::Graph;

public void main(){
	//CFG cfg = flow(factorialProgram());
	CFG cfg = flow(fibonacciProgram());
	//CFG cfg = flow(powerProgram());
	
	
	println("CFG=<cfg>");	
	println("carrier=<carrier(cfg)>");
	println("top=<top(cfg)>");
	println("bottom=<bottom(cfg)>");
	println("closure=<cfg+>");
	println("connectedComponents=<connectedComponents(cfg)>");
		
	render(toFigure(cfg));
}
