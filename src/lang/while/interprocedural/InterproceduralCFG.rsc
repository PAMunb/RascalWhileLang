module lang::\while::interprocedural::InterproceduralCFG

import lang::\while::interprocedural::InterproceduralSyntax;


extend lang::\while::CFG;


//returns the initial label of a statement
public Label init(Call(_, _, lc, _)) = lc;
//public Label init(Return(_, l)) = l;
public Label init(Procedure(_, _, ln, _, _)) = ln;


@doc{
.Synopsis
Returns the set of final labels in a statement.

.Description
Whereas a sequence of statements has a single entry, it may ha ve multiple exits (as for example in the conditional).
}
public set[Label] final(Call(_, _, _, lr)) = { lr };
//public set[Label] final(Return(_, l)) = { l };
public set[Label] final(Procedure(_, _, _, _, lx)) = { lx };


//return the set of statements, or elementary blocks, of the form of: assignments, skip or conditions
public set[Block] blocks(c: Call(_, _, _, _)) = { stmt(c) };
public set[Block] blocks(Procedure(_, _, ln, s, lx)) = { entryProc(ln) , exitProc(lx)  } + blocks(s);
public set[Block] blocks(WhileProgramProcedural(d, s)) = blocks(d) + blocks(s);
public set[Block] blocks(set[Procedure] d) = ({} | it + blocks(p) | p <- d);

public set[Label] labels(Call(_, _, lc, lr)) = { lc, lr };
public set[Label] labels(Procedure(_, _, ln, s, lx)) = { ln, lx } + labels(s);
public set[Label] labels(WhileProgramProcedural(d, s)) = labels(d) + labels(s);
public set[Label] labels(set[Procedure] d) = ({} | it + labels(p) | p <- d);

public CFG flow(c:Call(_, _, lc, lr)) = { <lc,c@proc.ln>, <c@proc.lx,lr> };
public CFG flow(Procedure(_, _, ln, s, lx)) = <ln,init(s)> + flow(s) + { <l,lx> | Label l <- final(s)};
public CFG flow(set[Procedure] d) = ({} | it + flow(p) | p <- d);
public CFG flow(WhileProgramProcedural(d, s)) = flow(d) + flow(s);
/*
public void interFlow(p: WhileProgramProcedural(d, s)){
	{ | c: \Call(_, _, Label lc, Label lr)};
}*/
