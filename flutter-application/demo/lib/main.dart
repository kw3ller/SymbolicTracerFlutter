import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:symtrace/providers/codeDetails_provider.dart';
import 'package:symtrace/providers/codeFilesSearch_provider.dart';
import 'package:symtrace/providers/codeFilesStats_provider.dart';
import 'package:symtrace/providers/loadFilesButton_provider.dart';
import 'package:symtrace/providers/symbolicConcreteList_provider.dart';

import 'data/codeFile.dart';

import 'data/symProgram.dart';
import 'screens/screens.dart';
import 'tabs/tabs.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CodeFilesSearch()),
      ChangeNotifierProvider(create: (_) => CodeFilesStats()),
      ChangeNotifierProvider(create: (_) => CodeDetails()),
      ChangeNotifierProvider(create: (_) => LoadFilesButton()),
      ChangeNotifierProvider(create: (_) => SymbolicConcreteList()),
    ],
    child: const DemoApp(),
  ));
  // runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IOT4U",
      theme: ThemeData.dark(),
      home: const StartPage(),
    );
  }
}

// first page the user will see
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: true,
        ),
        child: StartScreen(),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  PlutoInsertTabItemResult newTabResolver(
      {required List<PlutoLayoutTabItem> items}) {
    return PlutoInsertTabItemResult(
      item: PlutoLayoutTabItem(
        id: symProgram.selectedCodeFileIndex,
        title:
            symProgram.codeFilesList[symProgram.selectedCodeFileIndex].fileName,
        enabled: false,
        tabViewWidget: _NewCode(
          codeFileIndex: symProgram.selectedCodeFileIndex,
          scrollControllerIndex:
              symProgram.openCodeFilesScrollControllers.length - 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
          },
          scrollbars: true,
        ),
        child: PlutoLayout(
          body: const PlutoLayoutContainer(
            child: HomeScreen(),
          ),
          /*top: PlutoLayoutContainer(
            child: TopTab(newTabResolver: newTabResolver),
          ), */
          left: PlutoLayoutContainer(
            child: LeftTab(
              newTabResolver: newTabResolver,
            ),
          ),
          right: PlutoLayoutContainer(
            child: RightTab(
              newTabResolver: newTabResolver,
            ),
          ),
          bottom: const PlutoLayoutContainer(
            child: BottomTab(),
          ),
        ),
      ),
    );
  }
}

class _NewCode extends StatelessWidget {
  _NewCode({required this.codeFileIndex, required this.scrollControllerIndex}) {
    constructLineIndexList();
  }

  // to overlay the details
  OverlayEntry? entry;

  // List of CodeLine and their index in the selected CodeFile
  Map lineIndexMap = {};

  // the fileIndex this is building
  final int codeFileIndex;
  // the index of the autoScrollController it shall use
  final int scrollControllerIndex;

  // We want List of codelines in CodeLines and their index
  void constructLineIndexList() {
    for (int i = 0;
        i < symProgram.codeFilesList[codeFileIndex].codeLines.length;
        i++) {
      lineIndexMap[symProgram.codeFilesList[codeFileIndex].codeLines[i].line] =
          i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 45,
              color: const Color.fromARGB(255, 56, 56, 56),
              margin: const EdgeInsets.fromLTRB(3, 0, 3, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 22,
                    child: Text(
                      symProgram.codeFilesList[codeFileIndex].filePath,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 238, 82),
                              border: Border(
                                right: BorderSide(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              ' line',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            width: 90,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 48, 169, 250),
                              border: Border(
                                right: BorderSide(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              ' lCov',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 76, 183, 255),
                              border: Border(
                                right: BorderSide(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              ' bCount',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            width: 90,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 121, 200, 253),
                              border: Border(
                                right: BorderSide(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              ' bCov',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 40,
                          fit: FlexFit.loose,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            color: const Color.fromARGB(255, 168, 220, 255),
                            child: const Text(
                              ' source code',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                key: PageStorageKey(codeFileIndex),
                itemCount: symProgram
                    .codeFilesList[codeFileIndex].codeLinesContent.length,
                prototypeItem: Container(
                  height: 22,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                ),
                scrollDirection: Axis.vertical,
                controller: symProgram
                    .openCodeFilesScrollControllers[scrollControllerIndex],
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: symProgram
                        .openCodeFilesScrollControllers[scrollControllerIndex],
                    child: InkWell(
                      onTap: () {
                        Provider.of<SymbolicConcreteList>(context,
                                listen: false)
                            .changeCodeFile(codeFileIndex, index + 1);
                      },
                      child: Container(
                        height: 22,
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                        margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // the line box
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                width: 40,
                                decoration: BoxDecoration(
                                  color: lineIndexMap.containsKey(index + 1)
                                      ? (symProgram
                                              .codeFilesList[codeFileIndex]
                                              .codeLines[
                                                  lineIndexMap[index + 1]]
                                              .symbolicValues
                                              .isNotEmpty
                                          ? const Color.fromARGB(
                                              255, 196, 178, 18)
                                          : const Color.fromARGB(
                                              255, 255, 244, 149))
                                      : const Color.fromARGB(
                                          255, 255, 244, 149),
                                  border: const Border(
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 194, 194, 194),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // the normal excution Box
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                width: 90,
                                decoration: BoxDecoration(
                                  color: lineIndexMap.containsKey(index + 1)
                                      ? (symProgram
                                                  .codeFilesList[codeFileIndex]
                                                  .codeLines[
                                                      lineIndexMap[index + 1]]
                                                  .exeCount !=
                                              0
                                          ? const Color.fromARGB(
                                              255, 175, 231, 176)
                                          : const Color.fromARGB(
                                              255, 255, 134, 125))
                                      : const Color.fromARGB(
                                          255, 233, 233, 233),
                                  border: const Border(
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 194, 194, 194),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  lineIndexMap.containsKey(index + 1)
                                      ? symProgram
                                          .codeFilesList[codeFileIndex]
                                          .codeLines[lineIndexMap[index + 1]]
                                          .exeCount
                                          .toString()
                                      : "0",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            // the branch count box
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                width: 50,
                                decoration: BoxDecoration(
                                  color: lineIndexMap.containsKey(index + 1)
                                      ? (symProgram
                                                  .codeFilesList[codeFileIndex]
                                                  .codeLines[
                                                      lineIndexMap[index + 1]]
                                                  .branchCount !=
                                              0
                                          ? const Color.fromARGB(
                                              255, 175, 231, 176)
                                          : const Color.fromARGB(
                                              255, 233, 233, 233))
                                      : const Color.fromARGB(
                                          255, 233, 233, 233),
                                  border: const Border(
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 194, 194, 194),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  lineIndexMap.containsKey(index + 1)
                                      ? symProgram
                                          .codeFilesList[codeFileIndex]
                                          .codeLines[lineIndexMap[index + 1]]
                                          .branchCount
                                          .toString()
                                      : "0",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            // the branch execution box
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                width: 90,
                                decoration: BoxDecoration(
                                  color: lineIndexMap.containsKey(index + 1)
                                      ? (symProgram
                                                  .codeFilesList[codeFileIndex]
                                                  .codeLines[
                                                      lineIndexMap[index + 1]]
                                                  .branchExeCount !=
                                              0
                                          ? const Color.fromARGB(
                                              255, 175, 231, 176)
                                          : (symProgram
                                                      .codeFilesList[
                                                          codeFileIndex]
                                                      .codeLines[lineIndexMap[
                                                          index + 1]]
                                                      .branchCount !=
                                                  0
                                              ? const Color.fromARGB(
                                                  255, 255, 134, 125)
                                              : const Color.fromARGB(
                                                  255, 233, 233, 233)))
                                      : const Color.fromARGB(
                                          255, 233, 233, 233),
                                  border: const Border(
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 194, 194, 194),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  lineIndexMap.containsKey(index + 1)
                                      ? symProgram
                                          .codeFilesList[codeFileIndex]
                                          .codeLines[lineIndexMap[index + 1]]
                                          .branchExeCount
                                          .toString()
                                      : "0",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            // the Code Box
                            Flexible(
                              flex: 40,
                              fit: FlexFit.tight,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                color: lineIndexMap.containsKey(index + 1)
                                    ? (symProgram
                                                    .codeFilesList[
                                                        codeFileIndex]
                                                    .codeLines[
                                                        lineIndexMap[index + 1]]
                                                    .branchExeCount !=
                                                0 ||
                                            symProgram
                                                    .codeFilesList[
                                                        codeFileIndex]
                                                    .codeLines[
                                                        lineIndexMap[index + 1]]
                                                    .exeCount !=
                                                0
                                        ? const Color.fromARGB(
                                            255, 175, 231, 176)
                                        : const Color.fromARGB(
                                            255, 255, 134, 125))
                                    : const Color.fromARGB(255, 233, 233, 233),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      child: Text(
                                        lineIndexMap.containsKey(index + 1)
                                            ? (symProgram
                                                    .codeFilesList[
                                                        codeFileIndex]
                                                    .codeLines[
                                                        lineIndexMap[index + 1]]
                                                    .symbolicValues
                                                    .isNotEmpty
                                                ? 'HB'
                                                : '')
                                            : '',
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        symProgram.codeFilesList[codeFileIndex]
                                            .codeLinesContent[index],
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: GoogleFonts.robotoMono(
                                          textStyle: const TextStyle(
                                            fontSize: 14.5,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // return either the details button or container
        context.watch<CodeDetails>().codeDetails
            ? CodeDetailsContainer(context, codeFileIndex)
            : CodeDetailsButton(context),
      ],
    );
  }
}

Widget CodeDetailsContainer(BuildContext context, int codeFileIndex) {
  return Positioned(
    right: 5,
    bottom: 3,
    child: Container(
      width: 300,
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Color.fromARGB(255, 59, 59, 59),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 3,
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Provider.of<CodeDetails>(context, listen: false).toggleDetails();
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Code Details'),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  // <-- Icon
                  Icons.close,
                  size: 24.0,
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hard bounds: ${symProgram.codeFilesList[codeFileIndex].numberOfHardBounds}',
                  style: genericTextStyle,
                ),
                Text(
                  'Hard bound values: ${symProgram.codeFilesList[codeFileIndex].numberOfSymbolicValues}',
                  style: genericTextStyle,
                ),
                Text(
                  'Hard bound violations: ${symProgram.codeFilesList[codeFileIndex].numberOfHardBoundViolations}',
                  style: genericTextStyle,
                ),
                Text(
                  'Coverage: ${symProgram.codeFilesList[codeFileIndex].coveragePercentage}%',
                  style: TextStyle(
                        fontSize: 15,
                        color: symProgram.codeFilesList[codeFileIndex].coveragePercentage
                                    .startsWith("9") ||
                                symProgram.codeFilesList[codeFileIndex].coveragePercentage
                                    .startsWith("100")
                            ? Colors.green
                            : Colors.red,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget CodeDetailsButton(BuildContext context) {
  return Positioned(
    right: 7,
    bottom: 5,
    child: TextButton(
      onPressed: () {
        Provider.of<CodeDetails>(context, listen: false).toggleDetails();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Code Details',
        ),
      ),
    ),
  );
}
