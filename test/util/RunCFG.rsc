module util::RunCFG

import lang::\while::CFG;
import lang::\while::CFGUtil;

import programs::Factorial;
import programs::Power;
import programs::NestedIf;

import vis::Render;
import IO;
import Relation;
import util::Math;
import analysis::graphs::Graph;

public void main(){
	cfgFactorial();
}

public void cfgFactorial(){
	CFG cfg = flow(factorialProgram());
	//CFG cfg = flow(powerProgram());
	
	
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

public void cfgNestedIf(){
	CFG cfg = flow(nestedIfProgram());
	
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
