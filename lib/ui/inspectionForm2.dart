import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void _save() {
    print('save');
    print(myform);
    print(myform.grooming);
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (myform.id == null) {
        _addRecord();
      } else {
        _updateRecord();
      }
    }
  }

  void _addRecord() {
    repos.addInspection(myform).then((bool result) {
      Navigator.pop(context);
    }).catchError((onError) => FormHelper.showAlertDialog(
        context, "Error on Save", onError.toString()));
  }

  void _updateRecord() {
    repos.updateInspection(myform).then((bool result) {
      Navigator.pop(context);
    }).catchError((onError) => FormHelper.showAlertDialog(
        context, "Error on Save", onError.toString()));
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
  TextEditingController _formDateController = new TextEditingController(),
      _staffNameController = new TextEditingController(),
      _leaveTimeController = new TextEditingController(),
      _arrivedTimeController = new TextEditingController(),
      _situationRemarkController = new TextEditingController(),
      _guestsProportionController = new TextEditingController(),
      _foundLocationController = new TextEditingController(),
      _postNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new DateTextField(
          labelText: '日期',
          initialValue: FormHelper
              .datetoString(myform.inspectionDate ?? new DateTime.now()),
          controller: _formDateController,
          onSave: (value) =>
              myform.inspectionDate = FormHelper.strToDate(value),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: TimeTextField(
                    labelText: '到達時間',
                    initialValue: myform.arrivedTime,
                    controller: _arrivedTimeController,
                    onSave: (value) => myform.arrivedTime =
                        value //FormHelper.timetoString(value)),
                    )),
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: '離開時間',
                  initialValue: myform.leaveTime,
                  controller: _leaveTimeController,
                  onSave: (value) => myform.leaveTime =
                      value // FormHelper.timetoString(value))),
                  ),
            ),
          ],
        ),
        MyFormTextField(
            labelText: '員工姓名',
            initialValue: myform.staffName,
            controller: _staffNameController,
            onSave: (value) => myform.staffName = value),
        MyFormTextField(
            labelText: '位置',
            initialValue: myform.foundLocation,
            controller: _foundLocationController,
            onSave: (value) => myform.foundLocation = value),
        MyFormTextField(
            labelText: '崗位',
            initialValue: myform.postName,
            controller: _postNameController,
            onSave: (value) => myform.postName = value),
        MyFormTextField(
            labelText: '處境摘要',
            initialValue: myform.situationRemark,
            controller: _situationRemarkController,
            onSave: (value) => myform.situationRemark = value),
        MyFormTextField(
            labelText: '顧客比例',
            initialValue: myform.guestsProportion,
            controller: _guestsProportionController,
            onSave: (value) => myform.guestsProportion = value),
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

class _ViewGroomingState extends State<ViewGrooming> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        children: <Widget>[
          new SliderFormField(
            intialValue: 0.0,
            labelText: "儀容",
            onSave: (value) => myform.grooming.groomingScore = value.toInt(),
          ),
          new SliderFormField(
            intialValue: 0.0,
            labelText: "髮型",
            onSave: (value) => myform.grooming.hairScore = value.toInt(),
          ),
          new SliderFormField(
            intialValue: 0.0,
            labelText: "制服",
            onSave: (value) => myform.grooming.uniformScore = value.toInt(),
          ),
          new SliderFormField(
            intialValue: 0.0,
            labelText: "配載飾物",
            onSave: (value) => myform.grooming.decorationScore = value.toInt(),
          ),
          new SliderFormField(
            intialValue: 0.0,
            labelText: "口罩配帶技巧",
            onSave: (value) => myform.grooming.maskWearScore = value.toInt(),
          ),
          new SliderFormField(
            intialValue: 0.0,
            labelText: "口罩清潔",
            onSave: (value) => myform.grooming.maskCleanScore = value.toInt(),
          ),
        ]);
  }
}

class SliderFormField extends StatefulWidget {
  SliderFormField(
      {this.intialValue, this.onSave, this.labelText, this.controller});
  final double intialValue;
  final Function onSave;
  final TextEditingController controller;
  final String labelText;

  @override
  _SliderFormFieldState createState() => new _SliderFormFieldState();
}

class _SliderFormFieldState extends State<SliderFormField> {
  @override
  Widget build(BuildContext context) {
    return new FormField<double>(
        initialValue: widget.intialValue,
        onSaved: widget.onSave,
        validator: (value) =>
            value < 0 ? '${widget.labelText} can\'t be empty' : null,
        builder: (FormFieldState<double> field) {
          return new InputDecorator(
              decoration: new InputDecoration(
                  labelStyle: _labelStyle,
                  labelText: widget.labelText,
                  border: InputBorder.none),
              child: new Slider(
                min: 0.0,
                max: 100.0,
                divisions: 5,
                activeColor: Colors.red[100 + (field.value * 5.0).round()],
                label: '${field.value.round()}',
                value: field.value,
                onChanged: field.didChange,
              ));
        });
  }
}

var _labelStyle = new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
var _textStyle = new TextStyle(fontSize: 25.0, color: Colors.black);

class DateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Function onSave;
  DateTextField(
      {this.controller, this.initialValue, this.labelText, this.onSave});

  @override
  _DateTextFieldState createState() => new _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return new Row(children: [
      new Expanded(
        child: new TextFormField(
          style: _textStyle,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: _labelStyle,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) =>
              value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
          onSaved: widget.onSave,
        ),
      ),
      new IconButton(
        icon: new Icon(Icons.arrow_drop_down),
        onPressed: () => selectDate(context),
      )
    ]);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          widget.controller.text = FormHelper.datetoString(picked);
        },
      );
    }
  }
}

class TimeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Function onSave;
  TimeTextField(
      {this.controller, this.initialValue, this.labelText, this.onSave});

  @override
  _TimeTextFieldState createState() => new _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  @override
  Widget build(BuildContext context) {
    return new Row(children: [
      new Expanded(
        child: new TextFormField(
          style: _textStyle,
          controller: widget.controller,
          decoration: InputDecoration(
            labelStyle: _labelStyle,
            labelText: widget.labelText,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) =>
              value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
          onSaved: widget.onSave,
        ),
      ),
      new IconButton(
          icon: new Icon(Icons.arrow_drop_down),
          onPressed: () => selectTime(context,
              initialTime: widget.controller.text.isNotEmpty
                  ? FormHelper.strToTime(widget.controller.text)
                  : TimeOfDay.now()))
    ]);
  }

  selectTime(BuildContext context, {TimeOfDay initialTime}) async {
    final TimeOfDay picked = await FormHelper.selectTimeDialog(
        ctx: context, initialTime: initialTime);
    if (picked != null) {
      setState(
        () {
          widget.controller.text = FormHelper.timetoString(picked);
        },
      );
    }
  }
}

class MyFormTextField extends StatefulWidget {
  MyFormTextField(
      {this.labelText, this.initialValue, this.onSave, this.controller});
  final String labelText;
  final TextEditingController controller;
  final Function onSave;
  final String initialValue;

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
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: _labelStyle,
      ),
      style: _textStyle,
      controller: widget.controller,
      validator: (value) =>
          value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
      onSaved: widget.onSave,
    );
  }
}
