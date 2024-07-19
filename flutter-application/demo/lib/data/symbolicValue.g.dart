// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbolicValue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolicValue _$SymbolicValueFromJson(Map<String, dynamic> json) =>
    SymbolicValue(
      varName: json['var_name'] as String? ?? "",
      aktValue: json['akt_value'] as int? ?? -1,
      minValue: json['min_value'] as int? ?? -1,
      maxValue: json['max_value'] as int? ?? -1,
    );

Map<String, dynamic> _$SymbolicValueToJson(SymbolicValue instance) =>
    <String, dynamic>{
      'var_name': instance.varName,
      'akt_value': instance.aktValue,
      'min_value': instance.minValue,
      'max_value': instance.maxValue,
    };
