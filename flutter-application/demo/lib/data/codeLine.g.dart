// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codeLine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeLine _$CodeLineFromJson(Map<String, dynamic> json) => CodeLine(
      json['line'] as int,
      exeCount: json['exe_count'] as int? ?? 0,
      branchCount: json['branch_count'] as int? ?? 0,
      branchExeCount: json['branch_exe_count'] as int? ?? 0,
      symbolicValues: (json['symbolic_values'] as List<dynamic>?)
              ?.map((e) => SymbolicValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hardBounds: (json['hard_bounds'] as List<dynamic>?)
              ?.map((e) => HardBound.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CodeLineToJson(CodeLine instance) => <String, dynamic>{
      'line': instance.line,
      'exe_count': instance.exeCount,
      'branch_count': instance.branchCount,
      'branch_exe_count': instance.branchExeCount,
      'symbolic_values': instance.symbolicValues.map((e) => e.toJson()).toList(),
      'hard_bounds': instance.symbolicValues.map((e) => e.toJson()).toList(),
    };
