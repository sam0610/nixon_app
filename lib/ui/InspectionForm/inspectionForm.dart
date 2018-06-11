part of nixon_app;

class InspectionModel extends Model {
  Inspection _form = new Inspection();
  Inspection get form => _form;
  set(Inspection myform) {
    if (myform.userid == null) myform.userid = _user.uid;
    if (myform.inspectionDate == null) myform.inspectionDate = DateTime.now();
    if (myform.arrivedTime == null)
      myform.arrivedTime = FormHelper.timetoString(TimeOfDay.now());
    if (myform.leaveTime == null)
      myform.leaveTime = FormHelper.timetoString(TimeOfDay.now());
    if (myform.guestsProportion == null) myform.guestsProportion = "0";
    if (myform.grooming == null) myform.grooming = new Grooming();
    if (myform.behavior == null) myform.behavior = new Behavior();
    if (myform.warmHeart == null) myform.warmHeart = new WarmHeart();
    if (myform.serveCust == null) myform.serveCust = new ServeCust();
    if (myform.handleCust == null) myform.handleCust = new HandleCust();
    if (myform.listenCust == null) myform.listenCust = new ListenCust();
    if (myform.cleanlinessMall == null)
      myform.cleanlinessMall = new CleanlinessMall();
    if (myform.cleanlinessToilet == null)
      myform.cleanlinessToilet = new CleanlinessToilet();
    if (myform.closure == null) myform.closure = new Closure();
    if (myform.communicationSkill == null)
      myform.communicationSkill = new CommunicationSkill();

    _form = myform;
  }

  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;
  void setAutoValidate(bool v) {
    _autoValidate = v;
    notifyListeners();
  }

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
}

class InspectionForm extends StatefulWidget {
  InspectionForm({Key key, this.form}) : super(key: key);
  final Inspection form;
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

//Inspection myform;

class _InspectionFormState extends State<InspectionForm>
    with SingleTickerProviderStateMixin {
  // GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  InspectionModel myModel = new InspectionModel();

  TabController _tabController;
  ScrollController _scrollViewController;
  final List<Tab> myTabs = <Tab>[
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
    _tabController =
        new TabController(initialIndex: 0, length: myTabs.length, vsync: this);
    _scrollViewController = new ScrollController();
    myModel.set(widget.form);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  Widget buildBody() {
    return new SafeArea(
      top: true,
      bottom: true,
      child: new ScopedModelDescendant<InspectionModel>(
        builder: (context, _, model) => new Form(
              key: model._globalKey,
              autovalidate: model.autoValidate,
              child:
                  new TabBarView(controller: _tabController, children: <Widget>[
                new ViewInfo(),
                new ViewService(),
                new ViewCleaning(),
                new ViewSummary(),
              ]),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<InspectionModel>(
      model: myModel,
      child: new Scaffold(
        body: new NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: new Text("巡查表格"),
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                bottom: new TabBar(
                  tabs: myTabs,
                  controller: _tabController,
                ),
              ),
            ];
          },
          body: buildBody(),
        ),
        floatingActionButton: new ScopedModelDescendant<InspectionModel>(
            builder: (context, _, model) =>
                new SaveActionButton(model._globalKey, model)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: new BottomNavBar(),
      ),
    );
  }
}

class SaveActionButton extends StatelessWidget {
  SaveActionButton(this.formKey, this.model);
  final GlobalKey<FormState> formKey;
  final InspectionModel model;

  void showSnackBar(BuildContext context, String msg,
      {Color bgcolor = Colors.blue}) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 10),
              content: new Text(msg),
              backgroundColor: bgcolor),
        );
  }

  void _save(BuildContext context) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (model.form.id == null) {
        InspectionRepos.addInspection(model.form).then((onValue) {
          Navigator.pop(context);
        }).catchError((onError) =>
            showSnackBar(context, onError.toString(), bgcolor: Colors.red));
      } else {
        InspectionRepos.updateInspection(model.form).then((onValue) {
          Navigator.pop(context);
        }).catchError((onError) =>
            showSnackBar(context, onError.toString(), bgcolor: Colors.red));
      }
    } else {
      showSnackBar(context, 'Please fill in blank field', bgcolor: Colors.red);
      InspectionModel model = ModelFinder().of(context);
      model.setAutoValidate(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
        child: Icon(Icons.save), onPressed: () => _save(context));
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      hasNotch: true,
      child: new Padding(
        padding: EdgeInsets.all(15.0),
        child: new Text(""),
      ),
    );
  }
}
