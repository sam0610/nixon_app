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
    arrivedTime: json['arrivedTime'] as String,
    leaveTime: json['leaveTime'] as String,
    foundLocation: json['foundLocation'] as String,
    postName: json['postName'] as String,
    guestsProportion: json['guestsProportion'] as String,
    situationRemark: json['situationRemark'] as String,
    userid: json['userid'] as String,
    id: json['id'] as String,
    grooming: new Grooming.fromJson(json['grooming'] as Map<String, dynamic>));

abstract class _$InspectionSerializerMixin {
  String get id;
  DateTime get inspectionDate;
  String get arrivedTime;
  String get leaveTime;
  String get staffName;
  String get postName;
  String get foundLocation;
  String get guestsProportion;
  String get situationRemark;
  String get userid;
  Grooming get grooming;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'inspectionDate': inspectionDate?.toIso8601String(),
        'arrivedTime': arrivedTime,
        'leaveTime': leaveTime,
        'staffName': staffName,
        'postName': postName,
        'foundLocation': foundLocation,
        'guestsProportion': guestsProportion,
        'situationRemark': situationRemark,
        'userid': userid,
        'grooming': grooming
      };
}

Grooming _$GroomingFromJson(Map<String, dynamic> json) => new Grooming()
  ..groomingScore = json['groomingScore'] as int
  ..hairScore = json['hairScore'] as int
  ..uniformScore = json['uniformScore'] as int
  ..decorationScore = json['decorationScore'] as int
  ..maskWearScore = json['maskWearScore'] as int
  ..maskCleanScore = json['maskCleanScore'] as int;

abstract class _$GroomingSerializerMixin {
  int get groomingScore;
  int get hairScore;
  int get uniformScore;
  int get decorationScore;
  int get maskWearScore;
  int get maskCleanScore;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'groomingScore': groomingScore,
        'hairScore': hairScore,
        'uniformScore': uniformScore,
        'decorationScore': decorationScore,
        'maskWearScore': maskWearScore,
        'maskCleanScore': maskCleanScore
      };
}
