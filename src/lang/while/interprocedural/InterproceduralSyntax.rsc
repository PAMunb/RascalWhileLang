module lang::\while::interprocedural::InterproceduralSyntax

extend lang::\while::Syntax;

data WhileProgram = WhileProgramProcedural(list[Procedure] d, Stmt s); 

data FormalArgument = ByValue(str name)
                    | ByReference(str name);

data Procedure = Procedure(str name, list[FormalArgument] args, Label ln, Stmt stmt, Label lx);

data Stmt = Call(str name, list[AExp] args, Label lc, Label lr)
          | Return(AExp exp, Label l);

//data Block = condition(Condition c) | stmt(Stmt s); 
//data Block = block(Call(_, _, _, _));                