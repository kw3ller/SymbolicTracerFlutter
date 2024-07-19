


import 'package:json_annotation/json_annotation.dart';
import 'package:symtrace/data/hardBound.dart';
import 'package:symtrace/data/symbolicValue.dart';

part 'codeLine.g.dart';

@JsonSerializable(explicitToJson: true)
class CodeLine {

  int line = -1;
  int exeCount = 0;
  int branchCount = 0;
  int branchExeCount = 0;
  List<SymbolicValue> symbolicValues = [];
  List<HardBound> hardBounds = [];

  CodeLine(this.line, {this.exeCount = 0, this.branchCount = 0, this.branchExeCount = 0, this.symbolicValues = const [], this.hardBounds = const []});

  factory CodeLine.fromJson(Map<String, dynamic> data) => _$CodeLineFromJson(data);

  Map<String, dynamic> toJson() => _$CodeLineToJson(this);
}