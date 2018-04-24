import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlueAccent,
      ),
      home: new MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _passwordEditController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: <Widget>[
          buildLogo(),
          new Column(
            children: <Widget>[emailTextField(), pwTextField(), pwConfirmBtn()],
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildLogo() {
    return new Center(
      child: new Container(
        margin: const EdgeInsets.all(20.0),
        child: new Image.asset(
          'asset/nx_logo.png',
          scale: 10.0,
          color: Colors.redAccent,
        ),
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
        margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
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
