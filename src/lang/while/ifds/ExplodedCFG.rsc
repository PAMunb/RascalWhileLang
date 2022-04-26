module lang::\while::ifds::ExplodedCFG

import lang::\while::Syntax; 

import lang::\while::ifds::SuperCFG;

import analysis::graphs::Graph;

import lang::\while::interprocedural::InterproceduralSyntax;

alias SuperEdge = tuple[Label from, EdgeType et, Label target];

data Vertice = Zero()
                 | Vertice(Abstraction v); 
                
alias ExplodedCFG = map[SuperEdge, Graph[Vertice]];                 
                
alias Abstraction = tuple[str, Label];  // fixed for ReachingDefinitions
alias Domain = set[Abstraction];   // fixed for ReachingDefinitions

map[SuperEdge, Graph[Vertice]] explodedCFG(WhileProgram p) = ( k : v | <k, v> <- [explodeEdge(e, p) | e <- sflow(p)]);
	

tuple[SuperEdge, Graph[Vertice]] explodeEdge(SuperEdge edge, WhileProgram p) {
	switch(edge.et) {
	  case BasicEdge():  return explodeBasicEdge(edge, p);
	  case CallEdge(_): return <edge, {}>; 
	  case ReturnEdge(_): return <edge, {}>; 
	}
	return <edge, {}>;
} 

tuple[SuperEdge, Graph[Vertice]] explodeBasicEdge(SuperEdge edge, WhileProgram p) {
	list[Block] blocks = findBlock(edge.from, p);
	  
	switch(blocks) {
		case [b] : return explodeBasicEdge(edge, b, p); 
		default: return <edge, {}>;        // TODO: should we throw an exception? This might never happen. 
	}	
}

tuple[SuperEdge, Graph[Vertice]] explodeBasicEdge(SuperEdge edge, Block b, WhileProgram p) {
   universe = { <x, l> | /Assignment(x, _, l) <- p }; 
   genSet = gen(b);
   killSet = kill(b, universe); 
   
   g = { <Zero(), Zero()> } + 
       { <Zero(), Vertice(target)> | target <- genSet} + 
       { <Vertice(n), Vertice(n)> | n <- universe, ! (n in genSet), ! (n in killSet)};; 
   
   return <edge, g>;
}

list[Block] findBlock(Label l, WhileProgram p) = [b | b <- blocks(p), label(b) == l]; 
 
set[Abstraction] flowFunction(Block b, set[Abstraction] inSet, set[Abstraction] universe) = (inSet - kill(b, universe)) + gen(b); 

// fixed for ReachingDefinitions

set[Abstraction] gen(Block b) {
  switch(b) {
    case stmt(Assignment(x, _, l)) : return { <x, l> }; // TODO: deal with call and return statement 
    default: return {}; 
  } 
}

// fixed for ReachingDefinitions

set[Abstraction] kill(Block b, set[Abstraction] universe) {
  switch(b) {
    case stmt(Assignment(x, _, _)) : return { <var, label> | <var, label> <- universe, var == x }; //TODO: deal with call and return statement
    default: return {}; 
  }
} 
