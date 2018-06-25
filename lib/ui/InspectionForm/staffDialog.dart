part of nixon_app;

class StaffDialog extends StatefulWidget {
  StaffDialog({@required this.bldgCode, @required this.yyyymm});
  final String bldgCode;
  final String yyyymm;

  @override
  _StaffDialogState createState() => new _StaffDialogState();
}

class _StaffDialogState extends State<StaffDialog> {
  List<StaffData> _staffList = [];
  List<StaffData> _staffListFiltered = [];
  Map<int, int> _count = {};
  TextEditingController _filterController = new TextEditingController();
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  getStaff() async {
    await fetchStaffList(new http.Client(), widget.bldgCode)
        .timeout(new Duration(seconds: 10))
        .then((staff) {
      _staffList = staff;
    }).catchError((e) => print(e));

    InspectionRepos.countFormbyStaff(widget.yyyymm).then((map) => _count = map);
  }

  // getInspectionRecord() {
  //   CollectionReference reference = inspectionCollection;
  //   Query query = reference.where('inspectionDate', isEqualTo: '2018.06');
  // }

  void _searchTextChanged(String text) {
    _staffListFiltered = [];
    _staffList.forEach((f) {
      if (f.givenName.contains(text)) {
        _staffListFiltered.add(f);
      }
    });
    setState(() {});
  }

  Widget _staffListBuilder(List<StaffData> _list) {
    return new ListView.builder(
        itemCount: _list.length,
        itemExtent: 90.0,
        itemBuilder: (BuildContext ctx, int index) {
          StaffData staff = _list[index];
          return new Container(
              color: index % 2 == 1
                  ? Theme.of(context).primaryColor.withAlpha(300)
                  : Colors.white,
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new ListTile(
                      trailing: _count[staff.nixonNumber] != null
                          ? new CircleAvatar(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              child: new Text(
                                  _count[staff.nixonNumber].toString()))
                          : new CircleAvatar(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              child: new Text('0')),
                      onTap: () => Navigator.of(context).pop(staff),
                      title: new Text(
                        staff.nixonNumber.toString(),
                      ),
                      subtitle: new Text(staff.givenName)),
                ),
              ]));
        });
  }

  Widget searchBox() {
    return new Container(
        child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new ListTile(
        leading: new Icon(Icons.search),
        title: new TextField(
          controller: _filterController,
          decoration:
              new InputDecoration(hintText: 'Search', border: InputBorder.none),
          onChanged: _searchTextChanged,
        ),
        trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              _filterController.clear();
              _searchTextChanged('');
            }),
      ),
    ));
  }

  Widget body() {
    return new Column(
      children: <Widget>[
        searchBox(),
        new Expanded(
            child: _staffListFiltered.length != 0 ||
                    _filterController.text.isNotEmpty
                ? _staffListBuilder(_staffListFiltered)
                : _staffListBuilder(_staffList)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getStaff(),
      renderLoad: () => new Center(child: new AnimatedCircularProgress()),
      renderError: ([error]) => new Text('no Data'),
      renderSuccess: ({data}) => body(),
    );

    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Select a Staff'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () => _asyncLoaderState.currentState.reloadState()),
          ],
        ),
        body: _asyncLoader);
  }
}
