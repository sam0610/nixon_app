// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Inspection.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Inspection _$InspectionFromJson(Map<String, dynamic> json) => new Inspection(
      inspectionDate: json['inspectionDate'] == null
          ? null
          : DateTime.parse(json['inspectionDate'] as String),
      bldgCode: json['bldgCode'] == null ? null : json['bldgCode'] as String,
      bldgName: json['bldgName'] == null ? null : json['bldgName'] as String,
      nixonNumber:
          json['nixonNumber'] == null ? null : json['nixonNumber'] as int,
      staffName: json['staffName'] as String,
      arrivedTime: json['arrivedTime'] as String,
      leaveTime: json['leaveTime'] as String,
      foundLocation: json['foundLocation'] == null
          ? null
          : json['foundLocation'] as String,
      postName: json['postName'] == null ? null : json['postName'] as String,
      guestsProportion: json['guestsProportion'] == null
          ? null
          : json['guestsProportion'] as String,
      situationRemark: json['situationRemark'] == null
          ? null
          : json['situationRemark'] as String,
      userid: json['userid'] as String,
      id: json['id'] as String,
      grooming: json['grooming'] == null
          ? null
          : new Grooming.fromJson(json['grooming'].cast<String, dynamic>()),
      behavior: json['behavior'] == null
          ? null
          : new Behavior.fromJson(json['behavior'].cast<String, dynamic>()),
      serveCust: json['serveCust'] == null
          ? null
          : new ServeCust.fromJson(json['serveCust'].cast<String, dynamic>()),
      listenCust: json['listenCust'] == null
          ? null
          : new ListenCust.fromJson(json['listenCust'].cast<String, dynamic>()),
      handleCust: json['handleCust'] == null
          ? null
          : new HandleCust.fromJson(json['handleCust'].cast<String, dynamic>()),
      closure: json['closure'] == null
          ? null
          : new Closure.fromJson(json['closure'].cast<String, dynamic>()),
      communicationSkill: json['communicationSkill'] == null
          ? null
          : new CommunicationSkill.fromJson(
              json['communicationSkill'].cast<String, dynamic>()),
      warmHeart: json['warmHeart'] == null
          ? null
          : new WarmHeart.fromJson(json['warmHeart'].cast<String, dynamic>()),
      cleanlinessMall: json['cleanlinessMall'] == null
          ? null
          : new CleanlinessMall.fromJson(
              json['cleanlinessMall'].cast<String, dynamic>()),
      cleanlinessToilet: json['cleanlinessToilet'] == null
          ? null
          : new CleanlinessToilet.fromJson(
              json['cleanlinessToilet'].cast<String, dynamic>()),
    );

abstract class _$InspectionSerializerMixin {
  String get id;
  DateTime get inspectionDate;
  String get bldgCode;
  String get bldgName;
  int get nixonNumber;
  String get arrivedTime;
  String get leaveTime;
  String get staffName;
  String get postName;
  String get foundLocation;
  String get guestsProportion;
  String get situationRemark;
  String get userid;
  Grooming get grooming;
  Behavior get behavior;
  ServeCust get serveCust;
  ListenCust get listenCust;
  HandleCust get handleCust;
  Closure get closure;
  CommunicationSkill get communicationSkill;
  WarmHeart get warmHeart;
  CleanlinessMall get cleanlinessMall;
  CleanlinessToilet get cleanlinessToilet;

  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{
      'id': id,
      'inspectionDate': inspectionDate?.toIso8601String(),
      'bldgCode': bldgCode,
      'bldgName': bldgName,
      'nixonNumber': nixonNumber,
      'arrivedTime': arrivedTime,
      'leaveTime': leaveTime,
      'staffName': staffName,
      'postName': postName,
      'foundLocation': foundLocation,
      'guestsProportion': guestsProportion,
      'situationRemark': situationRemark,
      'userid': userid,
    };
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('grooming', grooming?.toJson());
    writeNotNull('behavior', behavior?.toJson());
    writeNotNull('serveCust', serveCust?.toJson());
    writeNotNull('listenCust', listenCust?.toJson());
    writeNotNull('handleCust', handleCust?.toJson());
    writeNotNull('closure', closure?.toJson());
    writeNotNull('communicationSkill', communicationSkill?.toJson());
    writeNotNull('warmHeart', warmHeart?.toJson());
    writeNotNull('cleanlinessMall', cleanlinessMall?.toJson());
    writeNotNull('cleanlinessToilet', cleanlinessToilet?.toJson());

    return val;
  }
}

Grooming _$GroomingFromJson(Map<String, dynamic> json) => new Grooming(
    groomingScore: json['groomingScore'] as int,
    hairScore: json['hairScore'] as int,
    uniformScore: json['uniformScore'] as int,
    decorationScore: json['decorationScore'] as int,
    maskCleanScore: json['maskCleanScore'] as int,
    maskWearScore: json['maskWearScore'] as int);

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

abstract class _$BehaviorSerializerMixin {
  int get behaviorScore;
  int get mindScore;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'behaviorScore': behaviorScore, 'mindScore': mindScore};
}

ServeCust _$ServeCustFromJson(Map<String, dynamic> json) => new ServeCust(
    smileScore: json['smileScore'] as int,
    greetingScore: json['greetingScore'] as int);

abstract class _$ServeCustSerializerMixin {
  int get smileScore;
  int get greetingScore;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'smileScore': smileScore,
        'greetingScore': greetingScore
      };
}

ListenCust _$ListenCustFromJson(Map<String, dynamic> json) =>
    new ListenCust(listenCustScore: json['listenCustScore'] as int);

abstract class _$ListenCustSerializerMixin {
  int get listenCustScore;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'listenCustScore': listenCustScore};
}

HandleCust _$HandleCustFromJson(Map<String, dynamic> json) => new HandleCust(
    indicateWithPalmScore: json['indicateWithPalmScore'] as int,
    respondCustNeedScore: json['respondCustNeedScore'] as int,
    unexpectedSituationScore: json['unexpectedSituationScore'] as int);

abstract class _$HandleCustSerializerMixin {
  int get indicateWithPalmScore;
  int get respondCustNeedScore;
  int get unexpectedSituationScore;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'indicateWithPalmScore': indicateWithPalmScore,
        'respondCustNeedScore': respondCustNeedScore,
        'unexpectedSituationScore': unexpectedSituationScore
      };
}

Closure _$ClosureFromJson(Map<String, dynamic> json) =>
    new Closure(farewellScore: json['farewellScore'] as int);

abstract class _$ClosureSerializerMixin {
  int get farewellScore;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'farewellScore': farewellScore};
}

Behavior _$BehaviorFromJson(Map<String, dynamic> json) => new Behavior(
    behaviorScore: json['behaviorScore'] as int,
    mindScore: json['mindScore'] as int);

CommunicationSkill _$CommunicationSkillFromJson(Map<String, dynamic> json) =>
    new CommunicationSkill(
        soundLevel: json['soundLevel'] as int,
        soundSpeed: json['soundSpeed'] as int,
        polite: json['polite'] as int,
        attitudeScore: json['attitudeScore'] as int,
        skillScore: json['skillScore'] as int);

abstract class _$CommunicationSkillSerializerMixin {
  int get soundLevel;
  int get soundSpeed;
  int get polite;
  int get attitudeScore;
  int get skillScore;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'soundLevel': soundLevel,
        'soundSpeed': soundSpeed,
        'polite': polite,
        'attitudeScore': attitudeScore,
        'skillScore': skillScore
      };
}

WarmHeart _$WarmHeartFromJson(Map<String, dynamic> json) =>
    new WarmHeart(warmHeartScore: json['warmHeartScore'] as int);

abstract class _$WarmHeartSerializerMixin {
  int get warmHeartScore;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'warmHeartScore': warmHeartScore};
}

CleanlinessMall _$CleanlinessMallFromJson(Map<String, dynamic> json) =>
    new CleanlinessMall(
        mall_1: json['mall_1'] as int,
        mall_2: json['mall_2'] as int,
        mall_3: json['mall_3'] as int);

abstract class _$CleanlinessMallSerializerMixin {
  int get mall_1;
  int get mall_2;
  int get mall_3;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'mall_1': mall_1, 'mall_2': mall_2, 'mall_3': mall_3};
}

CleanlinessToilet _$CleanlinessToiletFromJson(Map<String, dynamic> json) =>
    new CleanlinessToilet(
        toilet_1: json['toilet_1'] as int,
        toilet_2: json['toilet_2'] as int,
        toilet_3: json['toilet_3'] as int,
        toilet_4: json['toilet_4'] as int,
        toilet_5: json['toilet_5'] as int,
        toilet_6: json['toilet_6'] as int);

abstract class _$CleanlinessToiletSerializerMixin {
  int get toilet_1;
  int get toilet_2;
  int get toilet_3;
  int get toilet_4;
  int get toilet_5;
  int get toilet_6;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'toilet_1': toilet_1,
        'toilet_2': toilet_2,
        'toilet_3': toilet_3,
        'toilet_4': toilet_4,
        'toilet_5': toilet_5,
        'toilet_6': toilet_6
      };
}
