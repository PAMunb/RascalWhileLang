module lang::\while::Semantics

import lang::\while::Syntax;

alias State = map[str, int];

 
data Configuration = Terminal(State state)
                   | NonTerminal(Stmt stmt, State state)
                   | ConfigError()      // this should not be necessary.
                   ; 

State initialState() = (); 

@doc{
 Synopsis: An interpreter for arithmetic expressions. 
 
 Description: the aEval function has type 
   
    A : AExp -> (State -> Z)   (from page 55 of the book) 
  
  It evaluates an arithmetic expression in the current state and 
  returns an integer.  
}
int aEval(Var(x), State state)= state[x];
int aEval(Num(v), State _) = v; 
int aEval(Add(l, r), State state)  = aEval(l, state) + aEval(r, state); 
int aEval(Sub(l, r), State state)  = aEval(l, state) - aEval(r, state); 
int aEval(Mult(l, r), State state) = aEval(l, state) * aEval(r, state); 

@doc{
 Synopsis: An interpreter for boolean expressions. 
 
 Description: the bEval function has type 
   
    B : BExp -> (State -> T)   (from page 55 of the book) 
  
  It evaluates an boolean expression in the current state and 
  returns either true or false.  
}
bool bEval(True(), State _)  = true; 
bool bEval(False(), State _) = false;
bool bEval(Not(exp), State s) = ! bEval(exp, s); 
bool bEval(And(l,r), State s) = bEval(l, s) && bEval(r, s); 
bool bEval(Or(l,r), State s)  = bEval(l, s) || bEval(r, s);
bool bEval(Eq(l,r), State s)  = aEval(l, s) == aEval(r, s);
bool bEval(Gt(l,r), State s)  = aEval(l, s) > aEval(r, s);

Configuration run(WhileProgram p) = run(p.s, initialState()); 

// Interpreter for the assignment statement. 
Configuration run(Assignment(x, e, _), State s) = Terminal(s + (x : aEval(e, s))); 

// Interpreter for the skip statement. 
Configuration run(Skip(_), State s) = Terminal(s); 

// Interpreter for the sequence statement. Here we have to detail a bit more. 
// 
// Evaluating a sequence Seq(s1, s2) in the current state. We 
// first run s1 in the current state. Two things might happen. 
// 
//
//  (a) if it returns a NonTerminal(s1', state'), we must evaluate 
//      a new sequence Seq(s1', s2) considering the new state state'. 
// 
//  (b) if it returns a Terminal(state'), we must then evaluate 
//     s2 in the new state state'.  
// 
Configuration run(Seq(s1, s2), State state) {
  switch(run(s1, state)) {
    case NonTerminal(s11, state1): return run(Seq(s11, s2), state1); 
    case Terminal(state1): return run(s2, state1); 
    default: return ConfigError(); 
  }
}

// Interpreter for the IfThenElse stmt. We first evaluate the 
// condition "c". If it is true, we rund the "then statement"; 
// otherwise we run the "else statement". 
Configuration run(IfThenElse(Condition(c, l), s1, s2), State state) { 
 if(bEval(c, state)) 
   return run(s1, state);
 return run(s2, state);  
}

// Interpreter for the while statement. If the condition is 
// true, we execute the sequence Seq(s, w) in the original 
// state. This is quite beautiful :) 
// 
// Otherwise, we just return the original state. 
Configuration run(w: While(Condition(c, l), s), State state) { 
 if(bEval(c, state)) {
   return run(Seq(s, w), state);
 }
 return Terminal(state);  
}

 

  

 

