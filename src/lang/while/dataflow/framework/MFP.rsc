module lang::\while::dataflow::framework::MFP

import lang::\while::Syntax; 

data ControlFlowGraph = Forward() 
                      | Backward(); 
                      
data MeetOperator = Union()
                  | Intersection();                       
                      
alias Mapping[A] = map[Label, set[A]];                       

data AbstractMFP[A] = AbstractMFP(ControlFlowGraph cfg, 
                                  set[A] (Block) gen, 
                                  set[A] (Block, WhileProgram) kill,
                                  set[A] (WhileProgram) init, 
                                  set[A] (WhileProgram) bottom,
                                  MeetOperator operator);
                                  
                                  
//tuple[Mapping[A] entry, Mapping[A] exit) solve(AbstractMFP[A] a, WhileProgram p) {
//    
//}  

CFG constructCFG(Forward(), WhileProgram p) = flow(p);
CFG constructCFG(Backward(), WhileProgram p) = reverseFlow(p);

set[A] meet(Union(), set[A] l, set[A] r) = l + r;  
set[A] meet(Intersect(), set[A] l, set[A] r) = l & r;  

