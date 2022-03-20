module lang::\while::dataflow::framework::AvailableExpressionMFPTest

import programs::Prog;
import lang::\while::dataflow::framework::MFP;
import lang::\while::dataflow::framework::AvailableExpressionMFP;
import lang::\while::Parser;
import lang::\while::Syntax; 
import ParseTree;


public AExp parseExp(str x) {
	return implode(#AExp, parse(#AExpSpec, x));
}

test bool testAEMFP() {
	ae = aeMFP();
	program = progProgram();
	result = solveMFP(ae, program);

	tuple[Mapping[AExp], Mapping[AExp]] expected = <( 
		1 : {}
   		, 2 : {parseExp("a+b")}
   		, 3 : {parseExp("a+b")}
   		, 4 : {parseExp("a+b")}
   		, 5 : {}
   		), ( 
   		1 : {parseExp("a+b")}
   		, 2 : {parseExp("a+b"), parseExp("a*b")}
   		, 3 : {parseExp("a+b")}
   		, 4 : {}
   		, 5 : {parseExp("a+b")} )>;
	return(result == expected);
}