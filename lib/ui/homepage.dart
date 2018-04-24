import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_services.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoggedIn = false;
  String userID ;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
      isLoggedIn = true;
      userID = user.uid;
    })
        : null);
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("welcome"),
        centerTitle: true,
      ),
      body: new Center(child: new Text(isLoggedIn.toString() +' '+ userID)),
    );
  }
}
