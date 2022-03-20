module lang::\while::dataflow::framework::ReachingDefinitionMFPTest

import programs::Factorial;
import lang::\while::dataflow::framework::MFP;
import lang::\while::dataflow::framework::ReachingDefinitionMFP;
import lang::\while::Parser;

test bool testREMFP(){
	rd = rdMFP();
	program = factorialProgram();
	result = solveMFP(rd, program);

	tuple[Mapping[Abstraction], Mapping[Abstraction]] expected = <( 
		1 : {}
   		, 2 : {<"y",1>}
   		, 3 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   		, 4 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   		, 5 : {<"z",4>,<"y",5>,<"y",1>}
   		, 6 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>} 
   		), ( 
   		1 : {<"y",1>}
   		, 2 : {<"y",1>,<"z",2>}
   		, 3 : {<"y",5>,<"y",1>,<"z",2>,<"z",4>}
   		, 4 : {<"z",4>,<"y",5>,<"y",1>}
   		, 5 : {<"y",5>,<"z",4>}
   		, 6 : {<"y",6>,<"z",2>,<"z",4>} )>;
	return(result == expected);
}

