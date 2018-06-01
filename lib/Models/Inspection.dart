import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Inspection.g.dart';

//run code => flutter packages pub run build_runner build
@JsonSerializable()
class Inspection extends Object with _$InspectionSerializerMixin {
  String id;
  DateTime inspectionDate;
  String arrivedTime;
  String leaveTime;
  String staffName;
  String postName;
  String foundLocation;
  String guestsProportion;
  String situationRemark;
  String userid;
  Grooming grooming;
  Behavior behavior;
  ServeCust serveCust;
  ListenCust listenCust;
  HandleCust handleCust;
  Closure closure;
  CommunicationSkill communicationSkill;
  WarmHeart warmHeart;
  CleanlinessMall cleanlinessMall;
  CleanlinessToilet cleanlinessToilet;

  Inspection(
      {this.id,
      this.inspectionDate,
      this.arrivedTime,
      this.leaveTime,
      this.staffName,
      this.postName,
      this.foundLocation,
      this.guestsProportion,
      this.situationRemark,
      this.userid,
      this.grooming,
      this.behavior,
      this.serveCust,
      this.listenCust,
      this.handleCust,
      this.closure,
      this.communicationSkill,
      this.warmHeart,
      this.cleanlinessMall,
      this.cleanlinessToilet});

  static Inspection fromDocument(DocumentSnapshot document) =>
      new Inspection.fromJson(document.data);

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

@JsonSerializable()
class Grooming extends Object with _$GroomingSerializerMixin {
  int groomingScore;
  int hairScore;
  int uniformScore;
  int decorationScore;
  int maskWearScore;
  int maskCleanScore;

  Grooming(
      {this.groomingScore = 0,
      this.hairScore = 0,
      this.uniformScore = 0,
      this.decorationScore = 0,
      this.maskCleanScore = 0,
      this.maskWearScore = 0});

  factory Grooming.fromJson(Map<String, dynamic> json) =>
      _$GroomingFromJson(json);
}

class Behavior extends Object with _$BehaviorSerializerMixin {
  int behaviorScore;
  int mindScore;
  Behavior({this.behaviorScore, this.mindScore});
  factory Behavior.fromJson(Map<String, dynamic> json) =>
      _$BehaviorFromJson(json);
}

@JsonSerializable()
class ServeCust extends Object with _$ServeCustSerializerMixin {
  int smileScore;
  int greetingScore;
  ServeCust({this.smileScore, this.greetingScore});
  factory ServeCust.fromJson(Map<String, dynamic> json) =>
      _$ServeCustFromJson(json);
}

@JsonSerializable()
class ListenCust extends Object with _$ListenCustSerializerMixin {
  int listenCustScore;
  ListenCust({this.listenCustScore});

  factory ListenCust.fromJson(Map<String, dynamic> json) =>
      _$ListenCustFromJson(json);
}

@JsonSerializable()
class HandleCust extends Object with _$HandleCustSerializerMixin {
  int indicateWithPalmScore;
  int respondCustNeedScore;
  int unexpectedSituationScore;
  HandleCust(
      {this.indicateWithPalmScore,
      this.respondCustNeedScore,
      this.unexpectedSituationScore});
  factory HandleCust.fromJson(Map<String, dynamic> json) =>
      _$HandleCustFromJson(json);
}

@JsonSerializable()
class Closure extends Object with _$ClosureSerializerMixin {
  int farewellScore;

  Closure({this.farewellScore});

  factory Closure.fromJson(Map<String, dynamic> json) =>
      _$ClosureFromJson(json);
}

@JsonSerializable()
class CommunicationSkill extends Object
    with _$CommunicationSkillSerializerMixin {
  int soundLevel;
  int soundSpeed;
  int polite;
  int attitudeScore;

  int skillScore;

  CommunicationSkill(
      {this.soundLevel,
      this.soundSpeed,
      this.polite,
      this.attitudeScore,
      this.skillScore});
  factory CommunicationSkill.fromJson(Map<String, dynamic> json) =>
      _$CommunicationSkillFromJson(json);
}

@JsonSerializable()
class WarmHeart extends Object with _$WarmHeartSerializerMixin {
  int warmHeartScore;

  WarmHeart({this.warmHeartScore});

  factory WarmHeart.fromJson(Map<String, dynamic> json) =>
      _$WarmHeartFromJson(json);
}

@JsonSerializable()
class CleanlinessMall extends Object with _$CleanlinessMallSerializerMixin {
  int mall_1;
  int mall_2;

  int mall_3;

  CleanlinessMall({this.mall_1, this.mall_2, this.mall_3});

  factory CleanlinessMall.fromJson(Map<String, dynamic> json) =>
      _$CleanlinessMallFromJson(json);
}

@JsonSerializable()
class CleanlinessToilet extends Object with _$CleanlinessToiletSerializerMixin {
  int toilet_1;
  int toilet_2;
  int toilet_3;
  int toilet_4;
  int toilet_5;
  int toilet_6;

  CleanlinessToilet(
      {this.toilet_1,
      this.toilet_2,
      this.toilet_3,
      this.toilet_4,
      this.toilet_5,
      this.toilet_6});

  factory CleanlinessToilet.fromJson(Map<String, dynamic> json) =>
      _$CleanlinessToiletFromJson(json);
}
