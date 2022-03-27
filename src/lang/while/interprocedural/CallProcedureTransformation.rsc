module lang::\while::interprocedural::CallProcedureTransformation

import lang::\while::interprocedural::InterproceduralSyntax;

import List;

public WhileProgram processProcedureLabels(wpp: WhileProgramProcedural(setProcs, _)) { 
	return visit(wpp) {
    	//case c: Call(_, _, _, _) => addAnnotation(c,p) 
    	case c: Call(str name, _, _, _): {
    		 list[Procedure] procs = [p | p <- setProcs, p.name == name];
    		 if(!isEmpty(procs))
	    		 for(Procedure(_, _, Label ln, _, Label lx) <- procs)
	    		 	c @ proc = ProcedureLabels(ln, lx);
    		 else throw "[CALL FAILURE] procedure <name> could not be found";
    		 insert c;
    	}
   	};    
}

//private Stmt addAnnotation(c: Call(str name, _, _, _), p:WhileProgramProcedural(_, _)){
//	list[Procedure] procs = findProcedure(name, p);
//	if(!isEmpty(procs)){
//		Procedure procedure = head(procs);
//		c @ proc = ProcedureLabels(procedure.ln, procedure.lx); 
//	}	
//	return c; 
//}

//TODO como retornar um "maybe" ou "optional"???
//private list[Procedure] findProcedure(str name, WhileProgramProcedural(d, _)) = [p | p <- d, name == p.name];

