import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:symtrace/data/codeFile.dart';

import 'package:provider/provider.dart';
import 'package:symtrace/providers/codeDetails_provider.dart';
import 'package:symtrace/providers/codeFilesSearch_provider.dart';
import 'package:symtrace/providers/codeFilesStats_provider.dart';
import 'package:symtrace/providers/loadFilesButton_provider.dart';
import 'package:symtrace/providers/symbolicConcreteList_provider.dart';
import 'package:symtrace/tabs/right_tab.dart';

import '../data/symProgram.dart';

// for search in left Tab
TextEditingController filesTextFieldController = TextEditingController();

class LeftTab extends StatefulWidget {
  const LeftTab({required this.newTabResolver, super.key});

  final PlutoLayoutActionInsertTabItemResolver newTabResolver;

  @override
  State<LeftTab> createState() => _LeftTabState();
}

class _LeftTabState extends State<LeftTab> {
  PlutoLayoutEventStreamController? eventStreamController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoLayoutTabs(
      draggable: true,
      tabViewSizeResolver: const PlutoLayoutTabViewSizeConstrains(
        initialSize: 200,
      ),
      items: [
        PlutoLayoutTabItem(
          id: "Code Files",
          title: "Code Files",
          sizeResolver: const PlutoLayoutTabItemSizeInitial(300),
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(5),
            child: _CodeList(
              context: context,
              newTabResolver: widget.newTabResolver,
            ),
          ),
        ),
        PlutoLayoutTabItem(
          id: "Settings",
          title: "Settings",
          sizeResolver: const PlutoLayoutTabItemSizeFlexible(0.3),
          tabViewWidget: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView(
              children: [
                const Text(
                  'Go back to the startpage:',
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  onPressed: () {
                    // go back to start_screen
                    Navigator.pop(context);

                    // reset all data
                    symProgram.reset();

                    // reset all textfieldControllers for searching
                    filesTextFieldController.text = '';
                    statsTextFieldController.text = '';
                    symConcTextFieldController.text = '';

                    // reset all providers
                    Provider.of<CodeDetails>(context, listen: false).reset();
                    Provider.of<CodeFilesSearch>(context, listen: false)
                        .reset();
                    Provider.of<CodeFilesStats>(context, listen: false).reset();
                    Provider.of<LoadFilesButton>(context, listen: false)
                        .reset();
                    Provider.of<SymbolicConcreteList>(context, listen: false)
                        .reset();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Startpage',
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CodeList extends StatelessWidget {
  _CodeList({required BuildContext context, required this.newTabResolver}) {
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
            controller: filesTextFieldController,
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
              Provider.of<CodeFilesSearch>(context, listen: false)
                  .searchCodeFiles(query);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            // maybe this makes it slow (its to preserve scrollposition after tab close)
            key: const PageStorageKey("codeFilesList"),
            itemCount: context.watch<CodeFilesSearch>().codeFilesSearch.length,
            itemBuilder: (context, index) {
              return Tooltip(
                message: context
                    .watch<CodeFilesSearch>()
                    .codeFilesSearch[index]
                    .filePath,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    symProgram.openCodeFile<CodeFilesSearch>(
                        index, eventStreamController, newTabResolver, context);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context
                          .watch<CodeFilesSearch>()
                          .codeFilesSearch[index]
                          .fileName,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
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
