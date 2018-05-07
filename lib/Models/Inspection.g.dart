// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Inspection.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Inspection _$InspectionFromJson(Map<String, dynamic> json) => new Inspection(
    inspectionDate: json['inspectionDate'] == null
        ? null
        : DateTime.parse(json['inspectionDate'] as String),
    staffName: json['staffName'] as String,
    userid: json['userid'] as String,
    id: json['id'] as String);

abstract class _$InspectionSerializerMixin {
  String get id;
  DateTime get inspectionDate;
  String get staffName;
  String get userid;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'inspectionDate': inspectionDate?.toIso8601String(),
        'staffName': staffName,
        'userid': userid
      };
}
