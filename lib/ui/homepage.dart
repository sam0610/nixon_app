import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  FirebaseUser currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
            checkName(user);
            currentUser = user;
          })
        : setState(() {
            isLoggedIn = false;
            user = null;
            if (isLoggedIn == false) Navigator.pushNamed(context, "/login");
          }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("welcome"),
        centerTitle: true,
      ),
      drawer: new Drawer(
          child: new ListView(padding: EdgeInsets.zero, children: <Widget>[
        myDrawerHeader(),
        new ListTile(title: new Text('Page 1')),
        new ListTile(title: new Text('Page 2')),
      ])),
      body: new Center(child: new Text(isLoggedIn.toString())),
    );
  }

  Widget myDrawerHeader() {
    return new DrawerHeader(
        decoration: new BoxDecoration(color: Theme.of(context).accentColor),
        child: new Container(
          child: new Row(children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(currentUser.displayName,
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                new Text(currentUser.email,
                    style: new TextStyle(fontSize: 18.0))
              ],
            )
          ]),
        ));
  }

  void checkName(FirebaseUser user) async {
    if (user.displayName == null) await updateProfileName("Not Set");
  }

  updateProfileName(String name) {
    UserUpdateInfo updateInfo = new UserUpdateInfo();
    updateInfo.displayName = name;
    FirebaseAuth.instance.updateProfile(updateInfo);
  }

  changeName() {
    updateProfileName("samchoi");
    print("changed");
  }

  void changeDetail() {}
}
