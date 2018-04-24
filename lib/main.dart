import 'package:flutter/material.dart';
import './ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlueAccent,
      ),
      home: new LoginPage(title: 'Welcome'),
    );
  }
}
