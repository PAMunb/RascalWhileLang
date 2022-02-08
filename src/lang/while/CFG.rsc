module lang::\while::CFG

import lang::\while::Syntax; 

public Label init(Stmt s) {
  switch(s) {
    case Assignment(_, _, l): return l;
    case Skip(l): return l;
    case Seq(s1, _): return init(s1);
    case IfThenElse(Condition(_, l), _, _): return l; 
    case While(Condition(_, l), _): return l; 
  };
  return 0;
} 


public set[Block] blocks(Stmt s) {
  switch(s) {
    case Assignment(_, _, _): return { stmt(s) };
    case Skip(_): return { stmt(s) };
    case Seq(s1, s2): return blocks(s1) + blocks(s2);
    case IfThenElse(c, s1 , s2): return { condition(c) } + blocks(s1) + blocks(s2); 
    case While(c, s): return {condition(c)} + blocks(s); 
  }
  return {}; 
}

public set[Label] labels(Stmt s) = { label(b) | Block b <- blocks(s) };


BExp b = Gt(Var("y"), Num(1));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("y", Var("x"), 1); 
Stmt s2 = Assignment("z", Num(1), 2); 
Stmt s4 = Assignment("z", Mult(Var("z"), Var("y")), 4);
Stmt s5 = Assignment("y", Sub(Var("y"), Num(1)), 5);
Stmt s6 = Assignment("y", Num(0), 6);

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s6)));

test bool initS1() = init(s1) == 1; 
test bool initS2() = init(s2) == 2;
test bool initS3() = init(s3) == 3; 
test bool initS4() = init(s4) == 4; 
test bool initS5() = init(s5) == 5; 
test bool initS6() = init(s6) == 6;
test bool initSTMT() = init(stmt) == 1; 

 




