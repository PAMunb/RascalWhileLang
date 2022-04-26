module lang::\while::interprocedural::InterproceduralSyntax

extend lang::\while::Syntax;

data WhileProgram = WhileProgramProcedural(set[Procedure] d, Stmt s); 

data FormalArgument = ByValue(str name)
                    | ByReference(str name);

data Procedure = Procedure(str name, list[FormalArgument] args, Label ln, Stmt stmt, Label lx);

data Stmt = Call(str name, list[AExp] args, Label lc, Label lr)
          | Return(AExp exp, Label l);
          
data Block = entryProc(Label l) | exitProc(Label l);           
          
data ProcedureLabels = ProcedureLabels(Label ln, Label lx);

Label label(stmt(Call(_, _, lc, _))) = lc;
Label label(entryProc(ln)) = ln; 
Label label(exitProc(lx)) = lx; 

anno ProcedureLabels Stmt @ proc;          
                      