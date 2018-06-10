part of nixon_app;

class InspectionModel extends Model {
  Inspection _form = new Inspection();
  Inspection get form => _form;
  set(Inspection myform) {
    _form = myform;
  }

  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;
  void setAutoValidate(bool v) {
    _autoValidate = v;
    notifyListeners();
  }
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
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  InspectionModel myModel = new InspectionModel();

  TabController _tabController;
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

    Inspection myform = widget.form;
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
    myModel.set(myform);

    myform = null;
    //_formDateController.text =
    //    FormHelper.datetoString(myform.inspectionDate ?? new DateTime.now());
  }

  Widget buildBody() {
    return new SafeArea(
      top: true,
      bottom: true,
      child: new ScopedModelDescendant<InspectionModel>(
        builder: (context, _, model) => new Form(
              key: _formKey,
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
          appBar: new AppBar(
            title: new Text("巡查表格"),
            bottom: new TabBar(
              controller: _tabController,
              tabs: myTabs,
            ),
          ),
          floatingActionButton: new ScopedModelDescendant<InspectionModel>(
              builder: (context, _, model) =>
                  new SaveActionButton(_formKey, model)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: new BottomNavBar(),
          body: buildBody(),
        ));
  }
}

class SaveActionButton extends StatelessWidget {
  SaveActionButton(this.formKey, this.model);
  final GlobalKey<FormState> formKey;
  final InspectionModel model;
  void navigatePop(BuildContext context) {
    Navigator.pop(context);
  }

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
          navigatePop(context);
        }).catchError((onError) =>
            showSnackBar(context, onError.toString(), bgcolor: Colors.red));
      } else {
        InspectionRepos.updateInspection(model.form).then((onValue) {
          navigatePop(context);
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
