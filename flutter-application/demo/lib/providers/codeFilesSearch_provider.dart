import 'package:flutter/material.dart';
import 'package:symtrace/data/codeFile.dart';

import '../data/symProgram.dart';

// for the left CodeFiles tab
class CodeFilesSearch with ChangeNotifier {
  List<CodeFile> _codeFilesSearch = [];

  List<CodeFile> get codeFilesSearch => _codeFilesSearch;

  void init() {
    _codeFilesSearch = symProgram.codeFilesList;
    notifyListeners();
  }

  void searchCodeFiles(String query) {
    _codeFilesSearch = symProgram.codeFilesList.where((cf) {
      final fileName = cf.fileName.toLowerCase();
      final input = query.toLowerCase();
      return fileName.contains(input);
    }).toList();

    notifyListeners();
  }

  void reset() {
    _codeFilesSearch = [];
  }
}
