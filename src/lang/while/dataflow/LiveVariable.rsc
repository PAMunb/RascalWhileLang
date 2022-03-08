module lang::\while::dataflow::LiveVariable

import lang::\while::Syntax; 
import lang::\while::CFG; 
import programs::\Factorial;

alias Abstraction = set[str];
alias Mapping = map[Label, Abstraction]; 

tuple[Mapping, Mapping] liveVariables(WhileProgram program) { 
	
   Mapping entry = ();
   Mapping exit = (); 
  
   CFG cfg = reverseFlow(program.s);     
   tuple[Mapping, Mapping] res = <entry, exit>; 

   for(Label l <- labels(program.s)) {
     exit[l] = {}; 
     entry[l] = {};
   }
   
   solve(res){
      for(Block b <- blocks(program.s)) {
      	Label target = label(b);
      	//calclv(target);
       	exit[target] = ({} | it + entry[from] | <from, target> <- cfg);       	
        entry[target] = (exit[target] - kill(b)) + gen(b); 
      } 
      res = <entry, exit>;
   }
   return res; 
} 

public Abstraction kill(Block b){
  switch(b) {
    case stmt(Assignment(x, _, _)): return {x};
    default: return {};
  }
}

public Abstraction gen(Block b){
  switch(b) {
    case stmt(Assignment(_, a, _)): return FV(a);
    case condition(Condition b) : return FV(b);
    default: return {};
  }
}

public Abstraction FV(AExp a){
	return {x | /Var(x) <- a};
}

public Abstraction FV(Condition b){
	return {x | /Var(x) <- b};
}

public Abstraction FV(Var(x)) = {x};


