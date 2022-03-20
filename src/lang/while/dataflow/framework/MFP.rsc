module lang::\while::dataflow::framework::MFP

import lang::\while::Syntax;
import lang::\while::CFG;
import lang::\while::dataflow::Support;

data Direction = Forward() 
                      | Backward(); 
                      
data MeetOperator = Union()
                  | Intersection();                       
                      
alias Mapping[&A] = map[Label, set[&A]];                       

data AbstractMFP[&A] = AbstractMFP(Direction direction, 
                                  set[&A] (Block) gen, 
                                  set[&A] (Block, WhileProgram) kill,
                                  set[&A] (WhileProgram) init, 
                                  set[&A] () bottom,
                                  MeetOperator operator);
                                  
                                  
CFG constructCFG(Forward(), WhileProgram p) = flow(p);
CFG constructCFG(Backward(), WhileProgram p) = reverseFlow(p);

set[&A] meet(Union(), set[&A] l, set[&A] r) = l + r;  
set[&A] meet(Intersection(), set[&A] l, set[&A] r) = l & r;  



public tuple[Mapping[&A] entry, Mapping[&A] exit] solveMFP(AbstractMFP[&A] a, WhileProgram program) {
	Mapping[&A] set2 = ();
	Mapping[&A] set1 = ();

	for( Label l <- labels(program.s) ) {
		set2[l] = {};
		set1[l] = {};
	}
	
	CFG cfg = constructCFG(a.direction, program);
	
	Mapping[&A] genSet = ();
	Mapping[&A] killSet = ();
	for( Block block <- blocks(program) ) {
		l1 = label(block); 
		genSet[l1] = a.gen(block);
		killSet[l1] = a.kill(block, program);
	}
	
	entryPoints = a.direction == Forward() ? {init(program.s)}: final(program.s);
	
	tuple[Mapping[&A], Mapping[&A]] res = <set1, set2>;
	
	solve(res) {
		for( Block block <- blocks(program) ) {
			l1 = label(block); 
			
			if(l1 in entryPoints) {
			  	set1[l1] = {};
			} else {
			  	set1[l1] = (a.init(program) | meet(a.operator, it , set2[l2]) | <l2, l1> <- cfg);
			}	
			
			set2[l1] = (set1[l1] - killSet[l1]) + genSet[l1];
			res = <set1, set2>;
		}
	}
	if(a.direction == Forward()){	
		return <set1, set2>;
	} else {
		return <set2, set1>;
	}
}
