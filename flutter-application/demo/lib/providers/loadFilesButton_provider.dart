

import 'package:flutter/material.dart';

// to indicate if the button on startpage that loads the codeFiles is active or not
class LoadFilesButton with ChangeNotifier {
  bool _loadFiles = false;

  bool get loadFiles => _loadFiles;

  void setLoadFiles(final bool newVal) {
    _loadFiles = newVal;
    notifyListeners();
  }

  void reset() {
    _loadFiles = false;
    notifyListeners();
  }
}
