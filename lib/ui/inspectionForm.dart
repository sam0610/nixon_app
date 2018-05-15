import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nixon_app/ui/components/SliderField.dart';
import '../Helper/formHelper.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';
import 'components/DateField.dart';
import 'components/TimeField.dart';
import 'components/FormTextField.dart';

bool _autoValidate = false;

class InspectionForm extends StatefulWidget {
  InspectionForm({Key key, this.form}) : super(key: key);
  final Inspection form;
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

Inspection myform;

class _InspectionFormState extends State<InspectionForm>
    with SingleTickerProviderStateMixin {
  InspectionRepos repos;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    new Tab(
      text: 'Info',
    ),
    new Tab(
      text: 'Grooming',
    )
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(initialIndex: 0, length: myTabs.length, vsync: this);
    myform = widget.form;
    if (myform.grooming == null) myform.grooming = new Grooming();
    //_formDateController.text =
    //    FormHelper.datetoString(myform.inspectionDate ?? new DateTime.now());
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) repos = new InspectionRepos.forUser(user: user);
    });
  }

  bool formValidated() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void _save() {
    print('save');
    print(myform);
    print(myform.grooming);
    setState(() {
      _autoValidate = true;
    });
    final form = _formKey.currentState;
    if (formValidated()) {
      form.save();

      if (myform.id == null) {
        repos
            .addInspection(myform)
            .then((onValue) => Navigator.of(context).pop())
            .catchError((onError) => FormHelper.showAlertDialog(
                context, 'Fail', onError.toString()));
      } else {
        repos
            .updateInspection(myform)
            .then((onValue) => Navigator.of(context).pop())
            .catchError((onError) => FormHelper.showAlertDialog(
                context, 'Fail', onError.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Form2"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            color: Colors.red,
            onPressed: _save,
          ),
        ],
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: new TabBarView(
              controller: _tabController,
              children: <Widget>[new ViewInfo(), new ViewGrooming()]),
        ),
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
      _postNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      children: <Widget>[
        new DateTextField(
          labelText: '日期',
          initialValue: myform.inspectionDate,
          autoValidate: _autoValidate,
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
                  autoValidate: _autoValidate,
                  validator: (value) =>
                      myform.arrivedTime == null ? "not set" : null,
                  onChanged: (value) {
                    myform.arrivedTime = FormHelper.timetoString(value);
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
                  autoValidate: _autoValidate,
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
        MyFormTextField(
            labelText: '員工姓名',
            initialValue: myform.staffName,
            controller: _staffNameController,
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
            labelText: '處境摘要',
            initialValue: myform.situationRemark,
            maxLines: 3,
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
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new ExpansionTile(title: new Text('Grooming'),
            //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            children: <Widget>[
              new SliderField(
                initialValue: myform.grooming.groomingScore,
                labelText: "儀容",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.groomingScore = value;
                  });
                },
              ),
              new SliderField(
                initialValue: myform.grooming.hairScore,
                labelText: "髮型",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.hairScore = value;
                  });
                },
              ),
              new SliderField(
                initialValue: myform.grooming.uniformScore,
                labelText: "制服",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.uniformScore = value;
                  });
                },
              ),
              new SliderField(
                initialValue: myform.grooming.decorationScore,
                labelText: "飾物",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.decorationScore = value;
                  });
                },
              ),
              new SliderField(
                initialValue: myform.grooming.maskWearScore,
                labelText: "口罩技巧",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.maskWearScore = value;
                  });
                },
              ),
              new SliderField(
                initialValue: myform.grooming.maskCleanScore,
                labelText: "口罩清潔",
                onChanged: (int value) {
                  setState(() {
                    myform.grooming.maskCleanScore = value;
                  });
                },
              )
            ]),
      ],
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
