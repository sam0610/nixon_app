import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _passwordEditController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: new ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50.0)),
            buildLogo(),
            new Column(
              children: <Widget>[
                emailTextField(),
                pwTextField(),
                pwConfirmBtn()
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
                splashColor: Colors.white,
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
    }
  }
}