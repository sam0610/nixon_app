import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Inspection.g.dart';

//run code => flutter packages pub run build_runner build

const int _default = 100;

@JsonSerializable()
class Inspection extends Object with _$InspectionSerializerMixin {
  String id;
  String status;
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
  List<UFiles> files;
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
      this.status,
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
      this.files,
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

  Inspection.withDefault({
    this.id,
    this.status,
    this.inspectionDate,
    this.arrivedTime,
    this.leaveTime,
    this.bldgCode,
    this.bldgName,
    this.nixonNumber,
    this.staffName,
    this.postName,
    this.foundLocation,
    this.guestsProportion = "1",
    this.situationRemark,
    this.userid,
  })  : files = <UFiles>[],
        //audios = <String>[],
        grooming = new Grooming(),
        behavior = new Behavior(),
        serveCust = new ServeCust(),
        listenCust = new ListenCust(),
        handleCust = new HandleCust(),
        closure = new Closure(),
        communicationSkill = new CommunicationSkill(),
        warmHeart = new WarmHeart(),
        cleanlinessMall = new CleanlinessMall(),
        cleanlinessToilet = new CleanlinessToilet();

  static Inspection fromDocument(DocumentSnapshot document) =>
      new Inspection.fromJson(document.data);

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);

  bool checkForSave() {
    if (_pass(inspectionDate) &&
        _pass(arrivedTime) &&
        _pass(leaveTime) &&
        _pass(bldgName) &&
        _pass(staffName) &&
        //_pass(foundLocation) &&
        _pass(postName) &&
        _pass(guestsProportion) &&
        //_pass(situationRemark) &&
        _pass(userid)) return true;
    return false;
  }

  bool checkForComplete() {
    if (_pass(inspectionDate) &&
        _pass(arrivedTime) &&
        _pass(leaveTime) &&
        _pass(bldgName) &&
        _pass(staffName) &&
        _pass(foundLocation) &&
        _pass(postName) &&
        _pass(guestsProportion) &&
        _pass(situationRemark) &&
        _pass(files) &&
        _pass(userid)) return true;
    return false;
  }

  bool _pass(dynamic field) {
    bool result = true;
    if (field == null) return false;
    if (field is String && field.isEmpty) return false;
    if (field is List && field.length < 1) return false;
    if (result == false) return false;
    return result;
  }

  static translate(String key) {
    Map<String, String> chineseLabel = <String, String>{
      'inspectionDate': '巡查日期',
      'status': '表格狀態',
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

    var result = 'not found';
    chineseLabel.forEach((k, v) {
      if (k == key) {
        result = v;
        return;
      }
    });
    return result;
  }
}

class UFiles extends Object with _$UFilesSerializerMixin {
  String name;
  String downloalUrl;

  UFiles({this.name, this.downloalUrl});

  factory UFiles.fromJson(Map<String, dynamic> json) => new UFiles(
      name: json['name'] as String, downloalUrl: json['downloalUrl'] as String);
}

abstract class _$UFilesSerializerMixin {
  String get name;
  String get downloalUrl;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'downloalUrl': downloalUrl};
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
      {this.groomingScore = _default,
      this.hairScore = _default,
      this.uniformScore = _default,
      this.decorationScore = _default,
      this.maskCleanScore = _default,
      this.maskWearScore = _default});

  factory Grooming.fromJson(Map<String, dynamic> json) =>
      _$GroomingFromJson(json);
}

class Behavior extends Object with _$BehaviorSerializerMixin {
  int behaviorScore;
  int mindScore;
  Behavior({this.behaviorScore = _default, this.mindScore = _default});
  factory Behavior.fromJson(Map<String, dynamic> json) =>
      _$BehaviorFromJson(json);
}

@JsonSerializable()
class ServeCust extends Object with _$ServeCustSerializerMixin {
  int smileScore;
  int greetingScore;
  ServeCust({this.smileScore = _default, this.greetingScore = _default});
  factory ServeCust.fromJson(Map<String, dynamic> json) =>
      _$ServeCustFromJson(json);
}

@JsonSerializable()
class ListenCust extends Object with _$ListenCustSerializerMixin {
  int listenCustScore;
  ListenCust({this.listenCustScore = _default});

  factory ListenCust.fromJson(Map<String, dynamic> json) =>
      _$ListenCustFromJson(json);
}

@JsonSerializable()
class HandleCust extends Object with _$HandleCustSerializerMixin {
  int indicateWithPalmScore;
  int respondCustNeedScore;
  int unexpectedSituationScore;
  HandleCust(
      {this.indicateWithPalmScore = _default,
      this.respondCustNeedScore = _default,
      this.unexpectedSituationScore = _default});
  factory HandleCust.fromJson(Map<String, dynamic> json) =>
      _$HandleCustFromJson(json);
}

@JsonSerializable()
class Closure extends Object with _$ClosureSerializerMixin {
  int farewellScore;

  Closure({this.farewellScore = _default});

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
      {this.soundLevel = _default,
      this.soundSpeed = _default,
      this.polite = _default,
      this.attitudeScore = _default,
      this.skillScore = _default});
  factory CommunicationSkill.fromJson(Map<String, dynamic> json) =>
      _$CommunicationSkillFromJson(json);
}

@JsonSerializable()
class WarmHeart extends Object with _$WarmHeartSerializerMixin {
  int warmHeartScore;

  WarmHeart({this.warmHeartScore = _default});

  factory WarmHeart.fromJson(Map<String, dynamic> json) =>
      _$WarmHeartFromJson(json);
}

@JsonSerializable()
class CleanlinessMall extends Object with _$CleanlinessMallSerializerMixin {
  int mall_1;
  int mall_2;

  int mall_3;

  CleanlinessMall(
      {this.mall_1 = _default, this.mall_2 = _default, this.mall_3 = _default});

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
      {this.toilet_1 = _default,
      this.toilet_2 = _default,
      this.toilet_3 = _default,
      this.toilet_4 = _default,
      this.toilet_5 = _default,
      this.toilet_6 = _default});

  factory CleanlinessToilet.fromJson(Map<String, dynamic> json) =>
      _$CleanlinessToiletFromJson(json);
}
