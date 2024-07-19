import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:pluto_layout/pluto_layout.dart';

import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:symtrace/providers/codeFilesStats_provider.dart';

import 'package:symtrace/data/graphNode.dart';
import 'package:symtrace/providers/symbolicConcreteList_provider.dart';

import '../data/symProgram.dart';

// TODO: just temporary textstyle for projekttag -> use something better later

const TextStyle genericTextStyle = TextStyle(
  fontSize: 15,
);

// for search in stats Tab
TextEditingController statsTextFieldController = TextEditingController();
// for search in symbolic/concrete values Tab
TextEditingController symConcTextFieldController = TextEditingController();

AutoScrollController scrollControllerSymConcList = AutoScrollController();

// for testgraph
final Graph graph = Graph();
// for testgraph
SugiyamaConfiguration builder = SugiyamaConfiguration();

class RightTab extends StatefulWidget {
  const RightTab({required this.newTabResolver, super.key});

  final PlutoLayoutActionInsertTabItemResolver newTabResolver;

  @override
  State<RightTab> createState() => _RightTabState();
}

class _RightTabState extends State<RightTab> {
  @override
  void initState() {
    super.initState();

    // just sample for graph
    final node0 = Node.Id(0);
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    final node6 = Node.Id(6);
    final node7 = Node.Id(7);
    final node8 = Node.Id(8);
    final node9 = Node.Id(9);

    graph.addEdge(node0, node1);
    graph.addEdge(node1, node4);
    graph.addEdge(node1, node3);
    graph.addEdge(node2, node3);
    graph.addEdge(node4, node2);
    graph.addEdge(node3, node7);
    graph.addEdge(node7, node8);
    graph.addEdge(node7, node9);
    graph.addEdge(node3, node5);
    graph.addEdge(node5, node6);
    graph.addEdge(node6, node8);

    builder
      ..nodeSeparation = (15)
      ..levelSeparation = (15)
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabs(
      draggable: true,
      tabViewSizeResolver: PlutoLayoutTabViewSizeConstrains(
        initialSize: MediaQuery.of(context).size.width / 3,
      ),
      items: [
        PlutoLayoutTabItem(
          id: "Symbolic Tree",
          title: "Symbolic Tree",
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(5),
            child: testGraph(),
          ),
        ),
        PlutoLayoutTabItem(
          id: "Stats",
          title: "Stats",
          tabViewWidget: const Padding(
            padding: EdgeInsets.all(5),
            child: stats(),
          ),
        ),
        PlutoLayoutTabItem(
          id: "File Stats",
          title: "File Stats",
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(5),
            child: _StatsListStles(
              context: context,
              newTabResolver: widget.newTabResolver,
            ),
          ),
        ),
        PlutoLayoutTabItem(
          id: "Variable Bounds",
          title: "Variable Bounds",
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(5),
            child: _SymbolicConcreteList(context: context),
          ),
        ),
      ],
    );
  }
}

class stats extends StatelessWidget {
  const stats({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
            color: Color.fromARGB(255, 59, 59, 59),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'General stats about the program:',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
              const Divider(),
              /*Text(
                'Program Name: ${symProgram.programName}',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),*/
              Text(
                'Code files: ${symProgram.codeFilesList.length}',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
              Text(
                'Hard bounds: ${symProgram.numberOfHardbounds}',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
              Text(
                'Hard bound values: ${symProgram.numerOfSymValues}',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
              Text(
                'Hard bound violations: ${symProgram.numberOfHardBoundViolations}',
                style: genericTextStyle,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
              Text(
                'Coverage: ${symProgram.coveragePercentage}%',
                style: TextStyle(
                        fontSize: 15,
                        color: symProgram.coveragePercentage
                                    .startsWith("9") ||
                                symProgram.coveragePercentage
                                    .startsWith("100")
                            ? Colors.green
                            : Colors.red,
                      ),
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SymbolicConcreteList extends StatelessWidget {
  const _SymbolicConcreteList({required BuildContext context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        context.watch<SymbolicConcreteList>().codeFileIndex == -1
            ? const SizedBox()
            : Container(
                color: const Color.fromARGB(255, 56, 56, 56),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Center(
                  child: Text(
                    symProgram
                        .codeFilesList[
                            context.watch<SymbolicConcreteList>().codeFileIndex]
                        .fileName,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: 30,
          child: TextField(
            controller: symConcTextFieldController,
            cursorColor: const Color.fromARGB(255, 187, 187, 187),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 17,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 187, 187, 187),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
            ),
            onChanged: (query) {
              Provider.of<SymbolicConcreteList>(context, listen: false)
                  .searchSCCodeLines(query);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: const PageStorageKey("symBolicConcreteValues"),
            itemCount:
                context.watch<SymbolicConcreteList>().codeLinesSCSearch.length,
            scrollDirection: Axis.vertical,
            controller: scrollControllerSymConcList,
            itemBuilder: (context, index) {
              return AutoScrollTag(
                key: ValueKey(index),
                index: index,
                controller: scrollControllerSymConcList,
                child: Container(
                  //height: 200,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                    color: Color.fromARGB(255, 59, 59, 59),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          int codeFileIndex = Provider.of<SymbolicConcreteList>(
                                  context,
                                  listen: false)
                              .codeFileIndex;
                          int pressedLine = Provider.of<SymbolicConcreteList>(
                                  context,
                                  listen: false)
                              .codeLinesSCSearch[index]
                              .line;
                          symProgram.scrollToLineInCode(
                              codeFileIndex, pressedLine);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].line}',
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                      const Divider(),
                      Flexible(
                        child: ListView.builder(
                          key: const PageStorageKey("symBolicConcreteValues"),
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: context
                              .watch<SymbolicConcreteList>()
                              .codeLinesSCSearch[index]
                              .symbolicValues
                              .length,
                          itemBuilder: (context, index2) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 0,
                              ),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2),
                                ),
                                color: context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].aktValue < context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].minValue || context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].aktValue > context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].maxValue ?
                                
                                
                                 const Color.fromARGB(255, 255, 94, 82) : Theme.of(context)
                                    .cardColor, // or secondaryHeaderColor
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // TODO use one const style for all
                                children: [
                                  /*Text(
                                    context
                                        .watch<SymbolicConcreteList>()
                                        .codeLinesSCSearch[index]
                                        .symbolicValues[index2]
                                        .varName,
                                  ),*/
                                  Text(
                                    ' Actual Value: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].aktValue}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  Text(
                                    ' In Hexadecimal: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].aktValueHex}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    ' Minimum Value: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].minValue}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  Text(
                                    ' In Hexadecimal: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].minValueHex}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    ' Maximum Value: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].maxValue}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                  Text(
                                    ' In Hexadecimal: ${context.watch<SymbolicConcreteList>().codeLinesSCSearch[index].symbolicValues[index2].maxValueHex}',
                                    style: genericTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatsListStles extends StatelessWidget {
  _StatsListStles(
      {required BuildContext context, required this.newTabResolver}) {
    eventStreamController = PlutoLayout.getEventStreamController(context);
  }

  PlutoLayoutEventStreamController? eventStreamController;
  final PlutoLayoutActionInsertTabItemResolver newTabResolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: TextField(
            controller: statsTextFieldController,
            cursorColor: const Color.fromARGB(255, 187, 187, 187),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 17,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 187, 187, 187),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
            ),
            onChanged: (query) {
              Provider.of<CodeFilesStats>(context, listen: false)
                  .searchCodeFilesStats(query);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: const PageStorageKey("StatsList"),
            itemCount: context.watch<CodeFilesStats>().codeFilesStats.length,
            prototypeItem: Container(
              height: 200,
              margin: const EdgeInsets.all(5),
            ),
            itemBuilder: (context, index) {
              return Container(
                height: 200,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        symProgram.openCodeFile<CodeFilesStats>(index,
                            eventStreamController, newTabResolver, context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context
                              .watch<CodeFilesStats>()
                              .codeFilesStats[index]
                              .fileName,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Path: ${context.watch<CodeFilesStats>().codeFilesStats[index].filePath}',
                      style: genericTextStyle,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                    ),
                    Text(
                      'Hard bounds: ${context.watch<CodeFilesStats>().codeFilesStats[index].numberOfHardBounds}',
                      style: genericTextStyle,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      'Hard bound values: ${context.watch<CodeFilesStats>().codeFilesStats[index].numberOfSymbolicValues}',
                      style: genericTextStyle,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      'Hard bound violations: ${context.watch<CodeFilesStats>().codeFilesStats[index].numberOfHardBoundViolations}',
                      style: genericTextStyle,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      'Coverage: ${context.watch<CodeFilesStats>().codeFilesStats[index].coveragePercentage}%',
                      style: TextStyle(
                        fontSize: 15,
                        color: context
                                    .watch<CodeFilesStats>()
                                    .codeFilesStats[index]
                                    .coveragePercentage
                                    .startsWith("9") ||
                                context
                                    .watch<CodeFilesStats>()
                                    .codeFilesStats[index]
                                    .coveragePercentage
                                    .startsWith("100")
                            ? Colors.green
                            : Colors.red,
                      ),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget testGraph() {
  return InteractiveViewer(
    constrained: false,
    boundaryMargin: const EdgeInsets.all(double.infinity),
    minScale: 0.0001,
    maxScale: 10.0,
    child: GraphView(
      graph: graph,
      algorithm: SugiyamaAlgorithm(builder),
      paint: Paint()
        ..color = Colors.green
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
      builder: (Node node) {
        // I can decide what widget should be shown here based on the id
        // TODO: should make save that node-key cant be null
        var a = node.key!.value as int;

        return rectangleWidget(a);
      },
    ),
  );
}

Widget rectangleWidget(int a) {
  return InkWell(
    onTap: () {
      print('Graphnode clicked');
    },
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 175, 231, 176),
      ),
      child: Column(
        children: [
          Text(
            graphNodesArr[a].file,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            graphNodesArr[a].funcName,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "lines ${graphNodesArr[a].fromLine.toString()} - ${graphNodesArr[a].toLine.toString()}",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
