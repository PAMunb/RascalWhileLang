module lang::\while::ifds::SuperCFGProgram

import lang::\while::interprocedural::InterproceduralParser;
import lang::\while::interprocedural::InterproceduralSyntax;

/**
The idea is to get as close as possible to the following example.
At the moment, this While language does not have a "declare" or a "read" statemnt.
Neither it accepts if conditions without else part. 
That is why we had to replace "read" by assignment and we decided to replace the "print"
with a simple "skip"

declare g: integer
program main
begin
	declare x: integer
	read(x)
	call P (x)
end

procedure P (value a : integer)
begin
	if (a > 0) then
		read(g)
		a := a − g
		call P (a)
		print(a, g)
	fi
end
*/

public WhileProgram superCFGProgram() {
	str s =	"begin 
			'proc p(val a) is[1] 
			'	if ( a \> 0, 2) then 
			'		g := 1000 [3];
			'		a := a - g [4];
			'		call p(a) [5,6];
			'		skip [7]
			'	else 
			'		skip [8] 
			'	end
			'end[9] 
			'x := 2000 [10];
			'call p(x) [11,12] 
			'end.";
	program = parseProgram(s);
	return program;
}