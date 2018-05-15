import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../Helper/AnimatedPageRoute.dart';
import '../Helper/firebase.dart';
import '../Models/api.dart';
import 'inspectionList.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

UserData currentUser;
FireBaseHelper fireHelper = new FireBaseHelper();

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
      boolEdit = true;
      if (boolEdit) this.displayNameController.text = currentUser.displayName;
    });
  }

  void _changeName() async {
    setState(() {
      _loading = true;
    });
    await fireHelper.updateProfileName(displayNameController.text);
    setState(() {
      _loading = false;
      _assureLogin();
      boolEdit = false;
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
            builder: (_) => new InspectionRecord(),
          ),
        );
  }

  bool _loading = false;
  Widget _saveIcon() => _loading == true
      ? new Container(
          height: 20.0,
          width: 20.0,
          child: new CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: new Tween<Color>(begin: Colors.red, end: Colors.white)
                  .animate(new AnimationController(
                      duration: Duration(milliseconds: 500), vsync: this))))
      : new Icon(
          Icons.save,
          size: 20.0,
          color: Colors.grey[800],
        );

  Widget userNameField() => boolEdit == false
      ? Row(
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: new Text(
                  currentUser?.displayName ?? 'N/A',
                  style: new TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                )),
            new FlatButton(
              child: new Icon(
                Icons.edit,
                size: 20.0,
                color: Colors.grey[800],
              ),
              onPressed: _allowEdit,
            ),
          ],
        )
      : new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new TextField(
                controller: displayNameController,
                style: new TextStyle(fontSize: 24.0, color: Colors.black),
              ),
            ),
            new FlatButton(
              child: _saveIcon(),
              onPressed: _changeName,
            ),
          ],
        );

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
                  padding: EdgeInsets.all(5.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      userNameField(),
                      new Text(
                        currentUser?.email ?? "N/A",
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
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                trailing: new Icon(Icons.exit_to_app),
                onTap: _signOut,
              )
            ],
          ),
        ),
        body: body1);
  }

  var body1 = new FutureBuilder<List<User>>(
    future: fetchUsers(new http.Client()),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return new Text(snapshot.error);
      }
      return snapshot.hasData
          ? new UserList(user: snapshot.data)
          : new Center(child: new CircularProgressIndicator());
    },
  );
}

class UserList extends StatelessWidget {
  final List<User> user;

  UserList({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(child: new Text(user[index].email));
        });
  }
}
