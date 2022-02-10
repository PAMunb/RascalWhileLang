module lang::\while::CFGTest

import lang::\while::Syntax; 
import lang::\while::CFG;

import IO;

BExp b = Gt(Var("y"), Num(1));
Condition c = Condition(b, 3);  

Stmt s1 = Assignment("y", Var("x"), 1); 
Stmt s2 = Assignment("z", Num(1), 2); 
Stmt s4 = Assignment("z", Mult(Var("z"), Var("y")), 4);
Stmt s5 = Assignment("y", Sub(Var("y"), Num(1)), 5);
Stmt s6 = Assignment("y", Num(0), 6);

Stmt s3 = While(c, Seq(s4, s5)); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s6)));

WhileProgram factorial = WhileProgram(stmt);


//TODO test if-then-else
test bool initS1() = init(s1) == 1; 
test bool initS2() = init(s2) == 2;
test bool initS3() = init(s3) == 3; 
test bool initS4() = init(s4) == 4; 
test bool initS5() = init(s5) == 5; 
test bool initS6() = init(s6) == 6;
test bool initSTMT() = init(stmt) == 1; 

test bool finalS1() = final(s1) == {1}; 
test bool finalS2() = final(s2) == {2};
test bool finalS3() = final(s3) == {3};
test bool finalS4() = final(s4) == {4};
test bool finalS5() = final(s5) == {5};
test bool finalS6() = final(s6) == {6};
test bool finalSTMT() = final(stmt) == {6};



//TODO how to test blocks()???
//test bool blocksS1() = blocks(s1) == {stmt(s1)};
//test bool blocksS1() = blocks(s1) == {stmt(Assignment("y", Var("x"), 1))};
//test bool blocksS1() = stmt(s1) in blocks(s1);
public void teste(){
	println("blocks=<blocks(s1)>");
}



test bool flowS1() = flow(s1) == {}; 
test bool flowS2() = flow(s2) == {}; 
test bool flowS3() = flow(s3) == {<3,4>,<4,5>,<5,3>};
test bool flowS4() = flow(s4) == {}; 
test bool flowS5() = flow(s5) == {}; 
test bool flowS5eq45() = flow(Seq(s4, s5)) == {<4,5>}; 
test bool flowS6() = flow(s6) == {}; 
test bool flowSTMT() = flow(stmt) == {<1,2>,<2,3>,<3,4>,<3,6>,<4,5>,<5,3>};
test bool flowWhileProgram() = flow(factorial) == {<1,2>,<2,3>,<3,4>,<3,6>,<4,5>,<5,3>};


test bool reverseFlowS1() = reverseFlow(s1) == {}; 
test bool reverseFlowS2() = reverseFlow(s2) == {}; 
test bool reverseFlowS3() = reverseFlow(s3) == {<4,3>,<5,4>,<3,5>};
test bool reverseFlowS4() = reverseFlow(s4) == {}; 
test bool reverseFlowS5() = reverseFlow(s5) == {}; 
test bool reverseFlowS5eq45() = reverseFlow(Seq(s4, s5)) == {<5,4>}; 
test bool reverseFlowS6() = reverseFlow(s6) == {}; 
test bool reverseFlowSTMT() = reverseFlow(stmt) == {<2,1>,<3,2>,<4,3>,<6,3>,<5,4>,<3,5>};
test bool reverseFlowWhileProgram() = reverseFlow(factorial) == {<2,1>,<3,2>,<4,3>,<6,3>,<5,4>,<3,5>};

//TODO test other methods

