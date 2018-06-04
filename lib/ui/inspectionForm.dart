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
      text: '評分',
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
          new ViewGrooming(),
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

  void NavigatePop() {
    Navigator.pop(context);
  }

  void _save(BuildContext context) {
    final form = widget.formKey.currentState;
    if (form.validate()) {
      print('save');
      print(myform);
      print(myform.grooming);
      form.save();
      if (myform.id == null) {
        InspectionRepos.addInspection(myform).then((onValue) {
          showSnackBar('save succesful', bgcolor: Colors.green);
          NavigatePop();
        }).catchError(
            (onError) => showSnackBar(onError.toString(), bgcolor: Colors.red));
      } else {
        InspectionRepos.updateInspection(myform).then((onValue) {
          showSnackBar('save succesful', bgcolor: Colors.green);
          NavigatePop();
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
      _guestsProportionController = new TextEditingController(),
      _foundLocationController = new TextEditingController(),
      _postNameController = new TextEditingController(),
      _nxNumberController = new TextEditingController(),
      _bldgNameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _bldgNameController.text = myform.bldgName.toString();
  }

  void _showD() {
    List<int> _value = [1, 2, 3, 4, 5];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Scaffold(
            body: new ListView.builder(
                itemCount: _value.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    title: new Text(
                      _value[index].toString(),
                      
                    ),onLongPress: ,
                  );
                }),
          );
        }).then((value) {
      if (value != null) {
        setState(() => print(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      children: <Widget>[
        new DateTextField(
          labelText: '日期',
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
                  labelText: '到達時間',
                  initialValue: FormHelper.strToTime(myform.arrivedTime),
                  validator: (value) =>
                      myform.arrivedTime == null ? "not set" : null,
                  onChanged: (value) {
                    myform.arrivedTime = FormHelper.timetoString(value);
                    myform.leaveTime = myform.arrivedTime;
                  },
                  onSaved: (value) => myform.arrivedTime = FormHelper
                      .timetoString(value) //FormHelper.timetoString(value)),
                  ),
            ),
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: '離開時間',
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
            suffixIcon:
                new IconButton(icon: new Icon(Icons.search), onPressed: _showD),
            labelText: '大廈名稱',
          ),
          controller: _bldgNameController,
          onFieldSubmitted: (value) => _bldgNameController.text = value,
          validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
          onSaved: (value) => myform.bldgName = value,
        ),
        MyFormTextField(
          labelText: '員工編號',
          initialValue: myform.nixonNumber.toString(),
          controller: _nxNumberController,
          nullable: true,
          onSave: (value) => myform.nixonNumber = FormHelper.strToInt(value),
          keyboardType: TextInputType.number,
        ),
        MyFormTextField(
            labelText: '員工姓名',
            initialValue: myform.staffName,
            controller: _staffNameController,
            nullable: false,
            onSave: (value) => myform.staffName = value),
        new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: MyFormTextField(
                  labelText: '位置',
                  initialValue: myform.foundLocation,
                  controller: _foundLocationController,
                  onSave: (value) => myform.foundLocation = value),
            ),
            new Expanded(
              flex: 1,
              child: MyFormTextField(
                  labelText: '崗位',
                  initialValue: myform.postName,
                  controller: _postNameController,
                  onSave: (value) => myform.postName = value),
            ),
          ],
        ),
        MyFormTextField(
            labelText: '顧客比例',
            initialValue: myform.guestsProportion,
            controller: _guestsProportionController,
            onSave: (value) => myform.guestsProportion = value),
        MyFormTextField(
            labelText: '摘要',
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

class ViewGrooming extends StatefulWidget {
  @override
  _ViewGroomingState createState() => new _ViewGroomingState();
}

class _ViewGroomingState extends State<ViewGrooming>
    with AutomaticKeepAliveClientMixin {
  Widget cardContainer({List<Widget> children, Widget title}) {
    return new Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
      child: new Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: new ExpansionTile(
          onExpansionChanged: (b) => setState(() {
                PageStorage
                    .of(context)
                    .writeState(context, b, identifier: ValueKey(title));
              }),
          initiallyExpanded: PageStorage
                  .of(context)
                  .readState(context, identifier: ValueKey(title)) ??
              false,
          title: title,
          children: children,
        ),
      ),
    );
  }

  Widget makeSliderWidget(
      {@required String labelText,
      @required int initialValue,
      @required ValueChanged<int> onChanged(value)}) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
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
        cardContainer(title: new Text('儀容'),
            //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            children: <Widget>[
              makeSliderWidget(
                initialValue: myform.grooming.groomingScore,
                labelText: "儀容",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.groomingScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.hairScore,
                labelText: "髮型",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.hairScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.uniformScore,
                labelText: "制服",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.uniformScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.decorationScore,
                labelText: "飾物",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.decorationScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.maskWearScore,
                labelText: "口罩技巧",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.maskWearScore = value;
                  });
                },
              ),
              makeSliderWidget(
                initialValue: myform.grooming.maskCleanScore,
                labelText: "口罩清潔",
                onChanged: (value) {
                  setState(() {
                    myform.grooming.maskCleanScore = value;
                  });
                },
              )
            ]),
        cardContainer(
          title: new Text('舉止'),
          children: <Widget>[
            makeSliderWidget(
              initialValue: myform.behavior.behaviorScore,
              labelText: "行為舉止",
              onChanged: (value) {
                setState(() {
                  myform.behavior.behaviorScore = value;
                });
              },
            ),
            makeSliderWidget(
              initialValue: myform.behavior.mindScore,
              labelText: "精神狀態",
              onChanged: (value) {
                setState(() {
                  myform.behavior.mindScore = value;
                });
              },
            ),
          ],
        ),
        cardContainer(title: new Text('接待顧客'), children: [
          makeSliderWidget(
            initialValue: myform.serveCust.smileScore,
            labelText: '向客人展露笑容',
            onChanged: (value) {
              setState(() {
                myform.serveCust.smileScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.serveCust.greetingScore,
            labelText: '打招呼',
            onChanged: (value) {
              setState(() {
                myform.serveCust.greetingScore = value;
              });
            },
          ),
        ]),
        cardContainer(title: new Text('了解需要'), children: [
          makeSliderWidget(
            initialValue: myform.listenCust.listenCustScore,
            labelText: '聆聽',
            onChanged: (value) {
              setState(() {
                myform.listenCust.listenCustScore = value;
              });
            },
          ),
        ]),
        cardContainer(title: new Text('處理顧客需要'), children: [
          makeSliderWidget(
            initialValue: myform.handleCust.indicateWithPalmScore,
            labelText: '使用手掌指示方向',
            onChanged: (value) {
              setState(() {
                myform.handleCust.indicateWithPalmScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.handleCust.respondCustNeedScore,
            labelText: '回應顧客需要',
            onChanged: (value) {
              setState(() {
                myform.handleCust.respondCustNeedScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.handleCust.unexpectedSituationScore,
            labelText: '處理突發事件技巧和反應',
            onChanged: (value) {
              setState(() {
                myform.handleCust.unexpectedSituationScore = value;
              });
            },
          ),
        ]),
        cardContainer(title: new Text('結束對話'), children: [
          makeSliderWidget(
            initialValue: myform.closure.farewellScore,
            labelText: '��別',
            onChanged: (value) {
              setState(() {
                myform.closure.farewellScore = value;
              });
            },
          ),
        ]),
        cardContainer(title: new Text('溝通能力'), children: [
          makeSliderWidget(
            initialValue: myform.communicationSkill.soundLevel,
            labelText: '說話聲量',
            onChanged: (value) {
              setState(() {
                myform.communicationSkill.soundLevel = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.communicationSkill.soundSpeed,
            labelText: '說話速度',
            onChanged: (value) {
              setState(() {
                myform.communicationSkill.soundSpeed = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.communicationSkill.polite,
            labelText: '用詞及禮貌',
            onChanged: (value) {
              setState(() {
                myform.communicationSkill.polite = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.communicationSkill.attitudeScore,
            labelText: '說話態度',
            onChanged: (value) {
              setState(() {
                myform.communicationSkill.attitudeScore = value;
              });
            },
          ),
          makeSliderWidget(
            initialValue: myform.communicationSkill.skillScore,
            labelText: '溝通技巧',
            onChanged: (value) {
              setState(() {
                myform.communicationSkill.skillScore = value;
              });
            },
          ),
        ]),
        cardContainer(title: new Text('窩心'), children: [
          makeSwitchWidget(
            initialValue: myform.warmHeart.warmHeartScore,
            labelText: '窩心',
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
