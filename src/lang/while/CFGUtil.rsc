module lang::\while::CFGUtil

import lang::\while::CFG;

import Relation;
import Set;
import analysis::graphs::Graph;
import util::Math;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

public Figure toFigure(Graph[&T] g){
	nodes = [box(text(toString(n)), id(toString(n)), size(50), fillColor("lightgreen")) | n <- carrier(g)];
    return toFigure(g, nodes);
}

private Figure toFigure(Graph[&T] g, Figures nodes){
    edges = [edge(toString(c.from), toString(c.to), toArrow(box(size(10)))) | c <- g];   
    return scrollable(graph(nodes, edges, hint("layered"), std(size(20)), std(gap(20))));
}

/*
public str toDot(Graph[&T] g) {
	return toDot(g, "classes");
}

public str toDot(Graph[&T] g, str title) {
	return "digraph <title> {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (call <- g) {>                  
         '  \"<call.from>\" -\> \"<call.to>\" <}>
         '}";	
         //'  \"<call.from>\" -\> \"<call.to>\" [arrowhead=\"empty\"]<}>
}
*/