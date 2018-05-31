import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../nixon_app.dart';

//http://sammobile.azurewebsites.net/api/Staff/bldg/212702/2018-05-28
//http://sammobile.azurewebsites.net/api/BuildingData/r/NK1H

Future<User> fetchUser(http.Client client) async {
  var url =
      "http://sammobile.azurewebsites.net/api/Users/f5439479-5145-4b97-85ee-f72d19b0ae99";

  final response = await client.get(url);
  print(response.body.toString());
  User user = new User.fromJson(json.decode(response.body));
  return user;
}

Future<List<User>> fetchUsers(http.Client client) async {
  var urlList = "http://sammobile.azurewebsites.net/api/Users/";
  final response = await client.get(urlList);
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

class UserBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<User>>(
      future: fetchUsers(new http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text(snapshot.error);
        }
        return snapshot.hasData
            ? new UserList(user: snapshot.data)
            : new Center(child: new AnimatedCircularProgress());
      },
    );
  }
}

class UserList extends StatelessWidget {
  final List<User> user;

  UserList({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          TextStyle style = new TextStyle(fontSize: 20.0, color: Colors.red);
          return new ListTile(
              title: new Text(user[index].email, style: style),
              subtitle: new Text(
                user[index].passWord,
                style: style,
              ));
        });
  }
}
