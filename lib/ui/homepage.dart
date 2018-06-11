part of nixon_app;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool boolEdit = false;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assureLogin();
  }

  _assureLogin() async {
    if (_user == null) Navigator.pushReplacementNamed(context, "/login");
  }

  _addForm() {
    Inspection newform = new Inspection();
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(form: newform),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Mystery Shopper"),
          centerTitle: true,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add_circle),
          onPressed: _addForm,
        ),
        drawer: DrawerWidget(
          context: context,
        ),
        body: InspectionBody());
  }
}

class InspectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: inspectionCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: Alignment.center,
                child: new Center(child: new AnimatedCircularProgress()));
          return FirestoreListView(documents: snapshot.data.documents);
        });
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  void _open(BuildContext context, Inspection inspection) {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(form: inspection),
          ),
        );
  }

  void _delete(DocumentSnapshot snapshot, BuildContext context) {
    InspectionRepos.deleteInspectionbySnapshot(snapshot).then((onValue) {
      FormHelper.showSnackBar(context, "Deleted");
    });
  }

  FirestoreListView({this.documents});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        Inspection inspection = new Inspection.fromJson(documents[index].data);
        String inspDate = FormHelper.datetoString(inspection.inspectionDate);
        TextStyle titleStyle =
            Theme.of(context).textTheme.title.copyWith(fontSize: 20.0);
        TextStyle subheadStyle =
            Theme.of(context).textTheme.subhead.copyWith(fontSize: 16.0);
        return new Row(
          children: <Widget>[
            new Expanded(
              child: new ListTile(
                  title: new Text(
                    inspDate,
                    style: titleStyle,
                  ),
                  subtitle:
                      new Text(inspection.staffName, style: subheadStyle)),
            ),
            new IconButton(
                icon: new Icon(Icons.edit),
                color: Theme.of(context).accentColor,
                onPressed: () => _open(context, inspection)),
            new IconButton(
              icon: new Icon(Icons.delete),
              color: Theme.of(context).accentColor,
              onPressed: () {
                _delete(documents[index], context);
              },
            )
          ],
        );
      },
    );
  }
}

class DrawerWidget extends StatelessWidget {
  DrawerWidget({this.context});
  final BuildContext context;

  void _signOut() {
    _auth.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  /*void _navigate(String page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
          new AnimatedRoute(builder: (_) => null //new InspectionRecord(),
              ),
        );
  }*/

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new Header(),
          //new ListTile(
          //  title: new Text('Go To Page 1'),
          //  onTap: () => _navigate('/p1'),
          //),
          new Divider(),
          new ListTile(
            title: new Text(
              'Logout',
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            trailing: new Icon(Icons.exit_to_app),
            onTap: _signOut,
          )
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => new _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _boolEdit = false;
  bool _loading = false;
  TextEditingController _displayNameController = new TextEditingController();

  void _allowEdit() {
    setState(() {
      _boolEdit = true;
      if (_boolEdit) this._displayNameController.text = _user.displayName;
    });
  }

  void _changeName() async {
    setState(() {
      _loading = true;
    });
    AuthHelper.updateProfileName(_displayNameController.text).then((_) {
      setState(() {
        _loading = false;
        _boolEdit = false;
      });
    });
  }

  Widget _saveIcon() => _loading == true
      ? new Container(
          height: 20.0,
          width: 20.0,
          child: new CircularProgressIndicator(
            strokeWidth: 2.0,
          ))
      : new Icon(
          Icons.save,
          size: 20.0,
          color: Colors.grey[800],
        );

  @override
  Widget build(BuildContext context) {
    Widget userNameField() => _boolEdit == false
        ? Row(
            children: <Widget>[
              new Expanded(
                  flex: 1,
                  child: new Text(
                    _user?.displayName ?? 'N/A',
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
                  controller: _displayNameController,
                  style: new TextStyle(fontSize: 24.0, color: Colors.black),
                ),
              ),
              new FlatButton(
                child: _saveIcon(),
                onPressed: _changeName,
              ),
            ],
          );

    return new DrawerHeader(
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: new Container(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            userNameField(),
            new Text(
              _user.email ?? "N/A",
              style: new TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
