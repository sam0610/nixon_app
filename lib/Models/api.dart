import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

var url =
    "http://sammobile.azurewebsites.net/api/Users/f5439479-5145-4b97-85ee-f72d19b0ae99";

class User {
  String id;
  String createdAt;
  String updatedAt;
  String version;
  bool deleted;
  String email;
  String passWord;

  User(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.version,
      this.deleted,
      this.email,
      this.passWord});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['version'],
      deleted: json['deleted'],
      email: json['email'],
      passWord: json['passWord'],
    );
  }
  static Future<List<User>> fetchUserList() async {
    final response = await http.get(url);
    final data = json.decode(response.body);
    List<User> list = new List<User>();
    for (var i in data) {
      list.add(new User.fromJson(i.cast<String, dynamic>()));
    }
    return list;
  }

  static Future<User> fetchUser() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
    return new User.fromJson(responseJson);
  }
}
