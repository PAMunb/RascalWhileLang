module lang::\while::SemanticsTest


import lang::\while::Semantics; 
import lang::\while::Parser; 


str program = 
 "y := 6 [1]; 
 'z := 1 [2]; 
 'while (y \> 1, 3) do 
 '  z := z * y [4]; 
 '  y := y - 1 [5]
 'end;  
 'y := 0 [6]";
 
test bool testRunForFactorial() {
	Configuration c = run(parse(program)); 
	return c == Terminal(("y":0, "z":720)); 
}