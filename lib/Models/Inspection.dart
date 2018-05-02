import 'package:json_annotation/json_annotation.dart';
part 'Inspection.g.dart';

@JsonSerializable()
class Inspection extends Object with _$InspectionSerializerMixin {
  Inspection(this.inspectionDate, this.userid);

  final String id = null;

  @JsonSerializable(nullable: false)
  final DateTime inspectionDate;

  @JsonKey(nullable: false)
  final String userid;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}
