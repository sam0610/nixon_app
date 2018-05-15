import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<User> fetchUser(http.Client client) async {
  var url =
      "http://sammobile.azurewebsites.net/api/Users/f5439479-5145-4b97-85ee-f72d19b0ae99";

  final response = await client.get(url);
  print(response.body.toString());
  User user = new User.fromJson(json.decode(response.body));
  return user;
}

Future<List<User>> fetchUsers(http.Client client) async {
  var url_List = "http://sammobile.azurewebsites.net/api/Users/";
  final response = await client.get(url_List);
  print(response.body.toString());
  return compute(parseUsers, response.body);
}

List<User> parseUsers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<User>((json) => new User.fromJson(json)).toList();
}

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
}
