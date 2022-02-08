module lang::\while::CFGTest

import lang::\while::Syntax; 
import lang::\while::CFG;


BExp b = Gt(Var("y"), Num(1));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("y", Var("x"), 1); 
Stmt s2 = Assignment("z", Num(1), 2); 
Stmt s4 = Assignment("z", Mult(Var("z"), Var("y")), 4);
Stmt s5 = Assignment("y", Sub(Var("y"), Num(1)), 5);
Stmt s6 = Assignment("y", Num(0), 6);

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s6)));


//TODO test if-then-else
test bool initS1() = init(s1) == 1; 
test bool initS2() = init(s2) == 2;
test bool initS3() = init(s3) == 3; 
test bool initS4() = init(s4) == 4; 
test bool initS5() = init(s5) == 5; 
test bool initS6() = init(s6) == 6;
test bool initSTMT() = init(stmt) == 1; 

test bool finalS1() = 1 in final(s1); 
test bool finalS2() = 2 in final(s2);
test bool finalS3() = 3 in final(s3);
test bool finalS4() = 4 in final(s4);
test bool finalS5() = 5 in final(s5);
test bool finalS6() = 6 in final(s6);
test bool finalSTMT() = 6 in final(stmt);

//TODO test other methods

