import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/homepage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  bool _checkLogin() {
    bool result;
    FirebaseAuth.instance
        .currentUser()
        .then((user) => user != null ? result = true : result = false);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.lightBlueAccent,
        ),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new LoginPage(),
          '/home': (BuildContext context) => new HomePage(),
        },
        home: (_checkLogin() == true
            ? new HomePage()
            : new Scaffold(body: new LoginPage())));
  }
}
