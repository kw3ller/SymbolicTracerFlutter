import 'package:flutter/material.dart';
import 'package:symtrace/data/codeLine.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../data/symProgram.dart';
import '../tabs/right_tab.dart';

class SymbolicConcreteList with ChangeNotifier {
  int _codeFileIndex = -1;
  List<CodeLine> _codeLinesSCSearch = [];
  int _clickedLine = -1;

  int get codeFileIndex => _codeFileIndex;
  List<CodeLine> get codeLinesSCSearch => _codeLinesSCSearch;
  int get clickedLine => _clickedLine;

  // when another codeFile is selected the symbolic/concrete values should also change
  void changeCodeFile(int codeFileIndex, [int clickedLine = -1]) async {
    _clickedLine = clickedLine;
    if (_codeFileIndex == codeFileIndex) {
      scrollToSCCodeLine();
      return;
    }

    // reset search of symbolic/concrete values
    symConcTextFieldController.text = '';
    _codeFileIndex = codeFileIndex;

    // take only the codeLines from the codeFile with non empty symbolic/concrete value lists
    // (has already been sorted at startup)
    _codeLinesSCSearch = symProgram.codeFilesList[_codeFileIndex]
        .codeLines
        .where((element) => element.symbolicValues.isNotEmpty)
        .toList();

    notifyListeners();

    // sadly notify listeners is kinda asynchrone but not really so there is no way unless we wait for it like this
    // and hope it is ready by that time. Otherwise it just won't scroll to the right position  ¯\_(ツ)_/¯
    await Future.delayed(const Duration(milliseconds: 50));
    scrollToSCCodeLine();
  }

  void searchSCCodeLines(String query) {
    _clickedLine = -1;
    // TODO: also search for varNames
    _codeLinesSCSearch = symProgram.codeFilesList[_codeFileIndex]
        .codeLines
        .where((element) =>
            element.symbolicValues.isNotEmpty &&
            element.line.toString().contains(query))
        .toList();
    notifyListeners();
  }

  // scroll in the symbolic/concrete list 
  void scrollToSCCodeLine() {
    int index =
        _codeLinesSCSearch.indexWhere((element) => element.line == _clickedLine);
    if (index >= 0) {
      scrollControllerSymConcList.scrollToIndex(index,
          preferPosition: AutoScrollPosition.begin);
    }
  }

  void reset() {
    _codeFileIndex = -1;
    _codeLinesSCSearch = [];
    _clickedLine = -1;
  }
}
