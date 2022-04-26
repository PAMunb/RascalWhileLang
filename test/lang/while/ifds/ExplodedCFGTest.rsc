module lang::\while::ifds::ExplodedCFGTest


import lang::\while::ifds::SuperCFGProgram;
import lang::\while::ifds::SuperCFG;
import lang::\while::ifds::ExplodedCFG;
import lang::\while::interprocedural::InterproceduralSyntax;


tuple[Label, EdgeType, Label] BasicEdge(Label from, Label to) = <from, BasicEdge(), to>; 
tuple[Label, EdgeType, Label] CallEdge(Label from, Label to, int cId) = <from, CallEdge(cId), to>; 
tuple[Label, EdgeType, Label] ReturnEdge(Label from, Label to, int cId) = <from, ReturnEdge(cId), to>; 


test bool testExplodedSuperCFG(){
	WhileProgram p = superCFGProgram();
	
	//Note: 
	// (*) set of assignments in p = { (x, 10), (g, 3), (a, 4) }
	//
	// (*) At the entry point, we must generate (x, ?), (g, ?), (a, 4) 
	//   
	//   In general, we must deal with the very first entry from a procedure 
	//   to its first statement. Currently I am still not dealing with this 
	//   case. 
	// 
	// at BasicEdge 10 -> 11 we must kill {(x, 10), (x, ?)}  and gen {(x,10)}  
	// at BasicEdge 3  -> 4  we must kill {(g, 3), (g, ?)} and gen {(g, 3)}
	// at BasicEdge 4  -> 5  we must kill {(a, 4), (a, ?)} and gen {(a, 4)}
	//
	// That is, for:
	//
	//   <10,BasicEdge(),11>:              Zero   (x, 10)   (g, 3)  (a, 4) 
	//        x := 2000             Zero     *       *        
	//                            (x,10)  
	//                             (g,3)                        *      
	//                             (a,4)                               *  
	//
	//
	//
	//   <3,BasicEdge(),4>:               Zero   (x, 10)   (g, 3)  (a, 4) 
	//      g := 10000              Zero    *                 *      
	//                            (x,10)            * 
	//                             (g,3)                            
	//                             (a,4)                             *  
	//
	//
	//   <4,BasicEdge(),5>:               Zero   (x, 10)   (g, 3)  (a, 4) 
	//      a := a-g                Zero    *                        *      
	//                            (x,10)            * 
	//                             (g,3)                      *       
	//                             (a,4)                       
	//
	//
	//
	//
	 
	 
	
	expected = ( 
	  // assignments (ok). 
	  <10, BasicEdge(), 11> : { <Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Vertice(<"x",10>)>,<Zero(),Zero()> },
	  <3,BasicEdge(),4>: {<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Zero(),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  <4,BasicEdge(),5>: {<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Vertice(<"a",4>)>,<Zero(),Zero()>},
	  
	  // call and return edges (need to implement)    
	  <11,CallEdge(11),1>: {},
	  <5,CallEdge(5),1>: {},
	  <9,ReturnEdge(11),12>: {},
	  <9,ReturnEdge(5),6>: {},
	  
	  // this is the entry point of procedure p. we have to discuss how to deal with it. 
	  <1,BasicEdge(),2>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  
	  // call to return edges  
	  <5,BasicEdge(),6>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  <11,BasicEdge(),12>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  
	  
	  // basic edgens in the form λ s -> s (seems ok)     
	  <2,BasicEdge(),3>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  <2,BasicEdge(),8>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	    
	  // not sure what is Label 9  
	  <7,BasicEdge(),9>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	  <8,BasicEdge(),9>:{<Vertice(<"x",10>),Vertice(<"x",10>)>,<Vertice(<"a",4>),Vertice(<"a",4>)>,<Vertice(<"g",3>),Vertice(<"g",3>)>,<Zero(),Zero()>},
	     
	  // suspicious case   
	  <6,BasicEdge(),7>:{}
	);
	
	return expected == explodedCFG(p); 
}
