import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Inspection.g.dart';

//run code => flutter packages pub run build_runner build
@JsonSerializable()
class Inspection extends Object with _$InspectionSerializerMixin {
  Inspection(
      {this.inspectionDate,
      this.staffName,
      this.arrivedTime,
      this.leaveTime,
      this.foundLocation,
      this.postName,
      this.guestsProportion,
      this.situationRemark,
      this.userid,
      this.id,
      this.grooming});

  String id;

  @JsonSerializable(nullable: false)
  DateTime inspectionDate;

  @JsonSerializable(nullable: false)
  String arrivedTime;

  @JsonSerializable(nullable: false)
  String leaveTime;

  @JsonSerializable(nullable: false)
  String staffName;

  @JsonSerializable(nullable: false)
  String postName;

  @JsonSerializable(nullable: false)
  String foundLocation;

  @JsonSerializable(nullable: false)
  String guestsProportion;

  @JsonSerializable(nullable: false)
  String situationRemark;

  @JsonKey(nullable: false)
  String userid;

  @JsonKey(nullable: false)
  Grooming grooming;

  static Inspection fromDocument(DocumentSnapshot document) =>
      new Inspection.fromJson(document.data);

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

@JsonSerializable()
class Grooming extends Object with _$GroomingSerializerMixin {
  Grooming();
  @JsonKey(nullable: false)
  int groomingScore;

  @JsonKey(nullable: false)
  int hairScore;

  @JsonKey(nullable: false)
  int uniformScore;

  @JsonKey(nullable: false)
  int decorationScore;

  @JsonKey(nullable: false)
  int maskWearScore;

  @JsonKey(nullable: false)
  int maskCleanScore;

  factory Grooming.fromJson(Map<String, dynamic> json) =>
      _$GroomingFromJson(json);
}
