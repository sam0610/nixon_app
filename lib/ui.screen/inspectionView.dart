part of nixon_app;

class InspectionViewModel extends Model {
  Inspection _form;
  Inspection get form => _form;
  set(Inspection myform) => _form = myform;
}

class InspectionView extends StatefulWidget {
  InspectionView({Key key, this.form}) : super(key: key);
  final Inspection form;

  @override
  _InspectionViewState createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView>
    with SingleTickerProviderStateMixin {
  InspectionViewModel _model;
  TabController _tabController;
  ScrollController _scrollViewController;
  TextTheme _textTheme;
  final List<Tab> _myTabs = <Tab>[
    new Tab(
      text: '巡查資料',
    ),
    new Tab(
      text: '服務評分',
    ),
    new Tab(
      text: '清潔評分',
    ),
    //new Tab(
    //  text: '總表',
    //)
  ];

  @override
  void initState() {
    super.initState();
    _model = InspectionViewModel();
    _model.set(widget.form);
    _tabController =
        new TabController(initialIndex: 0, length: _myTabs.length, vsync: this);
    _scrollViewController = new ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    return new ScopedModel<InspectionViewModel>(
      model: _model,
      child: new SafeArea(
        top: false,
        bottom: true,
        child: new Scaffold(
          body: new NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: new Text("巡查表格"),
                  pinned: true,
                  snap: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    tabs: _myTabs,
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: buildBody(),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return new ScopedModelDescendant<InspectionModel>(
        builder: (context, _, model) => new Container(
              child: buildTabBarView(),
            ));
  }

  TabBarView buildTabBarView() {
    return new TabBarView(controller: _tabController, children: <Widget>[
      new Info_view(_model),
      new Service_view(_model),
      new Cleaning_view(_model),
    ]);
  }
}

expanded(Widget child) => new Expanded(flex: 1, child: child);
row(List<Widget> children) => new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );

class Info_view extends StatelessWidget {
  Info_view(this.model);
  final InspectionViewModel model;

  @override
  Widget build(BuildContext context) {
    Widget buildTile(String fieldlabel, dynamic value) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: new InputDecorator(
          decoration: new InputDecoration(
            border: UnderlineInputBorder(),
            labelText: Inspection.translate(fieldlabel),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new Text(
              value.toString(),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        ),
      );
    }

    return new ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        buildTile('inspectionDate',
            FormHelper.datetoString(model.form.inspectionDate)),
        row(
          [
            expanded(buildTile('arrivedTime', model.form.arrivedTime)),
            expanded(buildTile('leaveTime', model.form.leaveTime))
          ],
        ),
        buildTile('bldgName', model.form.bldgName),
        row(
          [
            expanded(buildTile('nixonNumber', model.form.nixonNumber)),
            expanded(buildTile('staffName', model.form.staffName))
          ],
        ),
        row(
          [
            expanded(buildTile('foundLocation', model.form.foundLocation)),
            expanded(buildTile('postName', model.form.postName)),
            expanded(buildTile('guestsProportion', model.form.guestsProportion))
          ],
        ),
        buildTile('guestsProportion', model.form.situationRemark)
      ],
    );
  }
}

class Service_view extends StatelessWidget {
  Service_view(this.model);
  final InspectionViewModel model;

  @override
  Widget build(BuildContext context) {
    Widget buildScoreTile(String fieldlabel, Table table) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: new InputDecorator(
          decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: Inspection.translate(fieldlabel),
              labelStyle: Theme.of(context).textTheme.body2),
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: table),
        ),
      );
    }

    Widget bi(Map<String, dynamic> v) {
      List<TableRow> widget = [];
      v.forEach((key, value) {
        widget.add(new TableRow(children: [
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(Inspection.translate(key))),
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(
                value.toString(),
                style: Theme.of(context).textTheme.body2,
              )),
        ]));
      });
      return new Table(children: widget);
    }

    return new ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        buildScoreTile(
          'grooming',
          bi(model.form.grooming.toJson()),
        ),
        buildScoreTile(
          'behavior',
          bi(model.form.behavior.toJson()),
        ),
        buildScoreTile(
          'serveCust',
          bi(model.form.serveCust.toJson()),
        ),
        buildScoreTile(
          'listenCust',
          bi(model.form.listenCust.toJson()),
        ),
        buildScoreTile(
          'handleCust',
          bi(model.form.handleCust.toJson()),
        ),
        buildScoreTile(
          'closure',
          bi(model.form.closure.toJson()),
        ),
        buildScoreTile(
          'communicationSkill',
          bi(model.form.communicationSkill.toJson()),
        ),
        buildScoreTile(
          'warmHeart',
          bi(model.form.warmHeart.toJson()),
        ),
      ],
    );
  }
}

class Cleaning_view extends StatelessWidget {
  Cleaning_view(this.model);
  final InspectionViewModel model;

  @override
  Widget build(BuildContext context) {
    Widget buildScoreTile(String fieldlabel, Table table) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: new InputDecorator(
          decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: Inspection.translate(fieldlabel),
              labelStyle: Theme.of(context).textTheme.body2),
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: table),
        ),
      );
    }

    Widget bi(Map<String, dynamic> v) {
      List<TableRow> widget = [];
      v.forEach((key, value) {
        widget.add(new TableRow(children: [
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(Inspection.translate(key))),
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(
                value.toString(),
                style: Theme.of(context).textTheme.body2,
              )),
        ]));
      });
      return new Table(children: widget);
    }

    return new ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        buildScoreTile(
          'cleanlinessMall',
          bi(model.form.cleanlinessMall.toJson()),
        ),
        buildScoreTile(
          'cleanlinessToilet',
          bi(model.form.cleanlinessToilet.toJson()),
        ),
      ],
    );
  }
}
