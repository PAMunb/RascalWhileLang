module lang::\while::dataflow::ReachingDefinitionTest

import lang::\while::dataflow::ReachingDefinition; 
import lang::\while::Syntax; 

import programs::Factorial;

import IO;

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

test bool reachingDefinitionTest() {
  WhileProgram p = factorialProgram();  // take a look at programs::Factorial. 
  
  tuple[Mapping first, Mapping second] res = reachingDefinition(p); 
  
  Mapping expectedEntry = 
   ( 1 : {}
   , 2 : {<"y",1>}
   , 3 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   , 4 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   , 5 : {<"z",4>,<"y",5>,<"y",1>}
   , 6 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>} ); 
  
  Mapping expectedExit = 
   ( 1 : {<"y",1>}
   , 2 : {<"y",1>,<"z",2>}
   , 3 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   , 4 : {<"z",4>,<"y",5>,<"y",1>}
   , 5 : {<"y",5>,<"z",4>}
   , 6 : {<"y",6>,<"z",2>,<"z",4>} ); 
  
  return res.first == expectedEntry && res.second == expectedExit; 
}