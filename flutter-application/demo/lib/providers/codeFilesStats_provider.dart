import 'package:flutter/material.dart';
import 'package:symtrace/data/codeFile.dart';

import '../data/symProgram.dart';

// for the left CodeFiles tab
class CodeFilesStats with ChangeNotifier {
  List<CodeFile> _codeFilesStats = [];

  List<CodeFile> get codeFilesStats => _codeFilesStats;

  void init() {
    _codeFilesStats = symProgram.codeFilesList;
    notifyListeners();
  }

  void searchCodeFilesStats(String query) {
    _codeFilesStats = symProgram.codeFilesList.where((cf) {
      final fileName = cf.fileName.toLowerCase();
      final input = query.toLowerCase();
      return fileName.contains(input);
    }).toList();

    notifyListeners();
  }

  void reset() {
    _codeFilesStats = [];
  }
}