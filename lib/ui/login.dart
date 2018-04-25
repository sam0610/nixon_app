import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _passwordEditController = new TextEditingController();
  //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            Navigator.of(context).pushNamed('/home');
          })
        : null);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 50.0)),
        new Column(
          children: <Widget>[
            buildLogo(),
            emailTextField(),
            pwTextField(),
            pwConfirmBtn()
          ],
        )
      ],
    );
  }

  Widget buildLogo() {
    return new Center(
      child: new Image.asset(
        'asset/nx_logo.png',
        scale: 10.0,
        color: Colors.redAccent,
      ),
    );
  }

  Widget emailTextField() {
    return new Container(
        padding: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new TextField(
                  decoration: new InputDecoration(
                      hintText: "please enter email",
                      suffixIcon: new Icon(Icons.email)),
                  controller: _emailEditController,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ));
  }

  Widget pwTextField() {
    return new Container(
        padding: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new TextField(
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "please enter password",
                      suffixIcon: new Icon(Icons.lock)),
                  controller: _passwordEditController,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ));
  }

  Widget pwConfirmBtn() {
    return new Center(
      child: new Container(
        margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: new RaisedButton(
                onPressed: login,
                color: Colors.blue,
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: new Icon(Icons.send)),
                      new Text("Login")
                    ],
                  ),
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new RaisedButton(
              onPressed: () {
                setState(() {
                  _emailEditController.clear();
                  _passwordEditController.clear();
                });
              },
              color: Colors.redAccent,
              child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: new Icon(Icons.clear),
                    ),
                    new Text("Cancel")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() {
    if (_emailEditController.text.isNotEmpty &&
        _passwordEditController.text.isNotEmpty) {
      _emailEditController.text =
          _emailEditController.text.toLowerCase().trim();
      _passwordEditController.text = _passwordEditController.text.trim();
      print("LOGIN REQUESTED");
      _handleSignIn()
          .then((FirebaseUser user) => print(user))
          .catchError((e) => print(e));
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: _emailEditController.text.toLowerCase().trim(),
          password: _passwordEditController.text.trim());
      if (user != null) {
        showSnackbar('signed in ' + user.uid.toString(), Colors.green);
        Navigator.of(context).pushNamed('/home');
        return user;
      } else {
        showSnackbar('Login Fails');
      }
    } catch (ex) {
      showSnackbar(ex.toString());
    }
    return null;
  }

  void showSnackbar(String s, [Color bgColor]) {
    Scaffold.of(context).showSnackBar(new SnackBar(
          backgroundColor: bgColor == null ? Colors.red : bgColor,
          content: new Text(s),
          duration: Duration(seconds: 3),
        ));
  }
}
