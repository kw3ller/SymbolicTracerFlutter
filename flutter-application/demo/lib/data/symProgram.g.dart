// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symProgram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymProgram _$SymProgramFromJson(Map<String, dynamic> json) => SymProgram(
      (json['codeFiles'] as List<dynamic>)
          .map((e) => CodeFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      programName: json['programName'] as String? ?? "",
    );

Map<String, dynamic> _$SymProgramToJson(SymProgram instance) =>
    <String, dynamic>{
      'programName': instance.programName,
      'codeFiles': instance.codeFilesList.map((e) => e.toJson()).toList(),
    };
