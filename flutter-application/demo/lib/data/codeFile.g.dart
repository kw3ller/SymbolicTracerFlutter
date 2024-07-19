// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codeFile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeFile _$CodeFileFromJson(Map<String, dynamic> json) => CodeFile(
      json['fileName'] as String,
      (json['codeLines'] as List<dynamic>)
          .map((e) => CodeLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CodeFileToJson(CodeFile instance) => <String, dynamic>{
      'fileName': instance.filePath,
      'codeLines': instance.codeLines.map((e) => e.toJson()).toList(),
    };
