

import 'codeLine.dart';

import 'package:json_annotation/json_annotation.dart';

part 'codeFile.g.dart';

@JsonSerializable(explicitToJson: true)
class CodeFile {
  // path to RIOT root folder
  String filePath = "";
  // partial filePath seen from RIOT root folder
  String fileName = "";

  // not in JSON but will be needed later
  int numberOfSymbolicValues = 0;
  int numberOfHardBounds = 0;

  // not in JSON but will be needed later
  String coveragePercentage = "0.00";

  // not in JSON but will be needed later
  int numberOfHardBoundViolations = 0;

  List<CodeLine> codeLines = [];
  List<String> codeLinesContent = [];

  CodeFile(this.filePath, this.codeLines);

  factory CodeFile.fromJson(Map<String, dynamic> data) =>
      _$CodeFileFromJson(data);

  Map<String, dynamic> toJson() => _$CodeFileToJson(this);
}


