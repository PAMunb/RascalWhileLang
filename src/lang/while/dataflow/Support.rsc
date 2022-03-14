module lang::\while::dataflow::Support

import lang::\while::Syntax; 
import lang::\while::CFG;

data BlockAbstraction = blockAbstraction(Block b)|Empty();
data Exp = exp(BExp b)|exp(AExp a);
                      
public set[Exp] nonTrivialExpression(Exp e) {
	switch(e) {
		case exp(Var(str _)): return {}; //trivial
		case exp(Num(int _)): return {}; //trivial
		case exp(Add(AExp a1, AExp a2)): return {e} + nonTrivialExpression(exp(a1))+nonTrivialExpression(exp(a2));
		case exp(Sub(AExp a1, AExp a2)): return {e} + nonTrivialExpression(exp(a1))+nonTrivialExpression(exp(a2));
		case exp(Mult(AExp a1, AExp a2)): return {e} + nonTrivialExpression(exp(a1))+nonTrivialExpression(exp(a2));
		case exp(Eq(AExp a1, AExp a2)): return nonTrivialExpression(exp(a1))+nonTrivialExpression(exp(a2));
		case exp(Gt(AExp a1, AExp a2) ): return nonTrivialExpression(exp(a1))+nonTrivialExpression(exp(a2));
		
		//PPA page 39: "(..) For clarity, we will  concentrate on arithmetic expressions (..)"
		case exp(Not(BExp b)): return nonTrivialExpression(exp(b));
		case exp(And(BExp b1, BExp b2)): return nonTrivialExpression(exp(b1))+nonTrivialExpression(exp(b2));
		case exp(Or(BExp b1, BExp b2)): return nonTrivialExpression(exp(b1))+nonTrivialExpression(exp(b2));
	}
	return {};
}

public bool expHasVariable(str x, Exp e){
	switch(e){
		case exp(Var(str v)): return v == x;
		case exp(Num(int _)): return false;
		case exp(Add(AExp a1, AExp a2)): return expHasVariable(x, exp(a1))||expHasVariable(x, exp(a2));
		case exp(Sub(AExp a1, AExp a2)): return expHasVariable(x, exp(a1))||expHasVariable(x, exp(a2));
		case exp(Mult(AExp a1, AExp a2)): return expHasVariable(x, exp(a1))||expHasVariable(x, exp(a2));
		case exp(Not(BExp b)): return  expHasVariable(x, exp(b));
		case exp(And(BExp b1, BExp b2)): return expHasVariable(x, exp(b1))||expHasVariable(x, exp(b2));
		case exp(Or(BExp b1, BExp b2)): return expHasVariable(x, exp(b1))||expHasVariable(x, exp(b2));
		case exp(Eq(AExp a1, AExp a2)): return expHasVariable(x, exp(a1))||expHasVariable(x, exp(a2));
		case exp(Gt(AExp a1, AExp a2) ): return expHasVariable(x, exp(a1))||expHasVariable(x, exp(a2));
	}
	return false;
}

public BlockAbstraction getBlock(Label l, WhileProgram program) {
	for(Block b <- blocks(program.s)) {
		switch(b){
			case stmt(Assignment(str _, AExp _, Label label)): {
				if(label == l) {
					return blockAbstraction(b);
				}
			}
			case stmt(Skip(label)): {
				if(label == l) {
					return blockAbstraction(b);
				}
			}
			case condition(Condition(_, label)): {
				if(label == l) {
					return blockAbstraction(b);
				}
			}
		}
	}
	return Empty();
}

public set[Label] finalLabels(Stmt stmt){
	switch(stmt){
		case Assignment(str _, AExp _, Label l): return {l};
		case Skip(Label l): return {l};
		case Seq(Stmt _, Stmt s2): return finalLabels(s2);
		case IfThenElse(Condition _, Stmt s1, Stmt s2): return finalLabels(s1) + finalLabels(s2);
		case While(Condition(_, l), Stmt _): return {l};
	}
	return {};
}

public set[Label] finalLabels(WhileProgram program){
	return finalLabels(program.s);
}

public set[Exp] kill(Block b, WhileProgram program) {
	switch(b) {
  		case stmt(Assignment(str x, AExp _, _)): return ( {} | it + exp | exp <- allNonTrivialExpressions(program), expHasVariable(x, exp) );
  		case stmt(Skip(Label _)): return {};
  		case condition(Condition(BExp _, Label _)): {};
	}
  	return {};
}

public set[Exp] gen(Block b) {
  	switch(b) {
  		case stmt(Assignment(_, AExp a, _)): return nonTrivialExpression(exp(a));
  		case condition(Condition(BExp b, Label _)): return nonTrivialExpression(exp(b));
  		case stmt(Skip(Label _)): return {};
  	}
  	return {};
}

public set[Exp] allNonTrivialExpressions(WhileProgram program) = ({} | it + gen(b) | Block b <- blocks(program.s));

