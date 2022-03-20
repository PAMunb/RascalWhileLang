module lang::\while::dataflow::framework::AvailableExpressionMFP


import lang::\while::dataflow::framework::MFP;
import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;


public set[AExp] init(WhileProgram program) {
	return nonTrivialExpression(program);
}

public set[AExp] bottom(){
	return {};
}

public set[AExp] kill(Block b, WhileProgram program) {
  	switch(b) {
    	case stmt(Assignment(str x, _, _)): return ( { } | it + expr | expr <- nonTrivialExpression(program), expHasVariable(x, expr) ); 
    	default: return {}; 
  	}
}

public set[AExp] gen(Block b) {
  	switch(b) {
  		case stmt(Assignment(str x, AExp a, _)): return ( {} | it + expr | expr <- nonTrivialExpression(a), !expHasVariable(x, expr) );
  		case condition(Condition(BExp b, Label _)): return nonTrivialExpression(b);
  		default: return {};
  	}
}

public AbstractMFP[AExp] aeMFP() {
	return AbstractMFP( Forward(), 
						set[AExp] (Block b) { return gen(b); },
						set[AExp] (Block b, WhileProgram program) { return kill(b, program);},
						set[AExp] (WhileProgram program) { return init(program); },
						set[AExp] () { return bottom();},
						Intersection());
}