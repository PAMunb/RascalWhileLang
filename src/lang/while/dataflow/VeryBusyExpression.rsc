module lang::\while::dataflow::VeryBusyExpression

import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;

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

alias Mapping = map[Label, set[AExp]];

public tuple[Mapping, Mapping] veryBusyExpression(WhileProgram program) {
	Mapping entry = ();
	Mapping exit = ();

	for( Label l <- labels(program.s) ) {
		entry[l] = {};
		exit[l] = {};
	}
	
	CFG cfg = reverseFlow(program);
	
	tuple[Mapping, Mapping] res = <entry, exit>;
	
	solve(res) {
		for( Block block <- blocks(program) ) {
			l1 = label(block); 
			
			if(l1 in final(program.s)) {
			  exit[l1] = {};
			}
			else {
			  exit[l1] = (nonTrivialExpression(program) | it & entry[l2] | <l2, l1> <- cfg);
			}	
			
			entry[l1] = (exit[l1] - kill(block, program)) + gen(block);
			res = <entry, exit>;
		}
	}
	return res;
}