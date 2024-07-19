import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pluto_layout/pluto_layout.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:provider/provider.dart';
import 'package:symtrace/providers/codeFilesSearch_provider.dart';

import '../providers/codeFilesStats_provider.dart';
import 'codeFile.dart';

part 'symProgram.g.dart';

@JsonSerializable(explicitToJson: true)
class SymProgram {
  String programName = '';
  List<CodeFile> codeFilesList = [];

  // not from JSON, but for later use
  int selectedCodeFileIndex = -1;

  // the two below should ALWAYS be maintained together 
  List<int> openCodeFilesIndex = [];
  List<AutoScrollController> openCodeFilesScrollControllers = [];

  // number of all hardbounds in the program
  int numberOfHardbounds = 0;
  // number of all symbolic values
  int numerOfSymValues = 0;
  // number of all hardBound violations
  int numberOfHardBoundViolations = 0;

  // total coverage of the program
  String coveragePercentage = "0.00";


  SymProgram(this.codeFilesList, {this.programName = ""});

  // to open a codeFile as a tab and show it to the user
  void openCodeFile<T>(
      int index,
      PlutoLayoutEventStreamController? eventStreamController,
      final PlutoLayoutActionInsertTabItemResolver newTabResolver,
      BuildContext context) {
    if (T == CodeFilesStats) {
      selectedCodeFileIndex = codeFilesList.indexOf(
          Provider.of<CodeFilesStats>(context, listen: false)
              .codeFilesStats[index]);
    } else if (T == CodeFilesSearch) {
      selectedCodeFileIndex = symProgram.codeFilesList.indexOf(
          Provider.of<CodeFilesSearch>(context, listen: false)
              .codeFilesSearch[index]);
    } else {
      return;
    }

    if (!openCodeFilesIndex.contains(selectedCodeFileIndex)) {
      openCodeFilesIndex.add(selectedCodeFileIndex);
      openCodeFilesScrollControllers.add(AutoScrollController());
      eventStreamController?.add(
        PlutoInsertTabItemEvent(
          layoutId: PlutoLayoutId.body,
          itemResolver: newTabResolver,
        ),
      );
    }
  }

  // scroll inside of codeView to the specified line
  void scrollToLineInCode(int codeFileIndex, int line) {
    int index = openCodeFilesIndex.indexOf(codeFileIndex);
    if (index < 0 || line < 0) {
      return;
    }
    openCodeFilesScrollControllers[index]
        .scrollToIndex(line - 1, preferPosition: AutoScrollPosition.begin);
  }

  // to reset all data to start
  void reset() {
    programName = '';
    codeFilesList = [];
    selectedCodeFileIndex = -1;
    openCodeFilesIndex = [];
    openCodeFilesScrollControllers = [];
    numberOfHardbounds = 0;
    numerOfSymValues = 0;
  }

  factory SymProgram.fromJson(Map<String, dynamic> data) =>
      _$SymProgramFromJson(data);

  Map<String, dynamic> toJson() => _$SymProgramToJson(this);
}

SymProgram symProgram = SymProgram([]);
