module programs::Fibonacci

import lang::\while::Syntax; 

BExp b = Gt(Var("i"), Var("x"));
Condition c = Condition(b, 4);  

Stmt s1 = Assignment("num1", Num(0), 1); 
Stmt s2 = Assignment("num2", Num(1), 2); 
Stmt s3 = Assignment("i", Num(1), 3); 
Stmt s5 = Assignment("sumOfPrevTwo", Add(Var("num1"), Var("num2")), 5);
Stmt s6 = Assignment("num1", Var("num2"), 6); 
Stmt s7 = Assignment("num2", Var("sumOfPrevTwo"), 7); 
Stmt s8 = Assignment("i", Add(Var("i"), Num(1)), 8);

Stmt s4 = While(c, Seq(s5, Seq(s6, Seq(s7,s8)))); 

Stmt stmt = Seq(s1, Seq(s2, Seq(s3, s4)));

WhileProgram fibonacci = WhileProgram(stmt);

public WhileProgram fibonacciProgram(){
	return fibonacci;
}

/*
public static void main(String[] args) {
    num1 = 0, 1
    num2 = 1;2

    int i=1;3
    while(i<=x)4
    {
        int sumOfPrevTwo = num1 + num2;5
        num1 = num2;6
        num2 = sumOfPrevTwo;7
        i++;8
    }
}*/