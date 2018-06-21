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
    new Tab(
      text: '總表',
    )
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
      new Summary_view(_model),
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
            labelText: TranslateHelper.translate(fieldlabel),
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
              labelText: TranslateHelper.translate(fieldlabel),
              labelStyle: Theme.of(context).textTheme.body2),
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: table),
        ),
      );
    }

    Widget buildRow(Map<String, dynamic> v) {
      List<TableRow> widget = [];
      v.forEach((key, value) {
        widget.add(new TableRow(children: [
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(TranslateHelper.translate(key))),
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
          buildRow(model.form.grooming.toJson()),
        ),
        buildScoreTile(
          'behavior',
          buildRow(model.form.behavior.toJson()),
        ),
        buildScoreTile(
          'serveCust',
          buildRow(model.form.serveCust.toJson()),
        ),
        buildScoreTile(
          'listenCust',
          buildRow(model.form.listenCust.toJson()),
        ),
        buildScoreTile(
          'handleCust',
          buildRow(model.form.handleCust.toJson()),
        ),
        buildScoreTile(
          'closure',
          buildRow(model.form.closure.toJson()),
        ),
        buildScoreTile(
          'communicationSkill',
          buildRow(model.form.communicationSkill.toJson()),
        ),
        buildScoreTile(
          'warmHeart',
          buildRow(model.form.warmHeart.toJson()),
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
              labelText: TranslateHelper.translate(fieldlabel),
              labelStyle: Theme.of(context).textTheme.body2),
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: table),
        ),
      );
    }

    Widget buildRow(Map<String, dynamic> v) {
      List<TableRow> widget = [];
      v.forEach((key, value) {
        widget.add(new TableRow(children: [
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(TranslateHelper.translate(key))),
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
          buildRow(model.form.cleanlinessMall.toJson()),
        ),
        buildScoreTile(
          'cleanlinessToilet',
          buildRow(model.form.cleanlinessToilet.toJson()),
        ),
      ],
    );
  }
}

class Summary_view extends StatelessWidget {
  Summary_view(this.model);
  final InspectionViewModel model;

  @override
  Widget build(BuildContext context) {
    String post = model.form.postName;

    TextStyle _boldStyle = Theme
        .of(context)
        .textTheme
        .body2
        .copyWith(fontWeight: FontWeight.bold, fontSize: 12.0);

    List<DataRow> buildRow() {
      Map<String, dynamic> rowData = {
        'grooming': model.form.grooming.toJson(),
        'behavior': model.form.behavior.toJson(),
        'serveCust': model.form.serveCust.toJson(),
        'listenCust': model.form.listenCust.toJson(),
        'handleCust': model.form.handleCust.toJson(),
        'closure': model.form.closure.toJson(),
        'communicationSkill': model.form.communicationSkill.toJson(),
        'warmHeart': model.form.warmHeart.toJson(),
        'cleanlinessMall': model.form.cleanlinessMall.toJson(),
        'cleanlinessToilet': model.form.cleanlinessToilet.toJson(),
      };

      if (post == '洗手間') rowData.removeWhere((k, v) => k == 'cleanlinessMall');
      if (post == '商場') rowData.removeWhere((k, v) => k == 'cleanlinessToilet');

      List<DataRow> row = [];
      double totalScore = 0.0;
      rowData.forEach((title, object) {
        double score = FormHelper.calculate(object);
        double factor = getFactor(title);
        double subtotal = (score * factor) / 100;
        totalScore += subtotal;
        row.add(new DataRow(cells: <DataCell>[
          new DataCell(new Text(TranslateHelper.translate(title)), onTap: null),
          new DataCell(new Text(score.toString()), onTap: null),
          new DataCell(new Text(factor.toInt().toString() + '%'), onTap: null),
          new DataCell(new Text(subtotal.toString()), onTap: null),
        ]));
      });
      row.add(new DataRow(onSelectChanged: null, cells: <DataCell>[
        new DataCell(
            new Text(
              TranslateHelper.translate('Total'),
              style: _boldStyle,
            ),
            onTap: null),
        new DataCell(new Text(''), onTap: null),
        new DataCell(new Text(''), onTap: null),
        new DataCell(new Text(totalScore.toString(), style: _boldStyle),
            onTap: null),
      ]));

      return row;
    }

    List<DataColumn> col = [
      new DataColumn(
          label: new Text(TranslateHelper.translate('SummaryViewTitle'),
              style: _boldStyle)),
      new DataColumn(
          label:
              new Text(TranslateHelper.translate('Score'), style: _boldStyle)),
      new DataColumn(
          label:
              new Text(TranslateHelper.translate('Factor'), style: _boldStyle)),
      new DataColumn(
          label:
              new Text(TranslateHelper.translate('Total'), style: _boldStyle))
    ];
    return ListView(
      children: <Widget>[
        new DataTable(
          columns: col,
          rows: buildRow(),
        ),
      ],
    );
  }

  double getFactor(String field) {
    double res = scoreFactorTemplate[field];
    return res;
  }

  final Map<String, double> scoreFactorTemplate = {
    'grooming': 20.0,
    'behavior': 10.0,
    'serveCust': 20.0,
    'listenCust': 10.0,
    'handleCust': 10.0,
    'closure': 10.0,
    'communicationSkill': 5.0,
    'warmHeart': 5.0,
    'cleanlinessMall': 10.0,
    'cleanlinessToilet': 10.0,
  };

  void addtoFirebase() {
    Firestore.instance
        .collection('setting')
        .document('ScoreFactor')
        .collection(model.form.bldgCode)
        .add(scoreFactorTemplate)
        .then((_) => print('done'));
  }
}
