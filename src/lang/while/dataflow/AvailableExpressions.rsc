module lang::\while::dataflow::AvailableExpressions

import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;

alias Mapping = map[Label, set[Exp]];

public set[Exp] killAE(Block b, WhileProgram prog){
	return kill(b, prog);
} 

public set[Exp] genAE(Block b) {
  	switch(b) {
  		case stmt(Assignment(str x, AExp a, _)): return ( {} | it + expr | expr <- nonTrivialExpression(exp(a)), !expHasVariable(x, expr) );
  		case condition(Condition(BExp b, Label _)): return nonTrivialExpression(exp(b));
  		default: return {};
  	}
}

tuple[Mapping, Mapping] availableExpressions(WhileProgram program) { 
   Mapping entry = ();
   Mapping exit = ();
 
   CFG cfg = flow(program.s); 
   
   for(Label l <- labels(program.s)) {
     exit[l] = {}; 
   }
    
   tuple[Mapping, Mapping] res = <entry, exit>; 
   
   solve(res) {  
      for(Block b <- blocks(program.s)) {
       	Label target = label(b);

		set[Exp] killB = killAE(b, program);
       	set[Exp] genB = genAE(b);
       	
		if(({} | it + exit[from] | <from, target> <- cfg, from > target) != {}){
	  		entry[target] = ({} | it + exit[from] | <from, target> <- cfg, from < target) & ({} | it + exit[from] | <from, target> <- cfg, from > target);
		} else {
  			entry[target] = ({} | it + exit[from] | <from, target> <- cfg, from < target);
  		}
       	exit[target] = (entry[target] - killB) + genB; 
      }
       
      res = <entry, exit>;
   }  
   return res; 
} 