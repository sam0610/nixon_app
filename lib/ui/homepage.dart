part of nixon_app;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool boolEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assureLogin();
  }

  _assureLogin() async {
    if (_user == null) Navigator.pushReplacementNamed(context, "/login");
  }

  void _signOut() {
    _auth.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
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
              new Header(),
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
        body: new Form(
          autovalidate: false,
          child: new DropDownFormField(
              labelText: "BLDG",
              initialValue: null,
              validator: (value) => value == null ? "error" : null,
              onChanged: (value) => print(value),
              onSaved: (value) => print(value)),
        ));
  }
}

class BuildingDropDown extends StatefulWidget {
  BuildingDropDown({this.onChanged});

  final Function onChanged;

  @override
  _BuildingDropDownState createState() => new _BuildingDropDownState();
}

class _BuildingDropDownState extends State<BuildingDropDown> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FutureBuilder<List<BuildingData>>(
        future: fetchBldgList(new http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text(snapshot.error);
          }
          return snapshot.hasData
              ? new Dropdown(snapshot.data)
              : new Center(child: new AnimatedCircularProgress());
        },
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  Dropdown(this._values);
  final List<BuildingData> _values;
  @override
  _DropdownState createState() => new _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  BuildingData _value;

  @override
  void initState() {
    super.initState();
  }

  void _onChanged(BuildingData value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
        value: _value,
        items: widget._values.map((value) {
          return new DropdownMenuItem(
              value: value,
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.home),
                  new Text(
                    value.buildingName.toString(),
                  ),
                ],
              ));
        }).toList(),
        onChanged: (selection) {
          _onChanged(selection);
        });
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
