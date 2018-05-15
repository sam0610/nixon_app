import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nixon_app/ui/components/SliderField.dart';

import '../Helper/formHelper.dart';
import '../Models/Inspection.dart';
import '../Models/InspectionRepository.dart';

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
          autovalidate: false,
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
                  initialValue: myform.arrivedTime,
                  onChanged: (value) => myform.arrivedTime = value,
                  onSaved: (value) => myform.arrivedTime = FormHelper
                      .timetoString(value) //FormHelper.timetoString(value)),
                  ),
            ),
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: '離開時間',
                  initialValue: myform.leaveTime,
                  onChanged: (value) => myform.leaveTime = value,
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

class DateTextField extends StatefulWidget {
  final String labelText;
  final DateTime initialValue;
  final ValueChanged<DateTime> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  DateTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  _DateTextFieldState createState() => new _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  DateTime _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.initialValue ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return new InputDecorator(
        decoration: new InputDecoration(
            labelText: widget.labelText, border: InputBorder.none),
        child: new FormField<DateTime>(
          initialValue: _value,
          validator: widget.validator,
          onSaved: (DateTime value) => widget.onSaved(value),
          builder: (FormFieldState<DateTime> field) {
            return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                color: Theme.of(context).accentColor,
                onPressed: () => selectDate(context),
                child: new Text(FormHelper.datetoString(_value)),
              ),
            );
          },
        ));
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          _value = picked;
          widget.onChanged(picked);
        },
      );
    }
  }
}

class TimeTextField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final Function onSaved;
  TimeTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  _TimeTextFieldState createState() => new _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  TimeOfDay _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = widget.initialValue != null
        ? FormHelper.strToTime(widget.initialValue)
        : TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return new InputDecorator(
        decoration: new InputDecoration(
            labelText: widget.labelText, border: InputBorder.none),
        child: new FormField<TimeOfDay>(
          initialValue: _value,
          validator: (TimeOfDay value) => widget.initialValue == null
              ? '${widget.labelText}cant be empty'
              : null,
          onSaved: (TimeOfDay value) => widget.onSaved(value),
          builder: (FormFieldState<TimeOfDay> field) {
            return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                color: Theme.of(context).accentColor,
                onPressed: () => selectTime(context, initialTime: _value),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.timer),
                    new Padding(
                      padding: EdgeInsets.only(right: 5.0),
                    ),
                    new Text(FormHelper.timetoString(_value)),
                  ],
                ),
              ),
            );
          },
        ));
  }

  selectTime(BuildContext context, {TimeOfDay initialTime}) async {
    final TimeOfDay picked = await FormHelper.selectTimeDialog(
        ctx: context, initialTime: initialTime);
    if (picked != null) {
      setState(
        () {
          _value = picked;
        },
      );
    }
  }
}

class MyFormTextField extends StatefulWidget {
  MyFormTextField(
      {this.labelText,
      this.initialValue,
      this.onSave,
      this.controller,
      this.maxLines = 1});
  final String labelText;
  final TextEditingController controller;
  final Function onSave;
  final String initialValue;
  final int maxLines;

  @override
  _MyFormTextFieldState createState() => new _MyFormTextFieldState();
}

class _MyFormTextFieldState extends State<MyFormTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      controller: widget.controller,
      validator: (value) =>
          value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
      onSaved: widget.onSave,
    );
  }
}
