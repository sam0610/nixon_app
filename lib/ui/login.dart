import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _passwordEditController = new TextEditingController();

  void showMessage(String value, [Color color]) {
    color == null ? color = Colors.red[50] : null;
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<Null> _showDialog(String title, String message) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Column(
          children: <Widget>[
            _BuildLogo(),
            emailTextField(),
            pwTextField(),
            pwConfirmBtn()
          ],
        )
      ],
    ));
  }

  Widget emailTextField() {
    return new Container(
        padding: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      hintText: "email address",
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
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "login password",
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

  login() async {
    if (_emailEditController.text.isNotEmpty &&
        _passwordEditController.text.isNotEmpty) {
      _emailEditController.text =
          _emailEditController.text.toLowerCase().trim();
      _passwordEditController.text = _passwordEditController.text.trim();

      print("LOGIN REQUESTED");
      _handleSignIn().then((FirebaseUser user) {
        Navigator.of(context).pushReplacementNamed('/home');
      }).catchError((onError) {
        _showDialog("Error", onError.message.toString());
      });
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: _emailEditController.text.toLowerCase().trim(),
        password: _passwordEditController.text.trim());
    return user;
  }
}

class _BuildLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Image.asset(
        'asset/nx_logo.png',
        scale: 10.0,
        color: Colors.redAccent,
      ),
    );
  }
}
