import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  void handleTimeout() {
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() => Navigator.pushReplacementNamed(context, "/home"))
        : setState(() => Navigator.pushReplacementNamed(context, "/login")));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  CurvedAnimation _iconAnimation;
  AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    _iconAnimation =
        new CurvedAnimation(parent: _iconController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
      child: new Image.asset(
        'asset/nx_logo.png',
        width: _iconAnimation.value * 100,
        height: _iconAnimation.value * 100,
        scale: 10.0,
        color: Colors.redAccent,
      ),
    ));
  }
}
