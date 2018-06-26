part of nixon_app;

class InspectionModel extends Model {
  Inspection _form;
  Inspection get form => _form;

  set(Inspection myform) {
    if (myform.userid == null) myform.userid = _user.uid;
    if (myform.status == null) myform.status = InspectionStatus.composing;
    if (myform.inspectionDate == null) myform.inspectionDate = DateTime.now();
    if (myform.arrivedTime == null)
      myform.arrivedTime = FormHelper.timetoString(TimeOfDay.now());
    if (myform.leaveTime == null)
      myform.leaveTime = FormHelper.timetoString(TimeOfDay.now());

    _form = myform;
  }

  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;
  void setAutoValidate(bool v) {
    _autoValidate = v;
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
  bool _formWasEdited = false;
  bool get isFormCompleted => _form.status == InspectionStatus.complete;
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
      text: '錄音',
    ),
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
    return new ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new Form(
            key: model._globalKey,
            autovalidate: model.autoValidate,
            onWillPop: _warnUserAboutInvalidData,
            child: model.isFormCompleted
                ? completedBanner(buildTabBarView())
                : buildTabBarView(),
          ),
    );
  }

  TabBarView buildTabBarView() {
    return new TabBarView(controller: _tabController, children: <Widget>[
      new ViewRecorder(),
      new ViewInfo(),
      new ViewService(),
      new ViewCleaning(),
      new ViewSummary(),
    ]);
  }

  Widget completedBanner(TabBarView child) {
    return new Stack(overflow: Overflow.clip, children: <Widget>[
      new Banner(
        message: "Completed",
        location: BannerLocation.topStart,
      ),
      child,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<InspectionModel>(
      model: myModel,
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
                    tabs: myTabs,
                    controller: _tabController,
                  ),
                  actions: <Widget>[
                    new ScopedModelDescendant<InspectionModel>(
                      builder: (context, _, model) =>
                          new SaveActionButton(model),
                    ),
                  ],
                ),
              ];
            },
            body: buildBody(),
          ),
        ),
      ),
    );
  }

  Future<bool> _warnUserAboutInvalidData() async {
    myModel._globalKey.currentState.validate();
    if (!myModel._formWasEdited) return true;

    return await FormHelper()._confirmDialog(
            context: context, title: '有未儲存修改!!!', msg: '確認離開?') ??
        false;
  }
}

class SaveActionButton extends StatelessWidget {
  SaveActionButton(this.model);
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

  _save(BuildContext context) {
    final form = model._globalKey.currentState;
    if (form.validate()) {
      form.save();
      if (model.form.files != null) {
        print(FormHelper.datetoString(model.form.inspectionDate));
        if (model.form.id == null) {
          InspectionRepos.addInspection(model.form).whenComplete(() {
            Navigator.pop(context);
          }).catchError((onError) =>
              showSnackBar(context, onError.toString(), bgcolor: Colors.red));
        } else {
          InspectionRepos.updateInspection(model.form).whenComplete(() {
            Navigator.pop(context);
          }).catchError((onError) =>
              showSnackBar(context, onError.toString(), bgcolor: Colors.red));
        }
      }
    } else {
      showSnackBar(context, 'Please fill in blank field', bgcolor: Colors.red);
      model.setAutoValidate(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.save),
      onPressed: model.isFormCompleted ? null : () => _save(context),
    );
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
