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
  TabController _tabController;
  List<Tab> myTabs = <Tab>[
    new Tab(
      icon: new Icon(
        Icons.edit,
      ),
    ),
    new Tab(
      icon: new Icon(Icons.check_circle),
    ),
    new Tab(
      icon: new Icon(Icons.archive),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _assureLogin();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  _assureLogin() {
    _auth.onAuthStateChanged.firstWhere((user) => user == null).then((user) {
      AuthHelper.setCurrentUser(null);
      Navigator.of(context).pushReplacementNamed("/login");
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
        title: new Text("Mystery Shopper"),
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add_circle),
        onPressed: () => _addForm(),
      ),
      drawer: DrawerWidget(
        context: context,
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          InspectionBody(InspectionStatus.composing),
          InspectionBody(InspectionStatus.complete),
          InspectionBody(InspectionStatus.archived),
        ],
      ),
      bottomNavigationBar: new Material(
          color: Theme.of(context).primaryColor,
          child: new TabBar(
            controller: _tabController,
            tabs: myTabs,
          )),
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
    FormHelper()
        ._confirmDialog(context: context, title: "確認刪除?", msg: "")
        .then((res) {
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
