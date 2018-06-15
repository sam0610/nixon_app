part of nixon_app;

class DrawerWidget extends StatelessWidget {
  DrawerWidget({this.context});
  final BuildContext context;

  void _signOut() {
    _auth.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new Header(),
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
