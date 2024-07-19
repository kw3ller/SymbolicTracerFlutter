
import 'package:json_annotation/json_annotation.dart';

part 'symbolicValue.g.dart';

@JsonSerializable()
class SymbolicValue {
  String varName = "";
  int aktValue = -1;
  int minValue = -1;
  int maxValue = -1;

  // the values above will be converted into this at startScreen
  String aktValueHex = "-1";
  String minValueHex = "-1";
  String maxValueHex = "-1";

  SymbolicValue({this.varName = "", this.aktValue = -1, this.minValue = -1, this.maxValue = -1});

  factory SymbolicValue.fromJson(Map<String, dynamic> data) => _$SymbolicValueFromJson(data);

  Map<String, dynamic> toJson() => _$SymbolicValueToJson(this);
}

