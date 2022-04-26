module lang::\while::ifds::SuperCFGTest


import lang::\while::ifds::SuperCFGProgram;
import lang::\while::ifds::SuperCFG;
import lang::\while::ifds::ExplodedCFG;
import lang::\while::interprocedural::InterproceduralSyntax;


tuple[Label, EdgeType, Label] BasicEdge(Label from, Label to) = <from, BasicEdge(), to>; 
tuple[Label, EdgeType, Label] CallEdge(Label from, Label to, int cId) = <from, CallEdge(cId), to>; 
tuple[Label, EdgeType, Label] ReturnEdge(Label from, Label to, int cId) = <from, ReturnEdge(cId), to>; 


test bool testSuperCFG(){
	WhileProgram p = superCFGProgram();
	SuperCFG scfg = sflow(p);
	SuperCFG expected = {
						BasicEdge(10,11), 	//x := 2000 [10];
						CallEdge(11,1,11), 	//call p(x) [11,12]
						BasicEdge(11,12),   //return p
						BasicEdge(1,2), 	//proc p(val a) is[1]  
						BasicEdge(2,3),  	//	if ( a \> 0, 2) then
						BasicEdge(3,4),		//		g := 1000 [3];
						BasicEdge(4,5),		//		a := a - g [4];
						CallEdge(5,1,5),	//		call p(a) [5,6];
						BasicEdge(5,6),		//		return p
						ReturnEdge(9,6,5),	//		CallMerge (for call 1)
						BasicEdge(6,7),		//		skip [7]
						BasicEdge(7,9),		//		end proc
						BasicEdge(2,8), 	//	else skip [8] 
						BasicEdge(8,9),		//		end proc
						ReturnEdge(9,12,11) 	//		CallMerge
						};	
					
	return scfg == expected;
}
