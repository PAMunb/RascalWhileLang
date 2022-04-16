module lang::\while::ifds::SuperCFG

extend lang::\while::interprocedural::InterproceduralCFG;

import lang::\while::interprocedural::InterproceduralSyntax;
import util::Math;
import IO;

data CallId = CallId(int id)
			  |EmptyCallId();

data Edge = BasicEdge(Label from, Label to)
			| CallEdge(Label from, Label to, CallId cid)
			| ReturnEdge(Label from, Label to);
			
alias SuperCFG = rel[Edge];

int callCounter = 0;

public CallId allocateCall() {
	callCounter = callCounter + 1;
	
	return CallId(callCounter);
}

public SuperCFG sflow(Assignment(_, _, _)) = { };
public SuperCFG sflow(Skip(_)) = { };
public SuperCFG sflow(Seq(s1, s2)) = sflow(s1) + sflow(s2) + {<BasicEdge(l,init(s2))> | Label l <- final(s1)};
public SuperCFG sflow(IfThenElse(Condition(_, l), s1, s2)) = sflow(s1) + sflow(s2) + <BasicEdge(l, init(s1))> + <BasicEdge(l, init(s2))>;
public SuperCFG sflow(While(Condition(_, l), s1)) = sflow(s1) + <BasicEdge(l, init(s1))> + {<BasicEdge(l2,l)> | Label l2 <- final(s1)};

public SuperCFG sflow(c:Call(_, _, lc, lr)) {
	CallId callId = allocateCall();
	return {<CallEdge(lc, c@proc.ln, callId)>, <CallEdge(c@proc.lx, lr, callId)>, <ReturnEdge(lc,lr)>};
}
public SuperCFG sflow(Procedure(_, _, ln, s, lx)) {
	return <BasicEdge(ln, init(s))> + sflow(s) + { <BasicEdge(l, lx)> | Label l <- final(s)};
}
public SuperCFG sflow(set[Procedure] d) = ({} | it + sflow(p) | p <- d);
public SuperCFG sflow(WhileProgramProcedural(d, s)) {
	callCounter = 0;
	return sflow(d) + sflow(s);
}
