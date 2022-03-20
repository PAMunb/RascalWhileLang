module lang::\while::dataflow::framework::LiveVariableMFPTest

import programs::Factorial;
import lang::\while::dataflow::framework::MFP;
import lang::\while::dataflow::framework::LiveVariableMFP;
import lang::\while::Parser;


test bool testLVMFP(){
	lv = lvMFP();
	program = factorialProgram();
	result = solveMFP(lv, program);

	tuple[Mapping[str], Mapping[str]] expected = <(
		1:{"x"},
		2:{"y"},
		3:{"y","z"},
		4:{"y","z"},
		5:{"y","z"},
		6:{}
	),(
		1:{"y"},
		2:{"y","z"},
		3:{"y","z"},
		4:{"y","z"},
		5:{"y","z"},
		6:{}
	)>;
	return(result == expected);
}
