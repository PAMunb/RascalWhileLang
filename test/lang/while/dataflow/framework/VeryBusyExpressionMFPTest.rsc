module lang::\while::dataflow::framework::VeryBusyExpressionMFPTest

import lang::\while::dataflow::framework::MFP;
import lang::\while::dataflow::framework::VeryBusyExpressionMFP;
import programs::VeryBusyProgram;
import lang::\while::Parser;
import lang::\while::Syntax; 
import lang::\while::CFG;
import ParseTree; 

public AExp parseExp(str x) {
	return implode(#AExp, parse(#AExpSpec, x));
}

test bool testVBEMFP(){
	vb = vbMFP();
	program = veryBusyProgram();
	result = solveMFP(vb, program);

	tuple[Mapping[AExp], Mapping[AExp]] expected = <(
		1:{parseExp("a - b"), parseExp("b - a")},
		2:{parseExp("a - b"), parseExp("b - a")},
		3:{parseExp("a - b")},
		4:{parseExp("a - b"), parseExp("b - a")},
		5:{parseExp("a - b")}
	),(
		1:{parseExp("a - b"), parseExp("b - a")},
		2:{parseExp("a - b")},
		3:{},
		4:{parseExp("a - b")},
		5:{}
	)>;
	return(result == expected);
}