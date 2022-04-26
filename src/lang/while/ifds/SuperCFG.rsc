module lang::\while::ifds::SuperCFG

extend lang::\while::interprocedural::InterproceduralCFG;

import analysis::graphs::LabeledGraph;
import lang::\while::interprocedural::InterproceduralSyntax;
 
 
data EdgeType = BasicEdge() 
              | CallEdge(int id) 
              | ReturnEdge(int id);

			
alias SuperCFG = LGraph[Label, EdgeType];

int callCounter = 0;

public int allocateCall() {
	callCounter = callCounter + 1;
	return callCounter;
}

public SuperCFG sflow(Assignment(_, _, _)) = { };
public SuperCFG sflow(Skip(_)) = { };
public SuperCFG sflow(Seq(s1, s2)) = sflow(s1) + sflow(s2) + {<l,BasicEdge(), init(s2)> | Label l <- final(s1)};
public SuperCFG sflow(IfThenElse(Condition(_, l), s1, s2)) = sflow(s1) + sflow(s2) + <l, BasicEdge(), init(s1)> + <l, BasicEdge(), init(s2)>;
public SuperCFG sflow(While(Condition(_, l), s1)) = sflow(s1) + <l, BasicEdge(), init(s1)> + {<l2,BasicEdge(),l> | Label l2 <- final(s1)};

public SuperCFG sflow(c:Call(_, _, lc, lr)) = { <lc, CallEdge(lc), c@proc.ln>, <c@proc.lx, ReturnEdge(lc), lr>, <lc, BasicEdge(), lr> };


public SuperCFG sflow(Procedure(_, _, ln, s, lx)) {
	return <ln, BasicEdge(), init(s)> + sflow(s) + { <l, BasicEdge(), lx> | Label l <- final(s)};
}

public SuperCFG sflow(set[Procedure] d) = ({} | it + sflow(p) | p <- d);

public SuperCFG sflow(WhileProgramProcedural(d, s)) {
	callCounter = 0;
	return sflow(d) + sflow(s);
}
