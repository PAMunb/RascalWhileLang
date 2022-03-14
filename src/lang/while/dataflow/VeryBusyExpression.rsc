module lang::\while::dataflow::VeryBusyExpression

import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;

public set[Exp] genByLabel(Label l, WhileProgram program){
	set[Exp] res = {};
	BlockAbstraction bAbstraction = getBlock(l, program);
	switch(bAbstraction){
		case blockAbstraction(Block b): res = gen(b);
	}
	return res;
}

public set[Exp] killByLabel(Label l, WhileProgram program){
	set[Exp] res = {};
	BlockAbstraction bAbstraction = getBlock(l, program);
	switch(bAbstraction){
		case blockAbstraction(Block b): res = kill(b, program);
	}
	return res;
}

alias Mapping = map[Label, set[Exp]];

public tuple[Mapping, Mapping] veryBusyExpression(WhileProgram program) {
	Mapping entry = ();
	Mapping exit = ();
	set[Label] programFinalLabels = finalLabels(program);
	set[Exp] allNonTrivial = allNonTrivialExpressions(program);
	for( Label l <- labels(program.s) ) {
		entry[l] = {};
		exit[l] = {};
	}
	tuple[Mapping, Mapping] res = <entry, exit>;
	solve(res) {
		for( Label label <- labels(program.s) ) {
			set[Exp] generated = genByLabel(label, program);
			set[Exp] killed = killByLabel(label, program);
			
			//exit if ℓ final(S*)
			if(label in programFinalLabels) {
				exit[label] = {};
			} else {
				//exit (ℓ',ℓ) E flowR(S*)
				for(<target, label> <- reverseFlow(program.s)) {
					exit[label] = allNonTrivial & entry[target];
				}
			}
			
			//entry
			entry[label] = (exit[label] - killed) + generated;
			res = <entry, exit>;
		}
	}
	return res;
}