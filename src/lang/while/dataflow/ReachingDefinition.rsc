module lang::\while::dataflow::ReachingDefinition

import lang::\while::Syntax; 
import lang::\while::CFG; 

alias Abstraction = set[tuple[str, Label]]; // rel[str, Label] 
alias Mapping = map[Label, Abstraction]; 

Mapping entry = ();
Mapping exit = ();

tuple[Mapping, Mapping] reachingDefinition(WhileProgram program) { 
   bool fixed = false; 

   CFG cfg = flow(program.s); 
   
   //init
   for(Label l <- labels(program.s)) {
     exit[l] = {}; 
   }
 
   while(!fixed) {   // TODO: replace the while with a solve. 
      Mapping entryOld = entry; 
   	  Mapping exitOld = exit; 
     
      for(Block b <- blocks(program.s)) {
       	Label l1 = label(b); 
        entry[l1] = ({} | it + exit[l2] | Label l2 <- labels(program.s), <l2, l1> in cfg);
       	exit[l1] = (entry[l1] - kill(b, entry[l1])) + gen(b); 
      } 
      fixed = (entryOld == entry) && (exitOld == exit); 
   }  
   return <entry, exit>; 
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





