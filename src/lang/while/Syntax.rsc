@doc{
  Synopsis: The abstract syntax definition of the WhileLanguage. 
  
  Description: The While Language is a tiny imperative 
  programming language supporting arithmetic and boolean expressions, 
  as well a small number of statements: 
  
     * assignment statement
     * if-then-else statement
     * while statement 
     * skip statement
     * sequence statement (a statement s1 followed by a statement s2) 
   
  We represented the abstract syntax of the WhileLanguage using algebraic 
  data types in Rascal--- one algebraic data type for every main syntactic 
  construct (boolean expressions (BExp), arithmetic expressions (AExp), and 
  statements (Stmt)). Elementary statements, including assigment and skip 
  are annotated with labels (a unique int value). Conditions appearing 
  in if-then-else and while statements are also annotated with labels. 
  
  We implemented an additional algebraic type Block to generalize over 
  statements and conditions.     
}

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
          | Lt(AExp a1, AExp a2) 
          ; 

data AExp = Var(str x)
          | Num(int n)
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
 

