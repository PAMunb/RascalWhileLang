module lang::\while::interprocedural::InterproceduralCFG

import lang::\while::interprocedural::InterproceduralSyntax;

import analysis::graphs::Graph;

//extend lang::\while::CFG;

alias CFG = Graph[Label];

//returns the initial label of a statement
public Label init(Stmt s) {
  	switch(s) {
    	case Assignment(_, _, l): return l;
    	case Skip(l): return l;
    	case Seq(s1, _): return init(s1);
    	case IfThenElse(Condition(_, l), _, _): return l; 
    	case While(Condition(_, l), _): return l; 
    	case Call(_, _, lc, _): return lc;
    	case Return(_, l): return l;
  	};
  	return 0;
} 
public Label init(Procedure(_, _, ln, _, _)) = ln;
public Label init(WhileProgram p) = init(p.s);

@doc{
.Synopsis
Returns the set of final labels in a statement.

.Description
Whereas a sequence of statements has a single entry, it may ha ve multiple exits (as for example in the conditional).
}
public set[Label] final(Stmt s){
	switch(s) {
    	case Assignment(_, _, l): return { l };
    	case Skip(l): return { l };
    	case Seq(_, s2): return final(s2);
    	case IfThenElse(_, s1, s2): return final(s1) + final(s2); 
    	case While(Condition(_, l), _): return { l }; 
    	case Call(_, _, _, lr): return { lr };
    	case Return(_, l): return { l };
  	};
	return{};
}
public set[Label] final(Procedure(_, _, _, _, lx)) = { lx };
public set[Label] final(WhileProgram p) = final(p.s);



//return the set of statements, or elementary blocks, of the form of: assignments, skip or conditions
public set[Block] blocks(Stmt s) {
  	switch(s) {
    	case Assignment(_, _, _): return { stmt(s) };
    	case Skip(_): return { stmt(s) };
    	case Seq(s1, s2): return blocks(s1) + blocks(s2);
    	case IfThenElse(c, s1 , s2): return { condition(c) } + blocks(s1) + blocks(s2); 
    	case While(c, s1): return { condition(c) } + blocks(s1); 
    	case c: Call(_, _, _, _): return { stmt(c) };
    	//TODO return
  	}
  	return {}; 
}
//TODO public set[Block] blocks(Procedure(_, _, ln, _, lx)) = { lx };
public set[Block] blocks(WhileProgram p) = blocks(p.s);
public set[Block] blocks(WhileProgramProcedural(d, s)) = blocks(d) + blocks(s);

public set[Block] blocks(list[Procedure] procedures) {
//TODO refatorar
  	set[Block] b = {};
  	for(p <- procedures){
  		b = b + blocks(p.stmt);
  	}
  	return b;
}

public set[Label] labels(Stmt s) = { label(b) | Block b <- blocks(s) };
public set[Label] labels(Call(_, _, lc, lr)) = { lc, lr };
public set[Label] labels(Procedure(_, _, ln, s, lx)) = { ln, lx } + labels(s);

public CFG flow(Stmt s) {
	switch(s) {
    	case Assignment(_, _, _): return { };
    	case Skip(_): return { };
    	case Seq(s1, s2): return flow(s1) + flow(s2) + {<l,init(s2)> | Label l <- final(s1)};
    	case IfThenElse(Condition(_, l), s1, s2): return flow(s1) + flow(s2) + <l,init(s1)> + <l, init(s2)>;
    	case While(Condition(_, l), s1): return flow(s1) + <l,init(s1)> + {<l2,l> | Label l2 <- final(s1)};
    	//TODO case Call(name, _, lc, lr): {};
    	//TODO return
  	};
	return {};
}
public CFG flow(Procedure(_, _, ln, s, lx)) = <ln,init(s)> + flow(s) + { <l,lx> | Label l <- final(s)};

public CFG flow(WhileProgram p) = flow(p.s);
//TODO public CFG flow(WhileProgramProcedural(d, s)) = flow(s);

public CFG reverseFlow(Stmt s) = {<to,from> | <from,to> <- flow(s)};
public CFG reverseFlow(CFG cfg) = {<to,from> | <from,to> <- cfg};
public CFG reverseFlow(WhileProgram p) = reverseFlow(flow(p));


/* TODO
private Procedure findProcedureBySignature(str name, list[FormalArgument] args, WhileProgramProcedural(d, s)){
	for(p <- d){
  		if(p.name == name && p.args == args){
  			return p;
  		}
  	}
  	return null;
}*/