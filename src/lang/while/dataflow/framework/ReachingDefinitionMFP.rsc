module lang::\while::dataflow::framework::ReachingDefinitionMFP

import lang::\while::dataflow::framework::MFP;
import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;

alias Abstraction = tuple[str, Label]; 

public set[Abstraction] init(WhileProgram _) {
	return {};
}

public set[Abstraction] bottom(){
	return {};
}

public set[Abstraction] kill(Block b, WhileProgram _) {
  	switch(b) {
  		//TODO solve this bug later:
  		//Notice that we used "entry" in kill. Should we keep this?
    	//case stmt(Assignment(x, _, _)): return {<v, l> | <v, l> <- entry, v == x};
    	default: return {};
  	}
}

public set[Abstraction] gen(Block b) {
	switch(b) {
    	case stmt(Assignment(x, _, l)): return { <x, l> };
    	default: return {};
  	}
}

public AbstractMFP[Abstraction] rdMFP() {
	return AbstractMFP( Forward(), 
						set[Abstraction] (Block b) { return gen(b); },
						set[Abstraction] (Block b, WhileProgram program) { return kill(b, program);},
						set[Abstraction] (WhileProgram program) { return init(program); },
						set[Abstraction] () { return bottom();},
						Union());
}