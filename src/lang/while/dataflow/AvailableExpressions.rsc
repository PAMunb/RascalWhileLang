module lang::\while::dataflow::AvailableExpressions

import lang::\while::Syntax; 
import lang::\while::CFG;
import lang::\while::dataflow::Support;

alias Mapping = map[Label, set[AExp]];

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

		if(target == init(program.s)) {
			entry[target] = {};
		}
		else {
			entry[target] = (nonTrivialExpression(program) | it & exit[source] | <source, target> <- cfg );
		}	
       	exit[target] = (entry[target] - kill(b, program)) + gen(b); 
      }
       
      res = <entry, exit>;
   }  
   return res; 
} 