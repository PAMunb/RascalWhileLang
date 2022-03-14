module lang::\while::dataflow::Support

import lang::\while::Syntax; 
import lang::\while::CFG;

import List; 

import util::Maybe;

public set[AExp] nonTrivialExpression(WhileProgram program) = ({} | it + nonTrivialExpression(exp) | /AExp exp <- program);

public set[AExp] nonTrivialExpression(BExp e)= ({} | it + nonTrivialExpression(exp) | /AExp exp <- e);

public set[AExp] nonTrivialExpression(AExp e) {
   set[AExp] res = {}; 
   top-down visit(e) {
   	 case a: Add(_, _) : res = a + res; 
   	 case s: Sub(_, _) : res = s + res; 
   	 case m: Mult(_, _): res = m + res; 
   }
   return res;  
} 

public bool expHasVariable(str x, AExp e) = size([ x | /Var(x) <- e]) > 0;

public Maybe[Block] getBlock(Label l, WhileProgram program) {
	top-down visit(program) {
	  case a: Assignment(str _, AExp _, Label label): if(label == l) return just(stmt(a)); 
	  case s: Skip(label): if(label == l) return just(stmt(s)); 
	  case c: Condition(_, label): if(label == l) return just(condition(c)); 
	}
	return nothing();
} 
