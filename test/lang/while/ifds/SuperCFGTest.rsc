module lang::\while::ifds::SuperCFGTest


import lang::\while::ifds::SuperCFGProgram;
import lang::\while::ifds::SuperCFG;
import lang::\while::interprocedural::InterproceduralSyntax;

public test bool testSuperCFG(){
	WhileProgram p = superCFGProgram();
	SuperCFG scfg = sflow(p);
	SuperCFG expected = {
						BasicEdge(10,11), 	//x := 2000 [10];
						CallEdge(11,1,2), 	//call p(x) [11,12]
						ReturnEdge(11,12),  //return p
						BasicEdge(1,2), 	//proc p(val a) is[1]  
						BasicEdge(2,3),  	//	if ( a \> 0, 2) then
						BasicEdge(3,4),		//		g := 1000 [3];
						BasicEdge(4,5),		//		a := a - g [4];
						CallEdge(5,1,1),	//		call p(a) [5,6];
						ReturnEdge(5,6),	//		return p
						CallEdge(9,6,1),	//		CallMerge (for call 1)
						BasicEdge(6,7),		//		skip [7]
						BasicEdge(7,9),		//		end proc
						BasicEdge(2,8), 	//	else skip [8] 
						BasicEdge(8,9),		//		end proc
						CallEdge(9,12,2) 	//		CallMerge
						};
	return scfg == expected;
}