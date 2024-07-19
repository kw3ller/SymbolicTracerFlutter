
// simple GraphNode that shall hold all data needed for a Node in the Tree
class GraphNode {

  // TODO: we probably need an index in the future either here or we make an array of graphNodes
  // TODO: or we do it like in ComputerGraphics -> make all arrays here: struct of arrays

  final String file;
  final String funcName;
  final int fromLine;
  final int toLine;
 
  GraphNode(this.file, this.funcName, this.fromLine, this.toLine);

}

// TODO: delete -> just for testing
GraphNode gn0 = GraphNode("main.c", "main", 32, 35);
GraphNode gn1 = GraphNode("coap_handler.c", "_sha256_handler", 117, 132);
GraphNode gn2 = GraphNode("coap_handler.c", "_riot_value_handler", 82, 91);
GraphNode gn3 = GraphNode("main.c", "main", 45, 48);
GraphNode gn4 = GraphNode("coap_handler.c", "_riot_block2_handler", 49, 77);
GraphNode gn5 = GraphNode("coap_handler.c", "_riot_board_handler", 42, 44);
GraphNode gn6 = GraphNode("coap_handler.c", "_echo_handler", 27, 28);
// some repeated
GraphNode gn7 = GraphNode("coap_handler.c", "_riot_value_handler", 82, 91);
GraphNode gn8 = GraphNode("coap_handler.c", "_sha256_handler", 117, 132);
GraphNode gn9 = GraphNode("coap_handler.c", "_echo_handler", 27, 28);

List<GraphNode> graphNodesArr = [gn0, gn1, gn2, gn3, gn4, gn5, gn6, gn7, gn8, gn9];