module lang::\while::SuperCFGUtil

import vis::Render;
import vis::Figure;
import util::Math;
import Relation;
import lang::\while::ifds::SuperCFG;
import lang::\while::interprocedural::InterproceduralSyntax;
import analysis::graphs::LabeledGraph;
import IO;

public LGraph[str, str] toLGraph(SuperCFG g) {
	LGraph[str, str] lgraph = {};
	for (edge  <- g ) {
		switch(edge) {
			case BasicEdge(Label from, Label to): {
				lgraph = lgraph + <toString(from), "", toString(to)>;
			}
			case ReturnEdge(Label from, Label to): {
				lgraph = lgraph + <toString(from), "", toString(to)>;
			}
			case CallEdge(Label from, Label to, int cId): {
				lgraph = lgraph + <toString(from), toString(cId), toString(to)>;
			}
		}
	}
	return lgraph;
}

public void renderSuperCFG(WhileProgram p){
	SuperCFG scfg = sflow(p);
	lg = toLGraph(scfg);
	println("CFG=<scfg>");	
	println("carrier=<carrier(lg)>");
	println("nodes only=<nodesInLGraph(lg)>");
	println("top=<top(lg)>");
	println("bottom=<bottom(lg)>");
	LGraph[str,str] complete = {} + lg;
	complete = complete + {<"START", "", top> | top <- top(lg)};
	complete = complete + {<bottom, "","END"> | bottom <- bottom(lg)};
	nodes = [box(text(n), id(n), size(50), fillColor("lightgreen")) | n <- nodesInLGraph(complete)];
    edges = [edge(c.from, c.to, toArrow(box(size(10)))) | c <- complete];   
    render(scrollable(graph(nodes, edges, hint("layered"), std(size(20)), std(gap(20)))));
}


public set[str] nodesInLGraph(LGraph[str, str] lg) {
	return { n.to, n.from | n <- lg};
}
