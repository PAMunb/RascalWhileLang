module lang::\while::Syntax

alias Label = int;

data WhileProgram = WhileProgram(Stmt s); 

data BExp = True()
          | False()
          | Not(BExp b)
          | And(BExp b1, BExp b2)
          | Or(BExp b1, BExp b2)
          | Eq(AExp a1, AExp a2)
          | Gt(AExp a1, AExp a2) 
          ; 

data AExp = Var(str x)
          | Num(num n)
          | Add(AExp a1, AExp a2)
          | Sub(AExp a1, AExp a2)
          | Mult(AExp a1, AExp a2)
          ;  

data Block = condition(Condition c) | stmt(Stmt s); 

data Condition = Condition(BExp b, Label l); 
          
data Stmt = Assignment(str x, AExp a, Label l)
          | Skip(Label l)
          | Seq(Stmt s1, Stmt s2)
          | IfThenElse(Condition c, Stmt s1, Stmt s2)
          | While(Condition c, Stmt s)
          ; 
                             
                             
public Label label(stmt(Assignment(_, _, l))) = l; 
public Label label(stmt(Skip(l))) = l;
public Label label(condition(Condition(b, l))) = l;
 

