module lang::\while::interprocedural::CallProcedureTransformation

import lang::\while::interprocedural::InterproceduralSyntax;

import List;

public WhileProgram processModifiers(p:WhileProgramProcedural(_, _)) { 
	return visit(p) {
    	case c: Call(_, _, _, _) => addAnnotation(c,p) 
   	};    
}

private Stmt addAnnotation(c: Call(str name, _, _, _), p:WhileProgramProcedural(_, _)){
	list[Procedure] procs = findProcedure(name, p);
	if(!isEmpty(procs)){
		Procedure proc = head(procs);
		c @ proc = ProcedureLabels(proc.ln, proc.lx); 
	}	
	return c; 
}

//TODO como retornar um "maybe" ou "optional"???
private list[Procedure] findProcedure(str name, WhileProgramProcedural(d, _)) = [p | p <- d, name == p.name];
