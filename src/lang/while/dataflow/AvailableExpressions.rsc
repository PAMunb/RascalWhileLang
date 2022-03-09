module lang::\while::dataflow::AvailableExpressions

import lang::\while::Syntax; 
import lang::\while::CFG; 

import util::Math;
import List;
            
public lrel[str, str, str] fva = []; // [<a' E AExp*, a1 E FV(a'), b1 E FV(a')>]

tuple[map[Label, set[str]], map[Label, set[str]]] availableExpressions(WhileProgram program) { 
   map[Label, set[str]] entry = ();
   map[Label, set[str]] exit = ();
 
   CFG cfg = flow(program.s); 
   
   for(Label l <- labels(program.s)) {
     exit[l] = {}; 
   }
    
   tuple[map[Label, set[str]], map[Label, set[str]]] res = <entry, exit>; 
   
   solve(res) {  
      for(Block b <- blocks(program.s)) {
       	Label target = label(b);

		set[str] killB = kill(b);
       	set[str] genB = gen(b);
       	
		if(({} | it + exit[from] | <from, target> <- cfg, from > target) != {}){
	  		entry[target] = ({} | it + exit[from] | <from, target> <- cfg, from < target) & ({} | it + exit[from] | <from, target> <- cfg, from > target);
		} else {
  			entry[target] = ({} | it + exit[from] | <from, target> <- cfg, from < target);
  		}
       	exit[target] = (entry[target] - killB) + genB; 
      }
       
      res = <entry, exit>;
   }  
   return res; 
} 


public CFG teste(CFG cfg){
	return cfg;
}

public set[str] kill(Block b) {
  tuple [str, str, str] tAexp = <"","","">;
 
  if(isEmpty(fva))
    return {};
  
  switch(b) {
    case stmt(Assignment(x, a, _)):{
    	switch(a) {
    		case Var(str _): return {};
    		case Num(int _): return {};
    		case Add(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "+"); 
    		case Sub(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "-");
    		case Mult(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "*"); 
    	} 

    	lrel[str, str, str] fvaLocal = fva;
		fva = fva - [fvat | fvat <-  {<aexpI, v, v2> | <aexpI, v, v2> <- fva, (v == x) || (v2 == x)}];
		if(fvaLocal != fva){
		  fvaLocal = [tAexp] + (fvaLocal - fva);
		  return {s | <s, _, _> <- fvaLocal};
		}
    	return {};
    	
    }
    default: return {};
  }
} 

public set[str] gen(Block b) {
  tuple [str, str, str] tAexp = <"","","">;
 
  switch(b) {
    case stmt(Assignment(x, a, _)):{
    	switch(a) {
    		case Var(str _): return {};
    		case Num(int _): return {};
    		case Add(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "+"); 
    		case Sub(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "-");
    		case Mult(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "*"); 
    	} 
    	if(x != tAexp[1] && x != tAexp[2]){ // x is not element of FV(a')}
   			fva = fva + [tAexp];
    		return {tAexp[0]};
    	}else{
    		return {};
    	}
    }
    case condition(Condition(BExp b, Label _)):{
    	switch(b) {
    		case Gt(AExp a, AExp b):{
		    	switch(a) {
		    		case Var(str x): {
				    	switch(b) {
				    		case Var(str _): return {};
				    		case Num(int _): return {};
				    		case Add(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "+"); 
				    		case Sub(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "-");
				    		case Mult(AExp a1, AExp b1): tAexp = mountAexp(a1, b1, "*");
				    	} 
				    	if(x != tAexp[1] && x != tAexp[2]){ // x is not element of FV(a')}
				   			fva = fva + [tAexp];
				    		return {tAexp[0]};
				    	}else{
				    		return {};
				    	}
		    		}
		    		default: return {};
		    	} 
    		}
		    default: return {};
		 }
    }
    default: return {};
  }
} 


public tuple[str aexp, str la1, str lb1] mountAexp(AExp a1, AExp b1, str signal){
	str la1 = "";
  	str lb1 = "";
  	switch(a1) {
		case Var(str x): la1 = x;
		case Num(int n): la1 = toString(n);
	}
	switch(b1) {
		case Var(str x): lb1 = x;
		case Num(int n): lb1 = toString(n);
	}
	str aexp = la1 + signal + lb1;
	return <aexp, la1, lb1>;
	
}

//kill(stmt(Assignment("x", Add(Var("a"), Var("b")), 1)));
//gen(stmt(Assignment("x", Add(Var("a"), Var("b")), 1)));

//kill(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2)));
//gen(stmt(Assignment("y", Mult(Var("a"), Var("b")), 2)));

//kill(condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3)));
//gen(condition(Condition(Gt(Var("y"), Add(Var("a"), Var("b"))), 3)));

//kill(stmt(Assignment("a", Add(Var("a"), Num(1)), 4)));
//gen(stmt(Assignment("a", Add(Var("a"), Num(1)), 4)));

//kill(stmt(Assignment("x", Add(Var("a"), Var("b")), 5)));
//gen(stmt(Assignment("x", Add(Var("a"), Var("b")), 5)));