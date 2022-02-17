module lang::\while::dataflow::ReachingDefinitionTest

import lang::\while::dataflow::ReachingDefinition; 
import lang::\while::Syntax; 

test bool killTest() {
  Abstraction entry = {<"x", 1>, <"y", 2>, <"y", 3>}; 
  
  b1 = kill(stmt(Skip(4)), entry) == {}; 
  b2 = kill(stmt(Assignment("y", Num(4), 5)), entry) == {<"y", 2>, <"y", 3>};
  
  return b1 && b2; 
}

test bool genTest() {
  b1 = gen(stmt(Skip(4))) == {}; 
  b2 = gen(stmt(Assignment("y", Num(4), 5))) == {<"y", 5>};
  
  return b1 && b2; 
}