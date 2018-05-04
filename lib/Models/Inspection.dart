import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Inspection.g.dart';

@JsonSerializable()
class Inspection extends Object with _$InspectionSerializerMixin {
  Inspection(this.inspectionDate, {this.userid, this.id});

  String id;

  @JsonSerializable(nullable: false)
  final DateTime inspectionDate;

  @JsonKey(nullable: false)
  String userid;

  static Inspection fromDocument(DocumentSnapshot document) =>
      new Inspection.fromJson(document.data);

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}
