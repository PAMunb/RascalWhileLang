module lang::\while::interprocedural::ICFGTest

import lang::\while::interprocedural::InterproceduralSyntax; 
import lang::\while::interprocedural::InterproceduralCFG;


Stmt c1 = Call("fib",[Sub(Var("z"),Num(1)),Var("u"),Var("v")],4,5);



//TODO terminar testes
test bool initCall() = init(c1) == 4;

test bool blocksCall() = blocks(c1) == {stmt(c1)};	
