module lang::\while::dataflow::framework::LiveVariableMFP


import lang::\while::dataflow::framework::MFP;
import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;
import IO;

public set[str] init(WhileProgram program) {
	return {};
}

public set[str] bottom(){
	return {};
}

public set[str] kill(Block b, WhileProgram program) {
	switch(b) {
    	case stmt(Assignment(x, _, _)): return {x};
    	default: return {};
  	}
}

public set[str] gen(Block b) {
	switch(b) {
    	case stmt(Assignment(_, a, _)): return FV(a);
    	case condition(Condition b) : return FV(b);
    	default: return {};
  	}
}

public AbstractMFP[str] lvMFP() {
	return AbstractMFP( Backward(), 
						set[str] (Block b) { return gen(b); },
						set[str] (Block b, WhileProgram program) { return kill(b, program);},
						set[str] (WhileProgram program) { return init(program); },
						set[str] () { return bottom();},
						Union());
}

public set[str] FV(AExp a){
	return {x | /Var(x) <- a};
}

public set[str] FV(Condition b){
	return {x | /Var(x) <- b};
}

public set[str] FV(Var(x)) = {x};
