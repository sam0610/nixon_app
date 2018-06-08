part of nixon_app;

class InspectionForm extends StatefulWidget {
  InspectionForm({Key key, this.form}) : super(key: key);
  final Inspection form;
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

Inspection myform;

bool _autoValidate = false;

class _InspectionFormState extends State<InspectionForm>
    // ignore: mixin_inherits_from_not_object
    with
        SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
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
    myform = widget.form;
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

    //_formDateController.text =
    //    FormHelper.datetoString(myform.inspectionDate ?? new DateTime.now());
  }

  Widget buildBody() {
    return new SafeArea(
      top: true,
      bottom: true,
      child: new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: new TabBarView(controller: _tabController, children: <Widget>[
          new ViewInfo(),
          new ViewService(),
          new ViewCleaning(),
          new ViewSummary(myform),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("巡查表格"),
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      floatingActionButton: new SaveActionButton(_formKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomNavBar(),
      body: buildBody(),
    );
  }
}

class SaveActionButton extends StatefulWidget {
  SaveActionButton(this.formKey);
  final GlobalKey<FormState> formKey;

  @override
  _SaveActionButtonState createState() => new _SaveActionButtonState();
}

class _SaveActionButtonState extends State<SaveActionButton> {
  void showSnackBar(String msg, {Color bgcolor = Colors.blue}) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 10),
              content: new Text(msg),
              backgroundColor: bgcolor),
        );
  }

  void navigatePop() {
    Navigator.pop(context);
  }

  void _save(BuildContext context) {
    final form = widget.formKey.currentState;
    if (form.validate()) {
      form.save();
      if (myform.id == null) {
        InspectionRepos.addInspection(myform).then((onValue) {
          navigatePop();
        }).catchError(
            (onError) => showSnackBar(onError.toString(), bgcolor: Colors.red));
      } else {
        InspectionRepos.updateInspection(myform).then((onValue) {
          navigatePop();
        }).catchError(
            (onError) => showSnackBar(onError.toString(), bgcolor: Colors.red));
      }
    } else {
      showSnackBar('Please fill in blank field', bgcolor: Colors.red);
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
        child: Icon(Icons.save), onPressed: () => _save(context));
  }
}

class BuildDropdown extends StatefulWidget {
  BuildDropdown({this.onChanged, this.initialValue});
  final Function onChanged;
  final String initialValue;

  @override
  _BuildDropdownState createState() => new _BuildDropdownState();
}

class _BuildDropdownState extends State<BuildDropdown> {
  List<DropdownMenuItem<String>> _items;
  String _selectedValue;

  @override
  void initState() {
    super.initState();
    _buildItems();
    _selectedValue = widget.initialValue;
  }

  _buildItems() {
    _items = new List();
    _selectedValue = widget.initialValue;

    _items.add(new DropdownMenuItem(
      value: '商場',
      child: new Text('商場'),
    ));

    _items.add(new DropdownMenuItem(
      value: '洗手間',
      child: new Text('洗手間'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
        items: _items,
        value: _selectedValue,
        onChanged: (value) => widget.onChanged(value));
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

class ViewInfo extends StatefulWidget {
  @override
  _ViewInfoState createState() => new _ViewInfoState();
}

class _ViewInfoState extends State<ViewInfo>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _staffNameController = new TextEditingController(),
      _situationRemarkController = new TextEditingController(),
      _foundLocationController = new TextEditingController(),
      _nxNumberController = new TextEditingController(),
      _bldgNameController = new TextEditingController(),
      _bldgCodeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _bldgNameController.text = myform.bldgName.toString();
    _bldgCodeController.text = myform.bldgCode.toString();
    _nxNumberController.text = myform.nixonNumber.toString();
  }

  void _showBuildingDialog() async {
    BuildingData building =
        await Navigator.of(context).push(new MaterialPageRoute<BuildingData>(
            builder: (BuildContext context) {
              return new BuildingDialog();
            },
            fullscreenDialog: true));

    if (building != null) {
      setState(() {
        _bldgNameController.text = building.buildingName;
        _bldgCodeController.text = building.accBuildingCode;
      });
    }
  }

  void _showStaffDialog() async {
    StaffData staffData =
        await Navigator.of(context).push(new MaterialPageRoute<StaffData>(
            builder: (BuildContext context) {
              return new StaffDialog(bldgCode: _bldgCodeController.text);
            },
            fullscreenDialog: true));

    if (staffData != null) {
      setState(() {
        _nxNumberController.text = staffData.nixonNumber.toString();
        _staffNameController.text = staffData.givenName;
      });
    }
  }

  Widget makeDropDownWidget(
      {@required String labelText,
      @required String initialValue,
      @required ValueChanged<String> onSave(value),
      @required ValueChanged<String> onChanged(value)}) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: new DropDownFormField(
        initialValue: initialValue,
        values: ['商場', '洗手間'],
        validator: (value) => value == 0 ? '$labelText Not Set' : null,
        onSave: (value) => print(value),
        labelText: labelText,
        onChanged: (value) => onChanged(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      children: <Widget>[
        new DateTextField(
          labelText: Inspection.translate('inspectionDate'),
          initialValue: myform.inspectionDate,
          validator: (value) =>
              myform.inspectionDate == null ? 'Date is Empty' : null,
          onChanged: (value) => myform.inspectionDate = value,
          onSaved: (value) => myform.inspectionDate = value,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: Inspection.translate('arrivedTime'),
                  initialValue: FormHelper.strToTime(myform.arrivedTime),
                  validator: (value) =>
                      myform.arrivedTime == null ? "not set" : null,
                  onChanged: (value) {
                    setState(() {
                      myform.arrivedTime = FormHelper.timetoString(value);
                      myform.leaveTime = myform.arrivedTime;
                    });
                  },
                  onSaved: (value) => myform.arrivedTime = FormHelper
                      .timetoString(value) //FormHelper.timetoString(value)),
                  ),
            ),
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: Inspection.translate('leaveTime'),
                  initialValue: FormHelper.strToTime(myform.leaveTime),
                  validator: (value) =>
                      myform.leaveTime == null ? "not set" : null,
                  onChanged: (value) =>
                      myform.leaveTime = FormHelper.timetoString(value),
                  onSaved: (value) => myform.leaveTime = FormHelper
                      .timetoString(value) // FormHelper.timetoString(value))),
                  ),
            ),
          ],
        ),
        new TextFormField(
          style: Theme.of(context).textTheme.body2,
          decoration: InputDecoration(
            suffixIcon: new IconButton(
                icon: new Icon(Icons.search), onPressed: _showBuildingDialog),
            labelText: Inspection.translate('bldgCode'),
          ),
          controller: _bldgCodeController,
          onFieldSubmitted: (value) => _bldgCodeController.text = value,
          validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
          onSaved: (value) => myform.bldgCode = value,
        ),
        new TextFormField(
          style: Theme.of(context).textTheme.body2,
          decoration: InputDecoration(
            labelText: Inspection.translate('bldgName'),
          ),
          controller: _bldgNameController,
          onFieldSubmitted: (value) => _bldgNameController.text = value,
          validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
          onSaved: (value) => myform.bldgName = value,
        ),
        new TextFormField(
          style: Theme.of(context).textTheme.body2,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixIcon: new IconButton(
                icon: new Icon(Icons.search), onPressed: _showStaffDialog),
            labelText: Inspection.translate('nixonNumber'),
          ),
          controller: _nxNumberController,
          onFieldSubmitted: (value) => _nxNumberController.text = value,
          validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
          onSaved: (value) => myform.nixonNumber = FormHelper.strToInt(value),
        ),
        MyFormTextField(
            labelText: Inspection.translate('staffName'),
            initialValue: myform.staffName,
            controller: _staffNameController,
            nullable: false,
            onSave: (value) => myform.staffName = value),
        new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: MyFormTextField(
                  labelText: Inspection.translate('foundLocation'),
                  initialValue: myform.foundLocation,
                  controller: _foundLocationController,
                  onSave: (value) => myform.foundLocation = value),
            ),
            new Expanded(
              flex: 1,
              child: makeDropDownWidget(
                  labelText: Inspection.translate('postName'),
                  initialValue: myform.postName,
                  onSave: (value) => myform.postName = value,
                  onChanged: (value) => myform.postName = value),
            ),
            new Expanded(
              flex: 1,
              child: NumberFormField(
                  labelText: Inspection.translate('guestsProportion'),
                  validator: (value) => null,
                  initialValue: int.tryParse(myform.guestsProportion) ?? 0,
                  onChanged: (value) =>
                      myform.guestsProportion = value.toString(),
                  onSaved: (value) =>
                      myform.guestsProportion = value.toString()),
            ),
          ],
        ),
        MyFormTextField(
            labelText: Inspection.translate('situationRemark'),
            initialValue: myform.situationRemark,
            maxLines: 1,
            controller: _situationRemarkController,
            onSave: (value) => myform.situationRemark = value),
      ],
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class ViewService extends StatefulWidget {
  @override
  _ViewServiceState createState() => new _ViewServiceState();
}

class _ViewServiceState extends State<ViewService>
    with AutomaticKeepAliveClientMixin {
  Widget expansionContainer({List<Widget> children, String name}) {
    Widget buildTitle() {
      return new Row(children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: new Text(
              name,
            ),
          ),
        ),
      ]);
    }

    return new Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: new ExpansionTile(
        onExpansionChanged: (b) => setState(() {
              PageStorage
                  .of(context)
                  .writeState(context, b, identifier: ValueKey(name));
            }),
        initiallyExpanded: PageStorage
                .of(context)
                .readState(context, identifier: ValueKey(name)) ??
            false,
        title: buildTitle(),
        children: children,
      ),
    );
  }

  Widget makeSliderWidget(
      {@required String labelText,
      @required int initialValue,
      @required ValueChanged<int> onChanged(value)}) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: new SliderFormField(
          initialValue: initialValue,
          validator: (value) => value == 0 ? '$labelText Not Set' : null,
          onSaved: (value) => print(value),
          labelText: labelText,
          onChanged: (value) => onChanged(value)),
    );
  }

  Widget makeSwitchWidget(
      {@required String labelText,
      @required int initialValue,
      @required ValueChanged<int> onChanged(value)}) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: new CheckBoxFormField(
          initialValue: initialValue,
          validator: (value) => value == 0 ? '$labelText Not Set' : null,
          onSaved: (value) => print(value),
          labelText: labelText,
          onChanged: (value) => onChanged(value)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        expansionContainer(name: Inspection.translate('grooming'),
            //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            children: <Widget>[
              makeSliderWidget(
                initialValue: myform.grooming.groomingScore,
                labelText: Inspection.translate('groomingScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.groomingScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.hairScore,
                labelText: Inspection.translate('hairScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.hairScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.uniformScore,
                labelText: Inspection.translate('uniformScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.uniformScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.decorationScore,
                labelText: Inspection.translate('decorationScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.decorationScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.maskWearScore,
                labelText: Inspection.translate('maskWearScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.maskWearScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.maskCleanScore,
                labelText: Inspection.translate('maskCleanScore'),
                onChanged: (value) {
                  setState(() {
                    myform.grooming.maskCleanScore = value;
                  });
                },
              )
            ]),
        expansionContainer(
          name: Inspection.translate('behavior'),
          children: <Widget>[
            makeSliderWidget(
              initialValue: myform.behavior.behaviorScore,
              labelText: Inspection.translate('behaviorScore'),
              onChanged: (value) {
                setState(() {
                  myform.behavior.behaviorScore = value;
                });
              },
            ),
            makeSliderWidget(
              initialValue: myform.behavior.mindScore,
              labelText: Inspection.translate('mindScore'),
              onChanged: (value) {
                setState(() {
                  myform.behavior.mindScore = value;
                });
              },
            ),
          ],
        ),
        expansionContainer(
            name: Inspection.translate(
              'serveCust',
            ),
            children: [
              makeSliderWidget(
                initialValue: myform.serveCust.smileScore,
                labelText: Inspection.translate('smileScore'),
                onChanged: (value) {
                  setState(() {
                    myform.serveCust.smileScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.serveCust.greetingScore,
                labelText: Inspection.translate('greetingScore'),
                onChanged: (value) {
                  setState(() {
                    myform.serveCust.greetingScore = value;
                  });
                },
              ),
            ]),
        expansionContainer(name: Inspection.translate('listenCust'), children: [
          makeSliderWidget(
            initialValue: myform.listenCust.listenCustScore,
            labelText: Inspection.translate('listenCustScore'),
            onChanged: (value) {
              setState(() {
                myform.listenCust.listenCustScore = value;
              });
            },
          ),
        ]),
        expansionContainer(name: Inspection.translate('handleCust'), children: [
          makeSliderWidget(
            initialValue: myform.handleCust.indicateWithPalmScore,
            labelText: Inspection.translate('indicateWithPalmScore'),
            onChanged: (value) {
              setState(() {
                myform.handleCust.indicateWithPalmScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.handleCust.respondCustNeedScore,
            labelText: Inspection.translate('respondCustNeedScore'),
            onChanged: (value) {
              setState(() {
                myform.handleCust.respondCustNeedScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.handleCust.unexpectedSituationScore,
            labelText: Inspection.translate('unexpectedSituationScore'),
            onChanged: (value) {
              setState(() {
                myform.handleCust.unexpectedSituationScore = value;
              });
            },
          ),
        ]),
        expansionContainer(
            name: Inspection.translate('farewellScore'),
            children: [
              makeSliderWidget(
                initialValue: myform.closure.farewellScore,
                labelText: Inspection.translate('farewellScore'),
                onChanged: (value) {
                  setState(() {
                    myform.closure.farewellScore = value;
                  });
                },
              ),
            ]),
        expansionContainer(
            name: Inspection.translate('communicationSkill'),
            children: [
              makeSliderWidget(
                initialValue: myform.communicationSkill.soundLevel,
                labelText: Inspection.translate('soundLevel'),
                onChanged: (value) {
                  setState(() {
                    myform.communicationSkill.soundLevel = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.communicationSkill.soundSpeed,
                labelText: Inspection.translate('soundSpeed'),
                onChanged: (value) {
                  setState(() {
                    myform.communicationSkill.soundSpeed = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.communicationSkill.polite,
                labelText: Inspection.translate('polite'),
                onChanged: (value) {
                  setState(() {
                    myform.communicationSkill.polite = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.communicationSkill.attitudeScore,
                labelText: Inspection.translate('attitudeScore'),
                onChanged: (value) {
                  setState(() {
                    myform.communicationSkill.attitudeScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.communicationSkill.skillScore,
                labelText: Inspection.translate('skillScore'),
                onChanged: (value) {
                  setState(() {
                    myform.communicationSkill.skillScore = value;
                  });
                },
              ),
            ]),
        expansionContainer(name: '窩心', children: [
          makeSwitchWidget(
            initialValue: myform.warmHeart.warmHeartScore,
            labelText: Inspection.translate('warmHeartScore'),
            onChanged: (value) {
              setState(() {
                myform.warmHeart.warmHeartScore = value;
              });
            },
          ),
        ])
      ],
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

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
        ),
        body: _asyncLoader);
  }
}

class StaffDialog extends StatefulWidget {
  StaffDialog({@required this.bldgCode});
  final String bldgCode;

  @override
  _StaffDialogState createState() => new _StaffDialogState();
}

class _StaffDialogState extends State<StaffDialog> {
  List<StaffData> _staffList = [];
  List<StaffData> _staffListFiltered = [];
  TextEditingController _filterController = new TextEditingController();
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  getStaff() async {
    await fetchStaffList(new http.Client(), widget.bldgCode).then((staff) {
      _staffList = staff;
    }).catchError((e) => print(e));
  }

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
                      onTap: () => Navigator.of(context).pop(staff),
                      title: new Text(
                        staff.nixonNumber.toString(),
                      ),
                      subtitle: new Text(staff.givenName)),
                ),
              ]));
        });
  }

  Widget body() {
    return new Column(
      children: <Widget>[
        new Container(
            child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              controller: _filterController,
              decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none),
              onChanged: _searchTextChanged,
            ),
            trailing: new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: () {
                  _filterController.clear();
                  _searchTextChanged('');
                }),
          ),
        )),
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
        ),
        body: _asyncLoader);
  }
}

class ViewCleaning extends StatefulWidget {
  @override
  _ViewCleaningState createState() => new _ViewCleaningState();
}

class _ViewCleaningState extends State<ViewCleaning> {
  int showExpansion;
  @override
  void initState() {
    super.initState();
    showExpansion = 0;
    if (myform.postName == '商場') {
      showExpansion = 1;
    } else if (myform.postName == "洗手間") {
      showExpansion = 2;
    }
  }

  Widget expansionContainer({List<Widget> children, String name}) {
    Widget buildTitle() {
      return new Row(children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: new Text(
              name,
            ),
          ),
        ),
      ]);
    }

    return new Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: new ExpansionTile(
        onExpansionChanged: (b) => setState(() {
              PageStorage
                  .of(context)
                  .writeState(context, b, identifier: ValueKey(name));
            }),
        initiallyExpanded: PageStorage
                .of(context)
                .readState(context, identifier: ValueKey(name)) ??
            false,
        title: buildTitle(),
        children: children,
      ),
    );
  }

  Widget makeSwitchWidget(
      {@required String labelText,
      @required int initialValue,
      @required ValueChanged<int> onChanged(value)}) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: new CheckBoxFormField(
          initialValue: initialValue,
          validator: (value) => value == 0 ? '$labelText Not Set' : null,
          onSaved: (value) => print(value),
          labelText: labelText,
          onChanged: (value) => onChanged(value)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showExpansion == 2) {
      return new ListView(
        children: <Widget>[
          expansionContainer(
            name: Inspection.translate('cleanlinessToilet'),
            //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            children: <Widget>[
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_1,
                labelText: Inspection.translate('toilet_1'),
                onChanged: (value) {
                  setState(() {
                    myform.cleanlinessToilet.toilet_1 = value;
                  });
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_2,
                labelText: Inspection.translate('toilet_2'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessToilet.toilet_2 = value;
                    },
                  );
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_3,
                labelText: Inspection.translate('toilet_3'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessToilet.toilet_3 = value;
                    },
                  );
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_4,
                labelText: Inspection.translate('toilet_4'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessToilet.toilet_4 = value;
                    },
                  );
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_5,
                labelText: Inspection.translate('toilet_5'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessToilet.toilet_5 = value;
                    },
                  );
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessToilet.toilet_6,
                labelText: Inspection.translate('toilet_6'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessToilet.toilet_6 = value;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      );
    } else if (showExpansion == 1) {
      return new ListView(
        children: <Widget>[
          expansionContainer(
            name: Inspection.translate('cleanlinessMall'),
            //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            children: <Widget>[
              makeSwitchWidget(
                initialValue: myform.cleanlinessMall.mall_1,
                labelText: Inspection.translate('mall_1'),
                onChanged: (value) {
                  setState(() {
                    myform.cleanlinessMall.mall_1 = value;
                  });
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessMall.mall_2,
                labelText: Inspection.translate('mall_2'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessMall.mall_2 = value;
                    },
                  );
                },
              ),
              makeSwitchWidget(
                initialValue: myform.cleanlinessMall.mall_3,
                labelText: Inspection.translate('mall_3'),
                onChanged: (value) {
                  setState(
                    () {
                      myform.cleanlinessMall.mall_3 = value;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return new ListView(
        children: <Widget>[
          new Text('請選擇崗位', style: Theme.of(context).textTheme.body2)
        ],
      );
    }
  }
}
