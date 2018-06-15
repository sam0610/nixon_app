part of nixon_app;

class BuildingDialog extends StatefulWidget {
  @override
  _BuildingDialogState createState() => new _BuildingDialogState();
}

class _BuildingDialogState extends State<BuildingDialog> {
  List<BuildingData> buildingList;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  getBldg() async {
    await fetchBldgList(new http.Client())
        .then((bldg) => buildingList = bldg)
        .catchError((e) => print(e));
  }

  Widget body() {
    return new Container(
      child: new ListView.builder(
        itemCount: buildingList.length,
        itemExtent: 90.0,
        itemBuilder: (BuildContext ctx, int index) {
          BuildingData bldg = buildingList[index];
          return new Container(
              color: index % 2 == 1
                  ? Theme.of(context).primaryColor.withAlpha(300)
                  : Colors.white,
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new ListTile(
                      onTap: () => Navigator.of(context).pop(bldg),
                      title: new Text(
                        bldg.accBuildingCode,
                      ),
                      subtitle: new Text(bldg.buildingName)),
                ),
              ]));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getBldg(),
      renderLoad: () => new Center(child: new AnimatedCircularProgress()),
      renderError: ([error]) => new Text('no Data'),
      renderSuccess: ({data}) => body(),
    );

    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Select a Building'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () => _asyncLoaderState.currentState.reloadState(),
            )
          ],
        ),
        body: _asyncLoader);
  }
}
