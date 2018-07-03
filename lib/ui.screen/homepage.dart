part of nixon_app;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool boolEdit = false;
  bool _loading = false;
  InspectionStatus _status = InspectionStatus.composing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assureLogin();
  }

  _assureLogin() {
    _auth.onAuthStateChanged.firstWhere((user) => user == null).then((user) {
      AuthHelper.setCurrentUser(null);
      Navigator.of(context).pop;
      Navigator
          .of(context)
          .pushNamedAndRemoveUntil("/login", ModalRoute.withName('/'));
    });
  }

  _addForm() {
    Inspection newform = new Inspection.withDefault();
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
          title: new Text(TranslateHelper.translate("Mystery Shopper")),
          centerTitle: true,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => _addForm(),
        ),
        body: new SafeArea(
          top: true,
          bottom: true,
          child: InspectionBody(_status),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: new BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: new Row(children: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  showModalBottomSheet<InspectionStatus>(
                      context: context,
                      builder: (BuildContext context) =>
                          new BottomDrawer(status: _status)).then((status) {
                    if (status != null) {
                      setState(() {
                        _status = status;
                      });
                    }
                  });
                },
              )
            ])));
  }
}

class BottomDrawer extends StatefulWidget {
  BottomDrawer({Key key, this.status}) : super(key: key);
  final InspectionStatus status;
  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class item {
  item({this.title, this.status});
  @required
  String title;
  @required
  InspectionStatus status;
}

class _BottomDrawerState extends State<BottomDrawer> {
  List<item> _items = [
    new item(
        title: TranslateHelper.translate(InspectionStatus.composing.toString()),
        status: InspectionStatus.composing),
    new item(
        title: TranslateHelper.translate(InspectionStatus.complete.toString()),
        status: InspectionStatus.complete),
    new item(
      title: TranslateHelper.translate(InspectionStatus.archived.toString()),
      status: InspectionStatus.archived,
    )
  ];

  void changeName(BuildContext _context) async {
    TextEditingController _controller = new TextEditingController();

    String result = await showDialog(
      context: _context,
      builder: (BuildContext context) => new AlertDialog(
            content: new TextFormField(
                controller: _controller,
                decoration: new InputDecoration(
                    hintText: 'new display name',
                    suffixIcon: new IconButton(
                      icon: new Icon(Icons.subdirectory_arrow_left),
                      onPressed: () =>
                          Navigator.of(context).pop(_controller.text),
                    ))),
          ),
    );
    if (result != null && result.isNotEmpty) {
      AuthHelper.updateProfileName(result).then((s) => _user.reload());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0), bottom: Radius.zero),
        ),
        child: new Column(
          children: <Widget>[
            new ExpansionTile(
              title: new ListTile(
                  leading: new Icon(
                    Icons.account_circle,
                  ),
                  title: new Text(_user.displayName),
                  subtitle: new Text(_user.email)),
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new FlatButton.icon(
                      icon: new Icon(Icons.mode_edit),
                      label: new Text('Change display name'),
                      onPressed: () => changeName(context),
                    ),
                    new FlatButton.icon(
                      icon: new Icon(Icons.exit_to_app),
                      label: new Text('Logout'),
                      onPressed: () => _auth.signOut(),
                    )
                  ],
                )
              ],
            ),
            new Divider(),
            new Column(
              children: _items.map((item) {
                bool selected = item.status == widget.status;
                TextStyle style = selected
                    ? Theme
                        .of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold)
                    : Theme.of(context).textTheme.body1;

                return Container(
                  foregroundDecoration: new BoxDecoration(
                    borderRadius: new BorderRadius.horizontal(
                        left: Radius.circular(20.0),
                        right: Radius.circular(0.0)),
                    gradient: selected
                        ? new LinearGradient(colors: [
                            Theme.of(context).primaryColor.withOpacity(0.2),
                            Theme.of(context).primaryColor.withOpacity(0.1)
                          ])
                        : null,
                  ),
                  child: ListTile(
                    title: Text(
                      TranslateHelper.translate(item.title),
                      style: style,
                    ),
                    onTap: () => Navigator.of(context).pop(item.status),
                  ),
                );
              }).toList(),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}

class InspectionBody extends StatelessWidget {
  InspectionBody(this.status);
  final InspectionStatus status;
  @override
  Widget build(BuildContext context) {
    Query query =
        inspectionByUser.where('status', isEqualTo: status.toString());
    return new StreamBuilder(
        stream: query.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: Alignment.center,
                child: new Center(child: new AnimatedCircularProgress()));
          return FirestoreListView(
            documents: snapshot.data.documents,
          );
        });
  }
}

class FirestoreListView extends StatelessWidget {
  FirestoreListView({this.documents});
  final List<DocumentSnapshot> documents;

  void _open(BuildContext context, Inspection inspection) {
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => inspection.status != InspectionStatus.composing
                ? new InspectionView(form: inspection)
                : new InspectionForm(form: inspection),
          ),
        );
  }

  void _delete(DocumentSnapshot snapshot, BuildContext context) {
    FormHelper()._confirmDialog(context: context, title: "確認刪除").then((res) {
      if (res)
        InspectionRepos.deleteInspectionbySnapshot(snapshot).then((onValue) {
          FormHelper.showSnackBar(context, "Deleted");
        });
    });
  }

  void _archive(DocumentSnapshot snapshot, InspectionStatus status,
      BuildContext context) {
    InspectionRepos.changeInspectionStatus(snapshot, status).then((_) {
      FormHelper.showSnackBar(context, 'changed to $status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        Inspection inspection = new Inspection.fromJson(documents[index].data);

        bool showDeleteBtn = inspection.status == InspectionStatus.composing;

        bool showArchiveBtn = inspection.status == InspectionStatus.complete;

        String inspDate = FormHelper.datetoString(inspection.inspectionDate);
        TextStyle subheadStyle = Theme
            .of(context)
            .textTheme
            .subhead
            .copyWith(fontSize: 16.0, color: Colors.black87);
        return new MaterialButton(
          splashColor: Theme.of(context).primaryColor.withAlpha(255),
          onPressed: () => _open(context, inspection),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new ListTile(
                    trailing: showDeleteBtn
                        ? new IconButton(
                            icon: new Icon(Icons.delete),
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              _delete(documents[index], context);
                            })
                        : showArchiveBtn
                            ? new IconButton(
                                icon: new Icon(Icons.archive),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _archive(documents[index],
                                      InspectionStatus.archived, context);
                                })
                            : new IconButton(
                                icon: new Icon(Icons.unarchive),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _archive(documents[index],
                                      InspectionStatus.complete, context);
                                }),
                    title: new Text(
                      inspDate,
                      style: subheadStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: new Text(inspection.bldgName,
                                style: subheadStyle)),
                        new Expanded(
                            flex: 0,
                            child: new SizedBox(
                              height: 0.0,
                            )),
                        new Expanded(
                            flex: 1,
                            child: new Text(inspection.staffName,
                                style: subheadStyle)),
                      ],
                    )),
              ),
              new Divider(
                color: Colors.black,
              )
            ],
          ),
        );
      },
    );
  }
}
