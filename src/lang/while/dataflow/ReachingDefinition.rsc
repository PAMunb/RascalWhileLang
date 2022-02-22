module lang::\while::dataflow::ReachingDefinition

import lang::\while::Syntax; 
import lang::\while::CFG; 

            
alias Abstraction = set[tuple[str, Label]];  
alias Mapping = map[Label, Abstraction]; 


tuple[Mapping, Mapping] reachingDefinition(WhileProgram program) { 
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
        entry[target] = ({} | it + exit[from] | <from, target> <- cfg);
       	exit[target] = (entry[target] - kill(b, entry[target])) + gen(b); 
      } 
      res = <entry, exit>;
   }  
   return res; 
} 


public Abstraction kill(Block b, Abstraction entry) {
  switch(b) {
    case stmt(Assignment(x, _, _)): return {<v, l> | <v, l> <- entry, v == x};
    default: return {};
  }
}

public Abstraction gen(Block b) {
  switch(b) {
    case stmt(Assignment(x, _, l)): return { <x, l> };
    default: return {};
  }
} 





