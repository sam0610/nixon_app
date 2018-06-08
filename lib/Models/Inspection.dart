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
  String bldgCode;
  String bldgName;
  int nixonNumber;
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
      this.bldgCode,
      this.bldgName,
      this.nixonNumber,
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

  static translate(String key) {
    Map<String, String> chineseLabel = <String, String>{
      'inspectionDate': '巡查日期',
      'arrivedTime': '到達時間',
      'leaveTime': '離開時間',
      'bldgCode': '大廈編號',
      'bldgName': '大廈名稱',
      'nixonNumber': '力新編號',
      'staffName': '員工姓名',
      'postName': '崗位',
      'foundLocation': '位置',
      'guestsProportion': '顧客比例',
      'situationRemark': '情境',
      'userid': '使用者ID',
      'grooming': '儀容',
      'groomingScore': '儀容',
      'hairScore': '髮型',
      'uniformScore': '制服',
      'decorationScore': '飾物',
      'maskCleanScore': '口罩清潔',
      'maskWearScore': '口罩配帶',
      'behavior': '舉止',
      'behaviorScore': '行為舉止',
      'mindScore': '精神狀態',
      'serveCust': '接待顧客',
      'smileScore': '笑容',
      'greetingScore': '招呼',
      'listenCust': '聆聽客戶',
      'listenCustScore': '聆聽',
      'handleCust': '處理顧客需要',
      'indicateWithPalmScore': '以手掌指示方向',
      'respondCustNeedScore': '應對客人需要',
      'unexpectedSituationScore': '突發事件處理',
      'closure': '結束對話',
      'farewellScore': '道別',
      'communicationSkill': '溝通技巧',
      'soundLevel': '話話聲量',
      'soundSpeed': '說話速度',
      'polite': '用詞及神貌',
      'attitudeScore': '說話態度',
      'skillScore': '技巧',
      'warmHeart': '窩心',
      'warmHeartScore': '窩心',

      'cleanlinessMall': '清潔-商場',
      'mall_1': '地面清潔', //'地面大致乾爽，地面清潔無明顯垃圾，如有垃圾，能在5分鐘內清理',
      'mall_2': '適當的警告牌', //'擺放適當的警告牌',
      'mall_3': '垃圾桶沒有滿瀉',

      'cleanlinessToilet': '清潔-洗手間',
      'toilet_1': '地面清潔', //'地面清潔無明顯垃圾，地面大致乾爽',
      'toilet_2': '設備操作正常/有貼上待修標示', //設備操作正常/有貼上待修標示(如自來水，沖廁水，洗手棭機等)',
      'toilet_3': '消耗品供應充足', //消耗品供應充足( 如擦手紙，廁紙，洗手液及廁格液等)',
      'toilet_4': '檯面整潔', //檯面整潔( 如沒有垃圾或殘留的洗手液)',
      'toilet_5': '垃圾桶沒有滿瀉', //'垃圾沒有滿瀉',
      'toilet_6': '正確使用清潔工具',
    };

    var result='not found';
    chineseLabel.forEach((k, v) {
      if (k == key) {
        result = v;
        return;
      }
    });
    return result;
  }
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
