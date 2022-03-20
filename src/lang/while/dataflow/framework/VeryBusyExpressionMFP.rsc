module lang::\while::dataflow::framework::VeryBusyExpressionMFP

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
  		case stmt(Assignment(str x, AExp _, _)): return ( {} | it + exp | exp <- nonTrivialExpression(program), expHasVariable(x, exp) );
  		case stmt(Skip(Label _)): return {};
  		case condition(Condition(BExp _, Label _)): {};
	}
  	return {};
}

public set[AExp] gen(Block b) {
  	switch(b) {
  		case stmt(Assignment(_, AExp a, _)): return nonTrivialExpression(a);
  		case stmt(Skip(Label _)): return {};
  		case condition(Condition(BExp b, Label _)): return nonTrivialExpression(b);
  	}
  	return {};
}

public AbstractMFP[AExp] vbMFP() {
	return AbstractMFP( Backward(), 
						set[AExp] (Block b) { return gen(b); },
						set[AExp] (Block b, WhileProgram program) { return kill(b, program);},
						set[AExp] (WhileProgram program) { return init(program); },
						set[AExp] () { return bottom();},
						Intersection());
}