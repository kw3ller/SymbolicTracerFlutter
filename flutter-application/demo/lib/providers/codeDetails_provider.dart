import 'package:flutter/material.dart';

class CodeDetails with ChangeNotifier {
  bool _codeDetails = false;

  bool get codeDetails => _codeDetails;

  void toggleDetails() {
    _codeDetails = !_codeDetails;
    notifyListeners();
  }

  void reset() {
    _codeDetails = false;
  }
}