import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/Route.dart';
import '../Helper/firebase.dart';
import 'page1.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

UserData currentUser;
FireBaseHelper fireHelper = new FireBaseHelper();

class _HomePageState extends State<HomePage> {
  TextEditingController displayNameController = new TextEditingController();
  bool isLoggedIn = false;
  bool boolEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assureLogin();
  }

  _assureLogin() async {
    await FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
            currentUser = UserData(user);
          })
        : setState(() {
            isLoggedIn = false;
            user = null;
            if (isLoggedIn == false)
              Navigator.pushReplacementNamed(context, "/login");
          }));
  }

  void _allowEdit() {
    setState(() {
      boolEdit = !boolEdit;
      if (boolEdit) this.displayNameController.text = currentUser.displayName;
    });
  }

  void changeName(String value) async {
    await fireHelper.updateProfileName(value);
    setState(() {
      _assureLogin();
    });
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _navigate(String page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new Page1(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("welcome"),
        centerTitle: true,
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              decoration:
                  new BoxDecoration(color: Theme.of(context).primaryColor),
              child: new Container(
                padding: EdgeInsets.all(20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        boolEdit == false
                            ? new Text(
                                currentUser.displayName ?? 'N/A',
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            : new Flexible(
                                child: new TextField(
                                  controller: displayNameController,
                                  onSubmitted: changeName,
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.black),
                                ),
                              ),
                        new Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: new GestureDetector(
                            child: new Icon(
                              Icons.edit,
                              size: 15.0,
                              color: Colors.grey[800],
                            ),
                            onTap: _allowEdit,
                          ),
                        ),
                      ],
                    ),
                    new Text(
                      currentUser.email,
                      style: new TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            new ListTile(
              title: new Text('Go To Page 1'),
              onTap: () => _navigate('/p1'),
            ),
            new Divider(),
            new ListTile(
              title: new Text(
                'Logout',
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              trailing: new Icon(Icons.exit_to_app),
              onTap: _signOut,
            )
          ],
        ),
      ),
      body: new Center(
        child: new Text(
          isLoggedIn.toString(),
        ),
      ),
    );
  }
}
