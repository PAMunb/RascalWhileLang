module lang::\while::interprocedural::InterproceduralSemantics


import lang::\while::interprocedural::InterproceduralSyntax;
import util::Maybe;
import List;
import Exception;
import Relation;
import IO;

data Configuration = Terminal(Env env, Store store)
                   | NonTerminal(Stmt stmt, Env env, Store store)
                   | ConfigError()      // this should not be necessary.
                   ;
                   
data Bind = Bind(Procedure proc, Stmt stmt, Env env, Store store);

alias Location = int;
alias Env = map[str, Location];
alias Store = map[Location, int];
int LocationIndex = 0;

@doc{
 Synopsis: Determines the value of a variable x 
 
 Description: 	"(...) to determine the value of a variable x
  				we first determine its location E = Env(x)
  				and the next value Store(E)stored in that location 
  				(...) for this to work it is essential that Store(Env): Var* -> Z"
   				(from page 86 of the book) 
}
public int getNextLocation() {
	LocationIndex = LocationIndex+1;
	return LocationIndex;
}

public void resetLocations(){LocationIndex = 0;}

public bool isNewVariable(str x, Env env){
	set[str] knownVariables  =  ( {} | it + e | e <- env );
	if(x in knownVariables) {
		return false;
	}
	return true;
}

public Env newLocation(str x, Env env) {
	if(isNewVariable(x, env)){
		return env + (x: getNextLocation());
	}
	return env ;
}

int aEval(Var(x), Env env, Store store) = store[env[x]];
int aEval(Num(v), Env env, Store store) = v; 
int aEval(Add(l, r), Env env, Store store)  = aEval(l, env, store) + aEval(r, env, store); 
int aEval(Sub(l, r), Env env, Store store)  = aEval(l, env, store) - aEval(r, env, store); 
int aEval(Mult(l, r), Env env, Store store) = aEval(l, env, store) * aEval(r, env, store);

bool bEval(True(), Env env, Store store)  = true; 
bool bEval(False(), Env env, Store store) = false;
bool bEval(Not(exp), Env env, Store store) = ! bEval(exp, env, store); 
bool bEval(And(l,r), Env env, Store store) = bEval(l, env, store) && bEval(r, env, store); 
bool bEval(Or(l,r), Env env, Store store)  = bEval(l, env, store) || bEval(r, env, store);
bool bEval(Eq(l,r), Env env, Store store)  = aEval(l, env, store) == aEval(r, env, store);
bool bEval(Gt(l,r), Env env, Store store)  = aEval(l, env, store) > aEval(r, env, store);
bool bEval(Lt(l,r), Env env, Store store)  = aEval(l, env, store) < aEval(r, env, store);

public Configuration run(Skip(_), Env env, Store store, WhileProgram program) = Terminal(env, store); 
public Configuration run(Assignment(x, a, _), Env env, Store store, WhileProgram program){
	int res = aEval(a, env, store);
	if(isNewVariable(x, env)) {
		Env newEnv = newLocation(x, env);
		store[newEnv[x]] = res;
		return Terminal(newEnv, store);
	} else {
		store[env[x]] = res;
		return Terminal(env, store);
	}
}

public Configuration run(IfThenElse(Condition(c, l), s1, s2), Env env, Store store, WhileProgram program) {
	if(bEval(c, env, store)){
		return run(s1, env, store, program);
	} else {
		return run(s2, env, store, program);  
	}
}

public Configuration run(w: While(Condition(c, l), s), Env env, Store store, WhileProgram program) { 
	if(bEval(c, env, store)) {
   		return run(Seq(s, w), env, store, program);
 	}
 	return Terminal(env, store);  
}

public Configuration run(r: Return(AExp exp, Label l), Env env, Store store, WhileProgram program) {
	return Terminal(env, store);
}

public Maybe[Procedure] findProcedureDefinition(str procName, WhileProgram program) {
	for( Procedure proc <- program.d ) {
		if(proc.name == procName){
			return just(proc);
		}
	}
	return nothing(); 
}

public list[str] getArguments(Procedure proc) = ([]|it + arg.name| arg <- proc.args);
public list[str] getByValueArguments(Procedure proc) = ([] |it + name| /ByValue(name) <-proc.args);
public list[str] getByRefArguments(Procedure proc) = ([] |it + name| /ByReference(name) <-proc.args);
public bool isByValueArgument(str argName, Procedure proc) = argName in getByValueArguments(proc);
public bool isByRefArgument(str argName, Procedure proc) = argName in getByRefArguments(proc);


public Configuration run(Call(str name, list[AExp] args, Label lc, Label lr), Env env, Store store, WhileProgram program) {
	procDefinition = findProcedureDefinition(name, program);
	switch(procDefinition) {
		case just(Procedure proc): {
			Env newEnv = ();
			Store newStore = ();
			list[str] procArgs = getArguments(proc);
			assert size(procArgs) == size(args);
			lrel[str, AExp] mappedArguments = zip(procArgs, args);
			for( <variable, expression> <- mappedArguments){
				switch(expression) {
					case Var(vName): {
						if( isNewVariable(vName, env) ) {
							env = newLocation(vName, env);
							store[env[vName]] = 0;
						}
					}
				}
				if(isByValueArgument(variable, proc)){
					newEnv = newLocation(variable, newEnv);
					newStore[newEnv[variable]] = aEval(expression, env, store);
				} else {
					switch(expression){
						case Var(vName): {
							newEnv = newEnv + (variable: env[vName]);
							newStore[newEnv[variable]] = store[env[vName]];
						}
						default: throw "By reference value must be a Var";
					}
				}
			}
			Env envWithGlobals = env + newEnv;
			Store storeWithGlobals = store + newStore;
			return run(Bind(proc, proc.stmt, envWithGlobals, storeWithGlobals), env, store, program);
		}
		case nothing(): return ConfigError();
	}
	return ConfigError();
}

public Configuration run(Bind(Procedure proc, Stmt stmt, Env procEnv, Store procStore), Env env, Store store, WhileProgram program) {
	Configuration c = run(stmt, procEnv, procStore, program);
	switch(c){
        case NonTerminal(Stmt s1, Env e, Store s): {
        	return run(Bind(proc, s1, e, s), env, store, program);
        }
        case Terminal(Env e, Store s): {
        	for(byRefArgument <- getByRefArguments(proc)) {
        		store[e[byRefArgument]] = s[e[byRefArgument]];
        		return Terminal(env, store);
        	}
        }
	}
	return ConfigError();
}

public Configuration run(Seq(s1, s2), Env env, Store store, WhileProgram program) {
	s1Configuration = run(s1, env, store, program);
  	switch(s1Configuration) {
    	case NonTerminal(Stmt s11, Env e, Store s): {
    		return run(Seq(s11, s2), e, s, program);
    	}
    	case Terminal(Env e, Store s): {
    		return run(s2, e, s, program);
    	}
    	default: {
    		return ConfigError();
    	}
  	}
}



public Configuration run(WhileProgram p) = run(p.s, (), (), p);
