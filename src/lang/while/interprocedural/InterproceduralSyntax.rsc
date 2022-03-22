module lang::\while::interprocedural::InterproceduralSyntax

extend lang::\while::Syntax;

data WhileProgram = WhileProgramProcedural(Procedure d, Stmt s); 

data FormalArgument = ByValue(str name)
                    | ByReference(str name);

data Procedure = Procedure(str name, list[FormalArgument] args, Label ln, Stmt stmt, Label lx)
               | ProcedureSeq(Procedure p1, Procedure p2);

data Stmt = Call(str name, list[AExp] args, Label lc, Label lr)
          | Return(AExp exp, Label l);

//data Block = block(Call(_, _, _, _));                