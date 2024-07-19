import 'package:json_annotation/json_annotation.dart';

part 'hardBound.g.dart';

@JsonSerializable()
class HardBound {
  String varName = "";

  HardBound({this.varName = ""});

  factory HardBound.fromJson(Map<String, dynamic> data) => _$HardBoundFromJson(data);

  Map<String, dynamic> toJson() => _$HardBoundToJson(this);
}