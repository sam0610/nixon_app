// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testJson.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Master _$MasterFromJson(Map<String, dynamic> json) => new Master(
    json['id'] as String,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['name'] as String,
    json['gender'] as String,
    json['address'] == null
        ? new Address()
        : new Address.fromJson(json['address'].cast<String, dynamic>()));

abstract class _$MasterSerializerMixin {
  String get id;
  DateTime get date;
  String get name;
  String get gender;
  Address get address;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'date': date?.toIso8601String(),
        'name': name,
        'gender': gender,
        'address': address.toJson()
      };
}

Address _$AddressFromJson(Map<String, dynamic> json) => new Address(
    json['street'] as String,
    json['number'] as String,
    json['flate'] as String);

abstract class _$AddressSerializerMixin {
  String get street;
  String get number;
  String get flate;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'street': street, 'number': number, 'flate': flate};
}
