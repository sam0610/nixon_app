import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/homepage.dart';
import './ui/splashscreen.dart';

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
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => new SplashScreen(),
        '/login': (BuildContext context) => new LoginPage(),
        '/home': (BuildContext context) => new HomePage(),
      },
      home: new SplashScreen(),
    );
  }
}
