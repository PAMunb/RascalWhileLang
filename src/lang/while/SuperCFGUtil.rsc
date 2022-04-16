module lang::\while::SuperCFGUtil

import vis::Render;
import vis::Figure;
import util::Math;
import Relation;
import lang::\while::ifds::SuperCFG;
import lang::\while::interprocedural::InterproceduralSyntax;
import IO;

public void renderSuperCFG(WhileProgram p){
	SuperCFG scfg = sflow(p);
	
	println("scfg=<scfg>");
	nodes = nodesFromScfg(scfg);
	edges = edgesFromScfg(scfg);
	render(graph(nodes, edges, hint("layered"), gap(100)));
}

public str getNodeId(int from, CallId cId){
	switch(cId) {
    	case EmptyCallId(): {
    		str nodeId = toString(from);
    		return nodeId;
    	}
    	case CallId(id): {
    		str nodeId = "call:"+toString(id)+" "+toString(from);
    		return nodeId;
    	}
  	}
  	throw "[CALL FAILURE] could not guess node id";
}

public Figures nodesFromScfg(SuperCFG g){
	nodes = [];
	set[str] nodeIds = {};
	for (<from, to, cId>  <- g ){
		str nodeId = getNodeId(from, cId);
		nodeIds = nodeIds + {nodeId};
		nodeIds = nodeIds + {toString(to)};
	}
	nodes = [ box(text(nodeId), id(nodeId), size(50), fillColor("lightgreen")) | nodeId <- nodeIds];			  
	return nodes;
}

public list[Edge] edgesFromScfg(SuperCFG g){
	edges = [edge(getNodeId(from, cId), toString(to), toArrow(box(size(10)))) | <from, to, cId> <- g]; 
	return edges;
}

public void renderExample2() {
	nodes = [ box(text("A"), id("A"), size(50), fillColor("lightgreen")),
			  box(text("B"), id("B"), size(60), fillColor("orange"))];
			  
	edges = [ edge("A", "B")];
	render(graph(nodes, edges, hint("layered"), gap(100)));
}

public void renderExample(){
	nodes = [ box(text("A"), id("A"), size(50), fillColor("lightgreen")),
     	  box(text("B"), id("B"), size(60), fillColor("orange")),
     	  ellipse( text("C"), id("C"), size(70), fillColor("lightblue")),
     	  ellipse(text("D"), id("D"), size(200, 40), fillColor("violet")),
          box(text("E"), id("E"), size(50), fillColor("silver")),
	  box(text("F"), id("F"), size(50), fillColor("coral"))
     	];
	edges = [ edge("A", "B"), edge("B", "C"), edge("B", "D"), edge("A", "C"),
	          edge("C", "E"), edge("C", "F"), edge("D", "E"), edge("D", "F"),
	          edge("A", "F")
	    	]; 
	render(graph(nodes, edges, hint("layered"), gap(100)));
}



