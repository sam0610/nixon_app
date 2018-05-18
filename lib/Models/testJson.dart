import 'package:json_annotation/json_annotation.dart';

part 'testJson.g.dart';

//run code => flutter packages pub run build_runner build
@JsonSerializable()
class Master extends Object with _$MasterSerializerMixin {
  String id;
  DateTime date;
  String name;
  String gender;
  Address address;

  Master(this.id, this.date, this.name, this.gender, this.address);
  // @JsonKey(ignore: true)
  // static Inspection fromDocument(DocumentSnapshot document) =>
  //     new Inspection.fromJson(document.data);

  factory Master.fromJson(Map<String, dynamic> json) => _$MasterFromJson(json);
}

@JsonSerializable()
class Address extends Object with _$AddressSerializerMixin {
  String street;
  String number;
  String flate;

  Address([this.street, this.number, this.flate]);
  // @JsonKey(ignore: true)
  // static Inspection fromDocument(DocumentSnapshot document) =>
  //     new Inspection.fromJson(document.data);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
